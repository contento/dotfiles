#!/bin/bash
# .make.sh

install_brew() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # Mac OSX
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo "Unsupported $OSTYPE for brew installation"
        exit 1
    fi
}

install_brew_apps() {
    local brew_apps=(
        "zsh git vim tmux most pandoc w3m lynx"
        "neofetch ranger mc bat lsd bpytop"
        "python3 python3-pip cargo golang nodejs npm"
        "keychain wakeonlan fzf fd eza tldr zoxide"
        # fonts
        "font-delugia-complete"
    )

    local cask_brew_apps=(
        fonts-firacode
    )

    for app in "${brew_apps[@]}"; do
        if brew list "$app" &>/dev/null; then
            brew install "$app"
        fi
    done
}

install_mac_specific() {
    brew tap homebrew/cask-fonts

    brew install --cask font-fira-code
    for app in "${cask_brew_apps[@]}"; do
        if brew list "$app" &>/dev/null; then
            brew install "$app"
        fi
    done
}

install_linux_specific() {
    # lf
    appv=r32
    appcpu=amd # or arm

    local download_file="lf-linux-${appcpu}64.tar.gz"

    wget "https://github.com/gokcehan/lf/releases/download/${appv}/${download_file}" -O "$download_file"
    tar xvf "$download_file"
    chmod +x lf
    sudo mv lf /usr/local/bin

    rm "$download_file"

    # native apps

    local native_apps=(
        "net-tools"
    )

    for app in "${native_apps[@]}"; do
        eval "sudo apt install -y $app"
    done
}

setup_environment() {
    # Starship
    yes | curl -fsSL https://starship.rs/install.sh | sh -s -- --bin-dir /usr/local/bin --force

    # ZSH Auto Suggestions
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.config/zsh/zsh-autosuggestions

    # ZSH Highlighting
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.config/zsh/zsh-highlighting

    # pfetch
    git clone https://github.com/dylanaraps/pfetch.git
    sudo install pfetch/pfetch /usr/local/bin/

    # Remove cloned pfetch directory
    rm -rf pfetch
}

###############################################
# Main logic

install_brew

install_brew_apps

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    install_linux_specific
elif [[ "$OSTYPE" == "darwin"* ]]; then
    install_mac_specific
else
    echo "Unsupported $OSTYPE for brew installation"
    exit 1
fi

setup_environment
