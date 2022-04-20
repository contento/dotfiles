#!/bin/bash
# .make.sh

# (-:
#     https://conten.to
# :-)

OS="$(uname)"

# base apps/packages
case $OS in
'Linux')
    PK_CMD_INSTALL='sudo apt install -y'
    ;;
'Darwin')
    PK_CMD_INSTALL='brew install'
    ;;
*)
    echo "$OS is not supported by this script!"
    exit
    ;;
esac

echo "[ $OS ->  $PK_CMD_INSTALL ]"

apps=(
    "git vim tmux most pandoc w3m lynx"
    "zsh neofetch ranger mc bat fonts-firacode"
    "python3 python3-pip cargo golang nodejs npm"
)
for app in "${apps[@]}"; do
    eval "$PK_CMD_INSTALL $app"
done

# fira code - Mac
if [[ $OS = 'Darwing' ]]; then
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
if [[ $OS = 'Darwing' ]]; then
    brew install lsd bpytop
else
    appv=0.21.0
    appcpu=amd
    # appcpu=arm
    wget -q https://github.com/Peltoche/lsd/releases/download/${appv}/lsd_${appv}_${appcpu}64.deb
    sudo dpkg -i lsd_${appv}_${appcpu}64.deb
fi

# lf
if ! [[ $OS = 'Darwing' ]]; then
    appv=r26
    appcpu=amd
    # appcpu=arm

    wget https://github.com/gokcehan/lf/releases/download/${appv}/lf-linux-${appcpu}64.tar.gz -O lf-linux-${appcpu}64.tar.gz
    tar xvf lf-linux-${appcpu}64.tar.gz
    chmod +x lf
    sudo mv lf /usr/local/bin
fi
