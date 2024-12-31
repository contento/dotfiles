#!/bin/zsh

#   o  o
# \______/
#   |
#      |    https://conten.to
# --------

logs_folder="$(dirname "${BASH_SOURCE[0]}")/logs"
mkdir -p "$logs_folder"

logfile_path="$logs_folder/$(basename "${BASH_SOURCE[0]}" .sh)-$(date +%Y-%m-%d).log"

common_apps=(
    atuin
    bat
    btop
    cargo
    eza
    fastfetch
    fd
    fonts-firacode
    gcc
    golang
    go
    ghostty
    keychain
    kitty
    lazygit
    lynx
    make
    mc
    most
    pandoc
    pfetch-rs
    portal
    python3
    python3-pip
    ripgrep
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

linux_apps=(
)

brew_linux_apps=(
    fzf
    neovim
    node
)

brew_mac_apps=(
    fzf
    go
    neovim
    node
)

mac_cask_brew_apps=(
    iterm2
    font-delugia-complete
    font-fira-code
    font-fira-code-nerd-font
)

# --- Parse command-line arguments ----------------

no_brew_installation=false
no_terminal=false

for arg in "$@"; do
    case $arg in
    --no-brew)
        # Set the flag if --no-brew is passed
        no_brew_installation=true
        shift # Remove --no-brew from processing
        ;;
   --no-terminal)
        # Set the flag if --no-terminal is passed
        no_terminal=true
        shift # Remove --no-terminal from processing
        ;;
    *)
        shift # Skip unknown options
        ;;
    esac
done

# --- Util ------------------------

install_tmux_plugin_manager() {
    echo "**** Installing tmux plugin manager ..." | tee -a "$logfile_path"

    if ! command -v tmux &> /dev/null; then
        echo "tmux is not installed. Please install tmux first." | tee -a "$logfile_path"
        return 1
    fi

    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}

install_yay() {
    if [[ ! -f /etc/arch-release ]]; then
        return
    fi

    if ! command -v yay &> /dev/null; then
        echo "Installing yay..."
        sudo pacman -S --needed git base-devel
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si
        cd ..
        rm -rf yay
    fi
}

install_brew() {
    if [ "$no_brew_installation" = false ]; then
        echo "**** Installing brew ..." | tee -a "$logfile_path"
    else
        echo "**** Skipping brew installation ..." | tee -a "$logfile_path"
        if [[ "$OSTYPE" == "darwin"* ]]; then
            echo "brew is required on Mac" | tee -a "$logfile_path"
            exit 1
        fi
        return
    fi

    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        $(which bash) -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" | tee -a "$logfile_path"
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" | tee -a "$logfile_path"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # Mac OS
        $(which bash) -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" | tee -a "$logfile_path"
    else
        echo "Unsupported $OSTYPE for brew installation" | tee -a "$logfile_path"
    fi
}

install_with_yay() {
    local app=$1
    echo "**** Checking if $app is already installed ..." | tee -a "$logfile_path"

    if pacman -Qs "$app" > /dev/null; then
        echo "$app is already installed." | tee -a "$logfile_path"
        return 0
    fi

    echo "**** Trying 'yay install $app' ..." | tee -a "$logfile_path"
    if ! yay -S --noconfirm "$app"; then
        echo "Failed to install with yay trying with brew..." | tee -a "$logfile_path"
        brew install "$app"
    fi
}

install_with_apt() {
    local app=$1
    echo "**** Checking if $app is already installed ..." | tee -a "$logfile_path"

    if dpkg-query -W -f='${Status}' "$app" 2>/dev/null | grep -q "install ok installed"; then
        echo "**** $app is already installed" | tee -a "$logfile_path"
    else
        echo "**** Trying 'apt install $app' ..." | tee -a "$logfile_path"
        if ! sudo apt install -y "$app"; then
            echo "Failed to install $app with apt, trying with brew..." | tee -a "$logfile_path"
            brew install "$app"
        fi
    fi
}

install_with_brew_formula() {
    local app=$1
    echo "**** Trying 'brew install $app' ..." | tee -a "$logfile_path"
    if brew list "$app" &>/dev/null; then
       echo "**** $app is already installed" | tee -a "$logfile_path"
    else
       brew install "$app"
    fi
}

install_with_brew_cask() {
    local app=$1
    echo "**** Trying 'brew --cask install $app' ..." | tee -a "$logfile_path"
    if brew list "$app" &>/dev/null; then
       echo "**** $app is already installed" | tee -a "$logfile_path"
    else
        brew install --cask "$app"
    fi
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
    fi

}

install_linux_apps() {
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

    # Starship
    yes | curl -fsSL https://starship.rs/install.sh | sh -s -- --bin-dir /usr/local/bin --force | tee -a "$logfile_path"

    # ZSH Auto Suggestions
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.config/zsh/zsh-autosuggestions | tee -a "$logfile_path"

    # ZSH Highlighting
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.config/zsh/zsh-highlighting | tee -a "$logfile_path"
}

# ---- Main logic --------------------------------------------

install_yay

install_brew

install_tmux_plugin_manager

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    install_linux_apps
elif [[ "$OSTYPE" == "darwin"* ]]; then
    install_mac_apps
else
    echo "Unsupported $OSTYPE for brew installation" | tee -a "$logfile_path"
    exit 1
fi

setup_terminal
