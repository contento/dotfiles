#!/bin/bash
# .make.sh

all_apps=(
    atuin
    bat
    bpytop
    cargo
    eza
    fd
    fonts-firacode
    gcc
    golang
    keychain
    lazygit
    lsd
    lynx
    mc
    most
    nala
    neofetch
    net-tools
    pandoc
    pfetch
    python3
    python3-pip
    ranger
    ripgrep
    stow
    tmux
    tldr
    unzip
    wakeonlan
    w3m
    yazi
    zoxide
)

linux_apps=(
    tilix
    vim
    nvim
)

brew_linux_apps=(
    fzf
    node
)

brew_mac_apps=(
    fzf
    node
    nvim
)

mac_cask_brew_apps=(
    iterm2
    font-delugia-complete
    font-fira-code
    font-fira-code-nerd-font
)

# --- Parse command-line arguments ----------------

# check for no_brew flag. If set, do not install brew
no_brew_installation=false

for arg in "$@"; do
    case $arg in
    --no-brew)
        # Step 2: Set the flag if --no-brew is passed
        no_brew_installation=true
        shift # Remove --no-brew from processing
        ;;
    *)
        shift # Skip unknown options
        ;;
    esac
done

# ---- Brew --------------------------------------------

install_brew() {
    if [ "$no_brew_installation" = false ]; then
        echo "**** Installing brew ..."
    else
        echo "**** Skipping brew installation ..."
        if [[ "$OSTYPE" == "darwin"* ]]; then
            echo "brew is required on Mac"
            exit 1
        fi
        return
    fi

    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        $(which bash) -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # Mac OS
        $(which bash) -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo "Unsupported $OSTYPE for brew installation"
    fi
}

# ---- Mac --------------------------------------------

install_mac_brew_apps() {
    if [ "$no_brew_installation" = true ]; then
        echo "**** Skipping brew installation ..."
        return
    fi

    for app in "${all_apps[@]}"; do
        echo "**** Trying to install $app ..."
        if ! brew list "$app" &>/dev/null; then
            brew install "$app"
        fi
    done

    for app in "${brew_mac_apps[@]}"; do
        echo "**** Trying to install $app ..."
        if ! brew list "$app" &>/dev/null; then
            brew install "$app"
        fi
    done

    brew tap homebrew/cask-fonts
    for app in "${mac_cask_brew_apps[@]}"; do
        echo "**** Trying to install $app ..."
        if ! brew list "$app" &>/dev/null; then
            brew install --cask "$app"
        fi
    done
}

# -- Linux --------------------------------------------

install_linux_special_apps() {
    echo "installing special apps"

    # lf ========================================
    local appv=r32
    local appcpu=amd # or arm

    local download_file="lf-linux-${appcpu}64.tar.gz"

    wget "https://github.com/gokcehan/lf/releases/download/${appv}/${download_file}" -O "$download_file"
    tar xvf "$download_file"
    chmod +x lf
    sudo mv lf /usr/local/bin

    rm "$download_file"

    # delugia font ========================================
    local appv="v2111.01.2"
    local target="delugia-complete"
    local download_file="${target}.zip"
    wget "https://github.com/adam7/delugia-code/releases/download/${appv}/${download_file}" -O "$download_file"
    unzip -o "$download_file"
    sudo rm -r /usr/share/fonts/"${target}"
    sudo mv -f "${target}" /usr/share/fonts/
    sudo fc-cache -f -v
    rm "$download_file"
}

install_linux_app() {
    local app=$1
    echo "**** Trying to install $app ..."
    if ! dpkg -l "$app" &>/dev/null; then
        if ! sudo apt install -y "$app"; then
            if [ "$no_brew_installation" = false ]; then
                echo "**** apt failed, trying to install $app with brew..."
                brew install "$app"
            fi
        fi
    fi
}

install_brew_linux_apps() {
    if [ "$no_brew_installation" = true ]; then
        echo "**** Skipping brew installation ..."
        return
    fi

    for app in "${brew_linux_apps[@]}"; do
        echo "**** Trying to install $app ..."
        if ! brew list "$app" &>/dev/null; then
            brew install "$app"
        fi
    done
}

install_linux_apps() {
    for app in "${all_apps[@]}"; do
        install_linux_app "$app"
    done

    for app in "${linux_apps[@]}"; do
        install_linux_app "$app"
    done

    install_linux_special_apps

    install_brew_linux_apps
}

# ---- Environment setup --------------------------------------------

setup_environment() {
    # Starship
    yes | curl -fsSL https://starship.rs/install.sh | sh -s -- --bin-dir /usr/local/bin --force

    # ZSH Auto Suggestions
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.config/zsh/zsh-autosuggestions

    # ZSH Highlighting
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.config/zsh/zsh-highlighting
}

# ---- Main logic --------------------------------------------

install_brew

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    install_linux_apps
elif [[ "$OSTYPE" == "darwin"* ]]; then
    install_mac_brew_apps
else
    echo "Unsupported $OSTYPE for brew installation"
    exit 1
fi

setup_environment

# ------------------------------------------------------------
