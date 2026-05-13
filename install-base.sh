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
    eza
    fastfetch
    fd
    ffmpegthumbnailer  # yazi: video thumbnails
    gcc
    imagemagick        # yazi: image preview
    jq
    keychain
    lazygit
    lynx
    make
    mc
    most
    pandoc
    poppler            # yazi: PDF preview (provides pdftoppm)
    python3
    ripgrep
    rustup
    stow
    tmux
    tldr
    unzip
    vim
    wakeonlan
    w3m
    yazi
    zoxide
)

# Linux-only packages installed via the native package manager (apt or yay).
# Names match Debian/Ubuntu apt conventions; yay falls back to brew on mismatch.
linux_apps=(
    fonts-firacode   # apt; yay: ttf-firacode-nerd (falls back to brew)
    ghostty          # yay (AUR); not in apt — will fall back to brew
    golang           # apt/yay name for Go; brew name is 'go' (in brew_mac_apps)
    python3-pip      # apt; yay: python-pip (falls back to brew)
    pfetch-rs        # yay (AUR); not in apt — will fall back to brew
    xsel             # tmux-fzf clipboard (X11); macOS uses pbcopy/pbpaste natively
    xclip            # tmux copy-mode clipboard fallback (X11)
)

# Linux packages that must come from Homebrew.
brew_linux_apps=(
    fzf
    neovim
    node
    portal
)

# macOS-only brew formulas.
brew_mac_apps=(
    fzf
    go
    neovim
    node
    portal
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
    --help)
        echo "Usage: $0 [--dry-run] [--no-brew] [--no-terminal]"
        echo ""
        echo "Options:"
        echo "  --dry-run       Simulate installation without making changes"
        echo "  --no-brew       Skip Homebrew installation"
        echo "  --no-terminal   Skip terminal/shell setup"
        echo "  --help          Show this help message"
        exit 0
        ;;
    *)
        echo "Unknown option: $arg" && exit 1
        ;;
    esac
done

if [[ "$dry_run" == true ]]; then
    echo "**** DRY RUN — no changes will be made ****" | tee -a "$logfile_path"
fi

# --- Helper: run or simulate a command ----------------

run_cmd() {
    if [[ "$dry_run" == true ]]; then
        echo "[dry-run] $*" | tee -a "$logfile_path"
    else
        "$@"
    fi
}

# --- Util ------------------------

install_tmux_plugin_manager() {
    echo "**** Installing tmux plugin manager ..." | tee -a "$logfile_path"

    if ! command -v tmux &> /dev/null; then
        echo "**** tmux is not installed. Skipping TPM." | tee -a "$logfile_path"
        return 0
    fi

    if [[ -d "$HOME/.tmux/plugins/tpm" ]]; then
        echo "**** tmux plugin manager already installed" | tee -a "$logfile_path"
        return 0
    fi

    run_cmd git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}

install_yay() {
    if [[ ! -f /etc/arch-release ]]; then
        return
    fi

    if command -v yay &> /dev/null; then
        echo "**** yay is already installed" | tee -a "$logfile_path"
        return 0
    fi

    echo "**** Installing yay ..." | tee -a "$logfile_path"
    if [[ "$dry_run" == true ]]; then
        echo "[dry-run] sudo pacman -S --needed git base-devel" | tee -a "$logfile_path"
        echo "[dry-run] git clone https://aur.archlinux.org/yay.git /tmp/yay && cd /tmp/yay && makepkg -si" | tee -a "$logfile_path"
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
        echo "**** Skipping brew installation ..." | tee -a "$logfile_path"
        if [[ "$OSTYPE" == "darwin"* ]]; then
            echo "**** brew is required on Mac" | tee -a "$logfile_path"
            exit 1
        fi
        return
    fi

    if command -v brew &> /dev/null; then
        echo "**** brew is already installed" | tee -a "$logfile_path"
        return 0
    fi

    echo "**** Installing brew ..." | tee -a "$logfile_path"

    if [[ "$dry_run" == true ]]; then
        echo "[dry-run] /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\"" | tee -a "$logfile_path"
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
        echo "**** Unsupported OS: $OSTYPE" | tee -a "$logfile_path"
        exit 1
    fi
}

install_with_yay() {
    local app=$1
    echo "**** Checking if $app is already installed ..." | tee -a "$logfile_path"

    if pacman -Qs "$app" > /dev/null 2>&1; then
        echo "**** $app is already installed" | tee -a "$logfile_path"
        return 0
    fi

    echo "**** Trying 'yay -S $app' ..." | tee -a "$logfile_path"
    if ! run_cmd yay -S --noconfirm "$app" 2>&1 | tee -a "$logfile_path"; then
        echo "**** Failed to install $app with yay, trying with brew..." | tee -a "$logfile_path"
        run_cmd brew install "$app" 2>&1 | tee -a "$logfile_path"
    fi
}

