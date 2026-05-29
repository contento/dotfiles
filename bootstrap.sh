#!/usr/bin/env bash

#   o  o
# \______/
#   |
#      |    https://conten.to
# --------

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
logs_folder="$script_dir/logs"
mkdir -p "$logs_folder"

logfile_path="$logs_folder/$(basename "${BASH_SOURCE[0]}" .sh)-$(date +%Y-%m-%d).log"

# Packages whose name is identical across brew, apt, and yay.
common_apps=(
    atuin
    bat
    btop
    direnv
    duf                # df replacement
    dust               # du replacement
    eza
    fastfetch
    fd
    ffmpegthumbnailer  # yazi: video thumbnails
    fzf
    gcc
    git-delta          # package name across brew/apt/yay; the installed binary is 'delta'
    httpie             # friendlier curl
    hyperfine          # command-line benchmarking
    imagemagick        # yazi: image preview
    jpegoptim          # JPEG compression
    jq
    keychain
    lazygit
    lynx
    make
    mc
    most
    mtr                # traceroute + ping combined
    pandoc
    pngquant           # lossy PNG compression
    poppler            # yazi: PDF preview (provides pdftoppm)
    python3
    ripgrep
    rustup
    shellcheck         # bash linter
    shfmt              # shell formatter
    stow
    tmux
    tldr
    unzip
    vim
    wakeonlan
    w3m
    yazi
    zoxide
    zsh                # primary shell of this dotfiles config
)

# Linux-only packages installed via the native package manager (apt or yay).
# Names match Debian/Ubuntu apt conventions; yay falls back to brew on mismatch.
linux_apps=(
    fonts-firacode   # apt; yay: ttf-firacode-nerd (falls back to brew)
    gh               # GitHub CLI; apt: gh, yay: github-cli (falls back to brew)
    ghostty          # yay (AUR); not in apt — will fall back to brew
    golang           # apt/yay name for Go; brew name is 'go' (in brew_mac_apps)
    python3-pip      # apt; yay: python-pip (falls back to brew)
    pfetch-rs        # yay (AUR); not in apt — will fall back to brew
    xsel             # tmux-fzf clipboard (X11); macOS uses pbcopy/pbpaste natively
    xclip            # tmux copy-mode clipboard fallback (X11)
    yq               # YAML processor; apt: yq, yay: go-yq (falls back to brew)
)

# Linux packages that must come from Homebrew.
brew_linux_apps=(
    neovim
    node
    portal
)

# macOS-only brew formulas.
brew_mac_apps=(
    gh
    go
    neovim
    node
    portal
    yq
)

# macOS brew casks (GUI apps and fonts).
mac_cask_brew_apps=(
    ghostty
    iterm2
    font-delugia-complete
    font-fira-code
    font-fira-code-nerd-font
)

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

# Tools considered part of the "minimum" install. Anything outside this list
# is skipped when $minimum is true. Starship, git, and curl are handled
# outside the package arrays (prereqs / setup_terminal) and not listed here.
is_minimum() {
    case "$1" in
        # Required infrastructure
        stow|zsh|tmux|vim|unzip|make|gcc) return 0 ;;
        # Daily-driver minimum
        fzf|ripgrep|jq) return 0 ;;
        *) return 1 ;;
    esac
}

# Returns 0 if $1 should be installed under the current mode.
should_install() {
    if [[ "$minimum" == true ]] && ! is_minimum "$1"; then
        return 1
    fi
    return 0
}

# Prompt for sudo once, then keep the credential cache warm for the rest
# of the script. Without this, slow brew/apt steps let the 5-minute sudo
# cache expire and the password gets re-prompted mid-install.
keep_sudo_alive() {
    sudo -v
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
    # available via apt/yay, so the ~500MB brew install is unnecessary.
    # Mac still needs brew (it's the only package manager).
    if [[ "$minimum" == true ]] && [[ "$OSTYPE" == "linux-gnu"* ]]; then
        log "**** Skipping brew installation (minimum mode on Linux uses apt/yay)"
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
    local app=$1
    log "**** Checking if $app is already installed ..."

    if pacman -Qs "$app" > /dev/null 2>&1; then
        log "**** $app is already installed"
        return 0
    fi

    log "**** Trying 'yay -S $app' ..."
    if ! run_cmd yay -S --noconfirm "$app" 2>&1 | tee -a "$logfile_path"; then
        log "**** Failed to install $app with yay, trying with brew..."
        run_cmd brew install "$app" 2>&1 | tee -a "$logfile_path" || \
            log "**** WARNING: Could not install $app via yay or brew, skipping"
    fi
}

install_with_apt() {
    local app=$1
    log "**** Checking if $app is already installed ..."

    if dpkg-query -W -f='${Status}' "$app" 2>/dev/null | grep -q "install ok installed"; then
        log "**** $app is already installed"
        return 0
    fi

    log "**** Trying 'apt install $app' ..."
    if ! run_cmd sudo apt install -y "$app" 2>&1 | tee -a "$logfile_path"; then
        log "**** Failed to install $app with apt, trying with brew..."
        run_cmd brew install "$app" 2>&1 | tee -a "$logfile_path" || \
            log "**** WARNING: Could not install $app via apt or brew, skipping"
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

# -- Mac ----------------------------------------------

install_mac_apps() {
    for app in "${common_apps[@]}"; do
        should_install "$app" || continue
        install_with_brew_formula "$app"
    done

    for app in "${brew_mac_apps[@]}"; do
        should_install "$app" || continue
        install_with_brew_formula "$app"
    done

    # Casks (GUI apps, fonts) are never part of the minimum set.
    if [[ "$minimum" != true ]]; then
        for app in "${mac_cask_brew_apps[@]}"; do
            install_with_brew_cask "$app"
        done
    fi
}

# -- Linux --------------------------------------------

install_linux_app() {
    local app=$1

    if [[ -f /etc/arch-release ]]; then
        install_with_yay "$app"
    elif [[ -f /etc/debian_version ]]; then
        install_with_apt "$app"
    else
        log "**** WARNING: unsupported Linux distro, skipping $app"
    fi
}

install_linux_apps() {
    # Refresh package index before installing on Debian/Ubuntu
    if [[ -f /etc/debian_version ]]; then
        log "**** Updating apt package index ..."
        run_cmd sudo apt-get update -qq
    fi

    for app in "${common_apps[@]}"; do
        should_install "$app" || continue
        install_linux_app "$app"
    done

    for app in "${linux_apps[@]}"; do
        should_install "$app" || continue
        install_linux_app "$app"
    done

    for app in "${brew_linux_apps[@]}"; do
        should_install "$app" || continue
        install_with_brew_formula "$app"
    done
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

# Linux uses sudo across many steps (apt-get update, each apt install, the
# brew installer, pacman/yay). Prime it once up front so the user types
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

# TPM must run after tmux is installed
install_tmux_plugin_manager

setup_terminal
