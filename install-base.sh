#!/bin/bash
# .make.sh

# (-:
#     https://conten.to
# :-)

OS="$(uname)"
OS_DARWIN="Darwin"
OS_LINUX="Linux"

# base apps/packages
case $OS in
"$OS_LINUX")
    PK_CMD_INSTALL='sudo apt install -y'
    ;;
"$OS_DARWIN")
    PK_CMD_INSTALL='brew install'
    ;;
*)
    echo "$OS is not supported by this script!"
    exit
    ;;
esac

echo "[ $OS ->  $PK_CMD_INSTALL ]"

apps=(
    "net-tools git vim tmux most pandoc w3m lynx"
    "zsh neofetch ranger mc bat fonts-firacode lsd"
    "python3 python3-pip cargo golang nodejs npm"
)
for app in "${apps[@]}"; do
    eval "$PK_CMD_INSTALL $app"
done

# fira code - Mac
if [[ $OS = "$OS_DARWIN" ]]; then
    brew tap homebrew/cask-fonts
    brew install --cask font-fira-code
fi

curl -fsSL https://starship.rs/install.sh | sh

# ZSH - Auto Suggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.config/zsh/zsh-autosuggestions

# ZSH - Highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.config/zsh/zsh-highlighting

# pfetch
git clone https://github.com/dylanaraps/pfetch.git
sudo install pfetch/pfetch /usr/local/bin/

# lsd, bpytop
if [[ $OS = "$OS_DARWIN" ]]; then
    brew install lsd bpytop
fi

# lf
if ! [[ $OS = "$OS_DARWIN" ]]; then
    appv=r30
    appcpu=amd
    # appcpu=arm

    wget https://github.com/gokcehan/lf/releases/download/${appv}/lf-linux-${appcpu}64.tar.gz -O lf-linux-${appcpu}64.tar.gz
    tar xvf lf-linux-${appcpu}64.tar.gz
    chmod +x lf
    sudo mv lf /usr/local/bin
fi
