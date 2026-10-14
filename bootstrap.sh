#!/usr/bin/env bash

#   o  o
# \______/
#   |
#      |    https://conten.to
# --------

set -euo pipefail

PYTHON_VERSION="3.12"   # LTS-class; security support until 2028

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
logs_folder="$script_dir/logs"
mkdir -p "$logs_folder"

logfile_path="$logs_folder/$(basename "${BASH_SOURCE[0]}" .sh)-$(date +%Y-%m-%d).log"

# Every package, its tier, and its name per package manager. See the header
# of that file for the column format.
packages_file="$script_dir/packages.txt"

# --- Parse command-line arguments ----------------

dry_run=false
no_brew_installation=false
no_terminal=false
minimum=true   # default: install only the minimum tool set

for arg in "$@"; do
    case $arg in
    --dry-run)
        dry_run=true
        ;;
    --no-brew)
        no_brew_installation=true
        ;;
    --no-terminal)
        no_terminal=true
        ;;
    --all)
        minimum=false
        ;;
    --minimum)
        minimum=true
        ;;
    --help)
        echo "Usage: $0 [--dry-run] [--no-brew] [--no-terminal] [--all|--minimum]"
        echo ""
        echo "Options:"
        echo "  --dry-run       Simulate installation without making changes"
        echo "  --no-brew       Skip Homebrew installation"
        echo "  --no-terminal   Skip terminal/shell setup"
        echo "  --minimum       Install only the minimum tool set (default)"
        echo "  --all           Install the full tool set"
        echo "  --help          Show this help message"
        exit 0
        ;;
    *)
        echo "Unknown option: $arg" && exit 1
        ;;
    esac
done

# --- Helpers ----------------

# Echo a message to stdout and append it to the logfile.
log() { echo "$@" | tee -a "$logfile_path"; }

# Run a command, or just log what would have run when --dry-run is set.
run_cmd() {
    if [[ "$dry_run" == true ]]; then
        log "[dry-run] $*"
    else
        "$@"
    fi
}

# Prompt for sudo once, then keep the credential cache warm for the rest
# of the script. Without this, slow brew/apt steps let the 5-minute sudo
# cache expire and the password gets re-prompted mid-install.
keep_sudo_alive() {
    sudo -v
    # Verify the cache actually works before spawning the keeper.
    # If timestamp_timeout=0 is set in sudoers, -n will always fail and
    # every subsequent sudo call will re-prompt — warn rather than silently loop.
    if ! sudo -n true 2>/dev/null; then
        log "**** WARNING: sudo cache not working (timestamp_timeout may be 0). You may be prompted for your password multiple times."
        return
    fi
    ( while kill -0 "$$" 2>/dev/null; do
        sudo -n true 2>/dev/null
        sleep 50
      done ) &
}

# --- Mode banners ----------------

if [[ "$dry_run" == true ]]; then
    log "**** DRY RUN — no changes will be made ****"
fi

if [[ "$minimum" == true ]]; then
    log "**** MINIMUM tool set (use --all to install everything)"
else
    log "**** FULL tool set (--all)"
fi

# --- Util ------------------------

install_python() {
    local ver="$PYTHON_VERSION"
    log "**** Installing Python $ver ..."

    if [[ "$OSTYPE" == "darwin"* ]]; then
        install_with_brew_formula "python@$ver"
    elif [[ -f /etc/debian_version ]]; then
        # deadsnakes PPA provides older/newer Python builds on Ubuntu
        if ! dpkg-query -W -f='${Status}' "python$ver" 2>/dev/null | grep -q "install ok installed"; then
            if ! apt-cache show "python$ver" >/dev/null 2>&1; then
                log "**** Adding deadsnakes PPA for Python $ver ..."
                run_cmd sudo apt-get install -y software-properties-common
                run_cmd sudo add-apt-repository -y ppa:deadsnakes/ppa
                run_cmd sudo apt-get update -qq
            fi
            run_cmd sudo apt-get install -y "python$ver" "python$ver-venv" "python$ver-dev"
        else
            log "**** python$ver is already installed"
        fi
        # Make python3 / python point to the pinned version
        run_cmd sudo update-alternatives --install /usr/bin/python3 python3 "/usr/bin/python$ver" 1
        run_cmd sudo update-alternatives --set python3 "/usr/bin/python$ver"
    elif [[ -f /etc/arch-release ]]; then
        local pkg="python${ver/./}"   # "3.12" → "python312"
        install_with_yay "$pkg"
    elif [[ -f /etc/fedora-release ]]; then
        # Fedora ships alternate Python versions as python3.X packages (venv
        # is built in). Leave /usr/bin/python3 alone: dnf and other system
        # tools depend on the distro's default interpreter.
        install_with_dnf "python$ver"
        install_with_dnf "python$ver-devel"
    else
        log "**** WARNING: unsupported platform for Python $ver install"
    fi
}

