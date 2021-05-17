#!/bin/bash
# .make.sh

# (-:
#     https://conten.to
# :-)
# base packages
sudo apt install -y git vim tmux most \
    zsh neofetch lsd ranger mc bat fonts-firacode \
    python3 python3-pip cargo golang nodejs npm

# ZSH - Auto Suggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.config/zsh/zsh-autosuggestions

# ZSH - Highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.config/zsh/zsh-highlighting

# pfetch
git clone https://github.com/dylanaraps/pfetch.git
sudo install pfetch/pfetch /usr/local/bin/

# lsd
appv=0.20.1
# appcpu=arm
appcpu=amd
wget -q https://github.com/Peltoche/lsd/releases/download/${appv}/lsd_${appv}_${appcpu}64.deb
sudo dpkg -i lsd_${appv}_${appcpu}64.deb
