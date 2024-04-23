#!/bin/bash
# .make.sh

# Define Constants
OS="$(uname)"
OS_DARWIN="Darwin"
OS_LINUX="Linux"

install_base_apps() {
    local apps=(
        "net-tools git vim tmux most pandoc w3m lynx"
        "zsh neofetch ranger mc bat fonts-firacode lsd"
        "python3 python3-pip cargo golang nodejs npm"
        "keychain wakeonlan fzf fd eza tldr"
    )

    for app in "${apps[@]}"; do
        eval "$PK_CMD_INSTALL $app"
    done
}

install_mac_specific() {
    brew tap homebrew/cask-fonts
    brew install --cask font-fira-code
    brew install lsd bpytop font-delugia-complete
}

install_linux_specific() {
    appv=r31
    appcpu=amd  # or arm

    local download_file="lf-linux-${appcpu}64.tar.gz"

    wget "https://github.com/gokcehan/lf/releases/download/${appv}/${download_file}" -O "$download_file"
    tar xvf "$download_file"
    chmod +x lf
    sudo mv lf /usr/local/bin

    # Remove downloaded file
    rm "$download_file"
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

# Main logic
case $OS in
    "$OS_LINUX")
        PK_CMD_INSTALL='sudo apt install -y'
        echo "[ $OS ->  $PK_CMD_INSTALL ]"
        install_base_apps
        install_linux_specific
        ;;
    "$OS_DARWIN")
        PK_CMD_INSTALL='brew install'
        echo "[ $OS ->  $PK_CMD_INSTALL ]"
        install_base_apps
        install_mac_specific
        ;;
    *)
        echo "$OS is not supported by this script!"
        exit 1
        ;;
esac

setup_environment
