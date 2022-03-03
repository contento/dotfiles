#!/bin/bash
# .make.sh

# (-:
#     https://conten.to
# :-)
# base packages
sudo apt install -y git vim tmux most pandoc w3m lynx \
    zsh neofetch ranger mc bat fonts-firacode \
    python3 python3-pip cargo golang nodejs npm

curl -fsSL https://starship.rs/install.sh | sh

# ZSH - Auto Suggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.config/zsh/zsh-autosuggestions

# ZSH - Highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.config/zsh/zsh-highlighting

# pfetch
git clone https://github.com/dylanaraps/pfetch.git
sudo install pfetch/pfetch /usr/local/bin/

# lsd
appv=0.21.0
appcpu=amd
# appcpu=arm
wget -q https://github.com/Peltoche/lsd/releases/download/${appv}/lsd_${appv}_${appcpu}64.deb
sudo dpkg -i lsd_${appv}_${appcpu}64.deb

# lf

appv=r26
appcpu=amd
# appcpu=arm

wget https://github.com/gokcehan/lf/releases/download/${appv}/lf-linux-${appcpu}64.tar.gz -O lf-linux-${appcpu}64.tar.gz
tar xvf lf-linux-${appcpu}64.tar.gz
chmod +x lf
sudo mv lf /usr/local/bin