install_with_apt() {
    local app=$1
    echo "**** Checking if $app is already installed ..." | tee -a "$logfile_path"

    if dpkg-query -W -f='${Status}' "$app" 2>/dev/null | grep -q "install ok installed"; then
        echo "**** $app is already installed" | tee -a "$logfile_path"
        return 0
    fi

    echo "**** Trying 'apt install $app' ..." | tee -a "$logfile_path"
    if ! run_cmd sudo apt install -y "$app" 2>&1 | tee -a "$logfile_path"; then
        echo "**** Failed to install $app with apt, trying with brew..." | tee -a "$logfile_path"
        run_cmd brew install "$app" 2>&1 | tee -a "$logfile_path"
    fi
}

install_with_brew_formula() {
    local app=$1
    if [[ "$dry_run" != true ]] && brew list "$app" &>/dev/null; then
        echo "**** $app is already installed" | tee -a "$logfile_path"
        return 0
    fi
    echo "**** Trying 'brew install $app' ..." | tee -a "$logfile_path"
    run_cmd brew install "$app" 2>&1 | tee -a "$logfile_path"
}

install_with_brew_cask() {
    local app=$1
    if [[ "$dry_run" != true ]] && brew list --cask "$app" &>/dev/null; then
        echo "**** $app is already installed" | tee -a "$logfile_path"
        return 0
    fi
    echo "**** Trying 'brew install --cask $app' ..." | tee -a "$logfile_path"
    run_cmd brew install --cask "$app" 2>&1 | tee -a "$logfile_path"
}

# -- Mac ----------------------------------------------

install_mac_apps() {
    for app in "${common_apps[@]}"; do
        install_with_brew_formula "$app"
    done

    for app in "${brew_mac_apps[@]}"; do
        install_with_brew_formula "$app"
    done

    for app in "${mac_cask_brew_apps[@]}"; do
        install_with_brew_cask "$app"
    done
}

# -- Linux --------------------------------------------

install_linux_app() {
    local app=$1

    if [[ -f /etc/arch-release ]]; then
        install_with_yay "$app"
    elif [[ -f /etc/debian_version ]]; then
        install_with_apt "$app"
    else
        echo "**** WARNING: unsupported Linux distro, skipping $app" | tee -a "$logfile_path"
    fi
}

install_linux_apps() {
    # Refresh package index before installing on Debian/Ubuntu
    if [[ -f /etc/debian_version ]]; then
        echo "**** Updating apt package index ..." | tee -a "$logfile_path"
        run_cmd sudo apt-get update -qq
    fi

    for app in "${common_apps[@]}"; do
        install_linux_app "$app"
    done

    for app in "${linux_apps[@]}"; do
        install_linux_app "$app"
    done

    for app in "${brew_linux_apps[@]}"; do
        install_with_brew_formula "$app"
    done
}

# ---- Environment setup --------------------------------------------

setup_terminal() {
    if [[ "$no_terminal" = true ]]; then
        echo "**** Skipping terminal setup ..." | tee -a "$logfile_path"
        return
    fi

    # Starship — download installer to a temp file so run_cmd can handle it
    if command -v starship &>/dev/null; then
        echo "**** starship is already installed" | tee -a "$logfile_path"
    else
        echo "**** Installing starship ..." | tee -a "$logfile_path"
        local starship_installer
        starship_installer=$(mktemp)
        run_cmd curl -fsSL https://starship.rs/install.sh -o "$starship_installer"
        run_cmd sh "$starship_installer" -- --bin-dir /usr/local/bin --force 2>&1 | tee -a "$logfile_path"
        rm -f "$starship_installer"
    fi

    # ZSH Auto Suggestions
    if [[ ! -d "$HOME/.config/zsh/zsh-autosuggestions" ]]; then
        echo "**** Installing zsh-autosuggestions ..." | tee -a "$logfile_path"
        run_cmd git clone https://github.com/zsh-users/zsh-autosuggestions ~/.config/zsh/zsh-autosuggestions 2>&1 | tee -a "$logfile_path"
    else
        echo "**** zsh-autosuggestions already installed" | tee -a "$logfile_path"
    fi

    # ZSH Highlighting
    if [[ ! -d "$HOME/.config/zsh/zsh-highlighting" ]]; then
        echo "**** Installing zsh-syntax-highlighting ..." | tee -a "$logfile_path"
        run_cmd git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.config/zsh/zsh-highlighting 2>&1 | tee -a "$logfile_path"
    else
        echo "**** zsh-syntax-highlighting already installed" | tee -a "$logfile_path"
    fi
}

# ---- Main logic --------------------------------------------

install_yay

install_brew

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    install_linux_apps
elif [[ "$OSTYPE" == "darwin"* ]]; then
    install_mac_apps
else
    echo "**** Unsupported $OSTYPE" | tee -a "$logfile_path"
    exit 1
fi

# TPM must run after tmux is installed
install_tmux_plugin_manager

setup_terminal