install_tmux_plugin_manager() {
    log "**** Installing tmux plugin manager ..."

    if ! command -v tmux &> /dev/null; then
        log "**** tmux is not installed. Skipping TPM."
        return 0
    fi

    if [[ -d "$HOME/.tmux/plugins/tpm" ]]; then
        log "**** tmux plugin manager already installed"
        return 0
    fi

    run_cmd git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}

install_nvm() {
    log "**** Installing nvm (Node Version Manager) ..."

    if command -v nvm &>/dev/null; then
        log "**** nvm already installed"
        return 0
    fi

    # Create the nvm config directory if it doesn't exist (needed by shell configs for .nvmrc)
    run_cmd mkdir -p "$HOME/.config/nvm"

    # Try Homebrew first
    if command -v brew &>/dev/null; then
        log "**** Attempting to install nvm via Homebrew ..."
        if run_cmd brew install nvm 2>&1 | tee -a "$logfile_path"; then
            # Source nvm and install default Node version (from .nvmrc if available)
            if [[ "$dry_run" != true ]]; then
                # shellcheck disable=SC1090
                local nvm_prefix
                nvm_prefix="$(brew --prefix nvm)"
                [ -s "$nvm_prefix/nvm.sh" ] && . "$nvm_prefix/nvm.sh"

                if command -v nvm &>/dev/null; then
                    # Read version from .nvmrc or fall back to a sensible default
                    local nvmrc_version
                    nvmrc_version=$(cat "$HOME/.config/nvm/.nvmrc" 2>/dev/null | tr -d '[:space:]')
                    nvmrc_version=${nvmrc_version:-lts/*}
                    log "**** Installing default Node version ($nvmrc_version) ..."
                    nvm install "$nvmrc_version" 2>&1 | tee -a "$logfile_path"
                fi
            fi
            return 0
        fi
    fi

    # Fallback: clone from git. Clone into a temp dir and copy the contents in,
    # because ~/.config/nvm may already exist and be non-empty (the nvm stow
    # package puts .nvmrc there) and git refuses to clone into a non-empty dir.
    log "**** Homebrew unavailable or failed; cloning nvm from git ..."
    if [[ "$dry_run" == true ]]; then
        log "[dry-run] git clone https://github.com/nvm-sh/nvm.git <tmpdir> && cp -R <tmpdir>/. ~/.config/nvm"
    else
        local nvm_tmp
        nvm_tmp=$(mktemp -d)
        run_cmd git clone https://github.com/nvm-sh/nvm.git "$nvm_tmp" 2>&1 | tee -a "$logfile_path"
        run_cmd cp -R "$nvm_tmp/." "$HOME/.config/nvm/"
        rm -rf "$nvm_tmp"

        # Source nvm and install default Node version (from .nvmrc if available)
        # shellcheck disable=SC1090
        [ -s "$HOME/.config/nvm/nvm.sh" ] && . "$HOME/.config/nvm/nvm.sh"

        if command -v nvm &>/dev/null; then
            # Read version from .nvmrc or fall back to a sensible default
            local nvmrc_version
            nvmrc_version=$(cat "$HOME/.config/nvm/.nvmrc" 2>/dev/null | tr -d '[:space:]')
            nvmrc_version=${nvmrc_version:-lts/*}
            log "**** Installing default Node version ($nvmrc_version) ..."
            nvm install "$nvmrc_version" 2>&1 | tee -a "$logfile_path"
        fi
    fi
}

install_yay() {
    if [[ ! -f /etc/arch-release ]]; then
        return
    fi

    if command -v yay &> /dev/null; then
        log "**** yay is already installed"
        return 0
    fi

    log "**** Installing yay ..."
    if [[ "$dry_run" == true ]]; then
        log "[dry-run] sudo pacman -S --needed git base-devel"
        log "[dry-run] git clone https://aur.archlinux.org/yay.git /tmp/yay && cd /tmp/yay && makepkg -si"
        return 0
    fi

    sudo pacman -S --needed git base-devel
    local tmpdir
    tmpdir=$(mktemp -d)
    git clone https://aur.archlinux.org/yay.git "$tmpdir/yay"
    (cd "$tmpdir/yay" && makepkg -si)
    rm -rf "$tmpdir"
}

install_brew() {
    if [[ "$no_brew_installation" == true ]]; then
        log "**** Skipping brew installation ..."
        if [[ "$OSTYPE" == "darwin"* ]]; then
            log "**** brew is required on Mac"
            exit 1
        fi
        return
    fi

    # On Linux, minimum mode skips brew entirely: all minimum tools are
    # available via apt/dnf/yay, so the ~500MB brew install is unnecessary.
    # Mac still needs brew (it's the only package manager).
    if [[ "$minimum" == true ]] && [[ "$OSTYPE" == "linux-gnu"* ]]; then
        log "**** Skipping brew installation (minimum mode on Linux uses apt/dnf/yay)"
        return
    fi

    if command -v brew &> /dev/null; then
        log "**** brew is already installed"
        return 0
    fi

    log "**** Installing brew ..."

    if [[ "$dry_run" == true ]]; then
        log "[dry-run] /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        return 0
    fi

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" 2>&1 | tee -a "$logfile_path"

    # Activate brew in the current shell session after install
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
            eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        elif [[ -f "$HOME/.linuxbrew/bin/brew" ]]; then
            eval "$("$HOME/.linuxbrew/bin/brew" shellenv)"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        if [[ -f /opt/homebrew/bin/brew ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [[ -f /usr/local/bin/brew ]]; then
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    else
        log "**** Unsupported OS: $OSTYPE"
        exit 1
    fi
}

install_with_yay() {
    local pkg=$1
    local app=${2:-$1}
    log "**** Checking if $app is already installed ..."

    # -Qi is an exact package lookup; -Qs regex-matches names AND descriptions
    # (e.g. "vim" would falsely match neovim)
    if pacman -Qi "$pkg" > /dev/null 2>&1; then
        log "**** $app is already installed"
        return 0
    fi

    log "**** Trying 'yay -S $pkg' ..."
    if ! run_cmd yay -S --noconfirm "$pkg" 2>&1 | tee -a "$logfile_path"; then
        log "**** Failed to install $app with yay, trying with brew..."
        run_cmd brew install "$app" 2>&1 | tee -a "$logfile_path" || \
            log "**** WARNING: Could not install $app via yay or brew, skipping"
    fi
}

# Native installers take the package name for that manager ($1) and the
# manifest name ($2, defaults to $1), which is used in logs and as the brew
# formula to fall back to.
install_with_apt() {
    local pkg=$1
    local app=${2:-$1}

    log "**** Checking if $app is already installed ..."

    if dpkg-query -W -f='${Status}' "$pkg" 2>/dev/null | grep -q "install ok installed"; then
        log "**** $app is already installed"
        return 0
    fi

    log "**** Trying 'apt install $pkg' ..."
    if ! run_cmd sudo apt install -y "$pkg" 2>&1 | tee -a "$logfile_path"; then
        log "**** Failed to install $app with apt, trying with brew..."
        run_cmd brew install "$app" 2>&1 | tee -a "$logfile_path" || \
            log "**** WARNING: Could not install $app via apt or brew, skipping"
    fi
}

install_with_dnf() {
    local pkg=$1
    local app=${2:-$1}

    log "**** Checking if $app is already installed ..."

    # --whatprovides also matches virtual provides (e.g. golang, python3-pip)
    if rpm -q --whatprovides "$pkg" > /dev/null 2>&1; then
        log "**** $app is already installed"
        return 0
    fi

    log "**** Trying 'dnf install $pkg' ..."
    if ! run_cmd sudo dnf install -y "$pkg" 2>&1 | tee -a "$logfile_path"; then
        log "**** Failed to install $app with dnf, trying with brew..."
        run_cmd brew install "$app" 2>&1 | tee -a "$logfile_path" || \
            log "**** WARNING: Could not install $app via dnf or brew, skipping"
    fi
}

install_with_brew_formula() {
    local app=$1
    if [[ "$dry_run" != true ]] && brew list "$app" &>/dev/null; then
        log "**** $app is already installed"
        return 0
    fi
    log "**** Trying 'brew install $app' ..."
    run_cmd brew install "$app" 2>&1 | tee -a "$logfile_path" || \
        log "**** WARNING: Could not install $app via brew, skipping"
}

install_with_brew_cask() {
    local app=$1
    if [[ "$dry_run" != true ]] && brew list --cask "$app" &>/dev/null; then
        log "**** $app is already installed"
        return 0
    fi
    log "**** Trying 'brew install --cask $app' ..."
    run_cmd brew install --cask "$app" 2>&1 | tee -a "$logfile_path" || \
        log "**** WARNING: Could not install $app via brew cask, skipping"
}

# -- Package manifest ---------------------------------

# Install every package in $packages_file for the current tier, using the
# column for package manager $1 (brew, apt, dnf, or yay).
install_packages() {
    local pm=$1
    local name tier brew apt dnf yay extra pkg line_no=0

    # Plain `read` (no mapfile/associative arrays) so this runs on macOS's
    # stock bash 3.2 before Homebrew exists. The manifest is read on fd 3 so
    # installers that read stdin (sudo, yay, brew) can't consume its lines.
    while read -r name tier brew apt dnf yay extra <&3; do
        line_no=$((line_no + 1))
        [[ -z "$name" || "$name" == \#* ]] && continue

        if [[ -z "$yay" || "$yay" == \#* || ( -n "$extra" && "$extra" != \#* ) ]]; then
            log "**** ERROR: $packages_file:$line_no: expected 6 columns: $name $tier $brew $apt $dnf $yay $extra"
            exit 1
        fi
        case "$tier" in
            min) ;;
            full) [[ "$minimum" == true ]] && continue ;;
            *) log "**** ERROR: $packages_file:$line_no: unknown tier '$tier'"; exit 1 ;;
        esac

        case "$pm" in
            brew) pkg=$brew ;;
            apt)  pkg=$apt ;;
            dnf)  pkg=$dnf ;;
            yay)  pkg=$yay ;;
        esac

        case "$pkg" in
            -)      ;;
            cask:*) install_with_brew_cask "${pkg#cask:}" ;;
            fn:*)   "install_${pkg#fn:}" ;;
            brew)   install_with_brew_formula "$name" ;;
            *)
                if [[ "$pm" == brew ]]; then
                    install_with_brew_formula "$pkg"
                else
                    "install_with_$pm" "$pkg" "$name"
                fi
                ;;
        esac
    done 3< "$packages_file"
}

install_mac_apps() {
    install_packages brew
}

install_linux_apps() {
    if [[ -f /etc/arch-release ]]; then
        install_packages yay
    elif [[ -f /etc/debian_version ]]; then
        # Refresh package index before installing on Debian/Ubuntu
        log "**** Updating apt package index ..."
        run_cmd sudo apt-get update -qq
        install_packages apt
    elif [[ -f /etc/fedora-release ]]; then
        install_packages dnf
    else
        log "**** WARNING: unsupported Linux distro, skipping packages"
    fi
}

# -- Custom installers (fn: entries in the manifest) ----

# Fedora does not include Ghostty in its default repositories.
install_ghostty_copr() {
    if command -v ghostty &>/dev/null; then
        log "**** ghostty is already installed"
        return 0
    fi

    log "**** Enabling Fedora COPR repository scottames/ghostty ..."
    if ! run_cmd sudo dnf copr enable -y scottames/ghostty 2>&1 | tee -a "$logfile_path"; then
        log "**** WARNING: Could not enable the Ghostty COPR repository, skipping"
        return 0
    fi

    log "**** Installing ghostty from Fedora COPR ..."
    run_cmd sudo dnf install -y ghostty 2>&1 | tee -a "$logfile_path" || \
        log "**** WARNING: Could not install ghostty from Fedora COPR, skipping"
}

# Ubuntu/Debian and Fedora use signed packages from VeraCrypt's official
# GitHub releases; Arch installs from its repositories.
install_veracrypt_official() (
    if command -v veracrypt &>/dev/null; then
        log "**** veracrypt is already installed"
        return 0
    fi

    local distro_id distro_version platform manager arch version tag asset
    local release_url signature_url key_url key_fingerprint tmpdir package_file
    local signature_file key_file gpg_home

    # Read the distro identifiers used to select VeraCrypt's matching package.
    . /etc/os-release
    distro_id=${ID:-}
    distro_version=${VERSION_ID:-}

    case "$distro_id" in
        ubuntu)
            platform="Ubuntu-$distro_version"
            manager=apt
            ;;
        debian)
            platform="Debian-${distro_version%%.*}"
            manager=apt
            ;;
        fedora)
            platform="Fedora-$distro_version"
            manager=dnf
            ;;
        *)
            log "**** WARNING: No VeraCrypt release package is configured for $distro_id, skipping"
            return 0
            ;;
    esac

    case "$(uname -m)" in
        x86_64|amd64)
            if [[ "$manager" == apt ]]; then
                arch=amd64
            else
                arch=x86_64
            fi
            ;;
        *)
            log "**** WARNING: No VeraCrypt $platform package for architecture $(uname -m), skipping"
            return 0
            ;;
    esac

    log "**** Resolving the latest VeraCrypt release ..."
    if ! tag=$(curl -fsSL https://api.github.com/repos/veracrypt/VeraCrypt/releases/latest |
        sed -n 's/.*"tag_name":[[:space:]]*"\([^"]*\)".*/\1/p' | sed -n '1p'); then
        log "**** ERROR: Could not query the VeraCrypt release API"
        return 1
    fi
    if [[ ! "$tag" =~ ^VeraCrypt_([0-9]+\.[0-9]+\.[0-9]+)$ ]]; then
        log "**** ERROR: Could not determine the latest VeraCrypt version (tag: ${tag:-missing})"
        return 1
    fi
    version=${BASH_REMATCH[1]}
    asset="veracrypt-$version-$platform-$arch"
    if [[ "$manager" == apt ]]; then
        asset+=".deb"
    else
        asset+=".rpm"
    fi
    release_url="https://github.com/veracrypt/VeraCrypt/releases/download/$tag/$asset"
    signature_url="$release_url.sig"
    key_url="https://amcrypto.jp/VeraCrypt/VeraCrypt_PGP_public_key.asc"
    key_fingerprint=5069A233D55A0EEB174A5FC3821ACD02680D16DE

    if [[ "$dry_run" == true ]]; then
        if ! command -v gpg &>/dev/null; then
            if [[ "$manager" == apt ]]; then
                log "[dry-run] sudo apt install -y gnupg"
            else
                log "[dry-run] sudo dnf install -y gnupg2"
            fi
        fi
        log "[dry-run] Download $release_url and its detached signature"
        log "[dry-run] Download and verify VeraCrypt signing key fingerprint $key_fingerprint"
        log "[dry-run] Verify signature, then install the package with $manager"
        return 0
    fi

    if ! command -v gpg &>/dev/null; then
        log "**** Installing GPG for VeraCrypt package signature verification ..."
        if [[ "$manager" == apt ]]; then
            run_cmd sudo apt install -y gnupg
        else
            run_cmd sudo dnf install -y gnupg2
        fi
    fi

    tmpdir=$(mktemp -d)
    trap 'run_cmd rm -rf -- "$tmpdir"' EXIT
    package_file="$tmpdir/$asset"
    signature_file="$package_file.sig"
    key_file="$tmpdir/VeraCrypt_PGP_public_key.asc"
    gpg_home="$tmpdir/gnupg"

    log "**** Downloading VeraCrypt $version for $platform ..."
    if ! run_cmd curl -fsSL "$release_url" -o "$package_file" 2>&1 | tee -a "$logfile_path"; then
        log "**** ERROR: Could not download $release_url"
        return 1
    fi
    if ! run_cmd curl -fsSL "$signature_url" -o "$signature_file" 2>&1 | tee -a "$logfile_path"; then
        log "**** ERROR: Could not download the VeraCrypt package signature"
        return 1
    fi
    if ! run_cmd curl -fsSL "$key_url" -o "$key_file" 2>&1 | tee -a "$logfile_path"; then
        log "**** ERROR: Could not download the VeraCrypt signing key"
        return 1
    fi

    local downloaded_fingerprint
    downloaded_fingerprint=$(gpg --batch --with-colons --show-keys "$key_file" 2>>"$logfile_path" |
        awk -F: '$1 == "fpr" { print toupper($10); exit }')
    if [[ "$downloaded_fingerprint" != "$key_fingerprint" ]]; then
        log "**** ERROR: VeraCrypt signing-key fingerprint did not match; refusing to install"
        return 1
    fi

    run_cmd mkdir -m 700 "$gpg_home"
    if ! run_cmd gpg --homedir "$gpg_home" --batch --import "$key_file" 2>&1 |
        tee -a "$logfile_path"; then
        log "**** ERROR: Could not import the verified VeraCrypt signing key"
        return 1
    fi
    if ! gpg --homedir "$gpg_home" --batch --verify "$signature_file" "$package_file" 2>&1 |
        tee -a "$logfile_path"; then
        log "**** ERROR: VeraCrypt package signature verification failed; refusing to install"
        return 1
    fi

    if [[ "$manager" == dnf ]]; then
        run_cmd sudo rpm --import "$key_file"
        log "**** Installing verified VeraCrypt RPM ..."
        run_cmd sudo dnf install -y "$package_file" 2>&1 | tee -a "$logfile_path"
    else
        log "**** Installing verified VeraCrypt DEB ..."
        run_cmd sudo apt install -y "$package_file" 2>&1 | tee -a "$logfile_path"
    fi

    if ! command -v veracrypt &>/dev/null; then
        log "**** ERROR: Package installation completed but the veracrypt command was not found"
        return 1
    fi
    log "**** veracrypt installed successfully"
)

# Zen browser has no apt/dnf package (Arch installs it from the AUR), so
# Debian/Ubuntu and Fedora get it from Flathub.
install_zen_flatpak() {
    if ! command -v flatpak &>/dev/null; then
        log "**** WARNING: flatpak not found, skipping zen browser (see https://zen-browser.app/download)"
        return 0
    fi
    if [[ "$dry_run" != true ]] && flatpak info app.zen_browser.zen &>/dev/null; then
        log "**** zen browser is already installed"
        return 0
    fi
    log "**** Trying 'flatpak install flathub app.zen_browser.zen' ..."
    run_cmd flatpak install -y flathub app.zen_browser.zen 2>&1 | tee -a "$logfile_path" || \
        log "**** WARNING: Could not install zen browser via flatpak, skipping"
}

# ---- Environment setup --------------------------------------------

setup_terminal() {
    if [[ "$no_terminal" = true ]]; then
        log "**** Skipping terminal setup ..."
        return
    fi

    # Starship — download installer to a temp file so run_cmd can handle it
    if command -v starship &>/dev/null; then
        log "**** starship is already installed"
    else
        log "**** Installing starship ..."
        local starship_installer
        starship_installer=$(mktemp)
        run_cmd curl -fsSL https://starship.rs/install.sh -o "$starship_installer"
        run_cmd sh "$starship_installer" --yes 2>&1 | tee -a "$logfile_path"
        rm -f "$starship_installer"
    fi

    # ZSH Auto Suggestions
    if [[ ! -d "$HOME/.config/zsh/zsh-autosuggestions" ]]; then
        log "**** Installing zsh-autosuggestions ..."
        run_cmd git clone https://github.com/zsh-users/zsh-autosuggestions ~/.config/zsh/zsh-autosuggestions 2>&1 | tee -a "$logfile_path"
    else
        log "**** zsh-autosuggestions already installed"
    fi

    # ZSH Highlighting
    if [[ ! -d "$HOME/.config/zsh/zsh-highlighting" ]]; then
        log "**** Installing zsh-syntax-highlighting ..."
        run_cmd git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.config/zsh/zsh-highlighting 2>&1 | tee -a "$logfile_path"
    else
        log "**** zsh-syntax-highlighting already installed"
    fi
}

# ---- Main logic --------------------------------------------

# Linux uses sudo across many steps (apt-get update, each apt/dnf install,
# the brew installer, pacman/yay). Prime it once up front so the user types
# their password a single time per run.
if [[ "$OSTYPE" == "linux-gnu"* ]] && [[ "$dry_run" != true ]]; then
    keep_sudo_alive
fi

install_yay

install_brew

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    install_linux_apps
elif [[ "$OSTYPE" == "darwin"* ]]; then
    install_mac_apps
else
    log "**** Unsupported $OSTYPE"
    exit 1
fi

install_python

# TPM must run after tmux is installed
install_tmux_plugin_manager

# NVM setup
install_nvm

setup_terminal
