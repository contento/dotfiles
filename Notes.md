# Linux

## Install Linux Parts

```shell
sudo tasksel
```

## Update/Upgrade Debian

```shell
sudo apt update -y && sudo apt dist-upgrade -y && sudo apt autoremove -y
```

## Installing nala

```shell
sudo apt install nala
```

## Installing flatpak

```shell
sudo nala install flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```

## ZSH

```bash
sudo nala install zsh -y
zsh
# and ...
chsh -s $(which zsh)
logout
```

## dotfiles repository

```bash
# HTTPS
git clone https://github.com/contento/dotfiles.git
# SSH
# git clone git@github.com:contento/dotfiles.git
```

## View Files

install [pandoc](https://pandoc.org/) and:

* Markdown files to HTML use:

```bash
pandoc README.md| lynx -stdin
```

* Markdown to text:

```bash
pandoc README.md -t plain | less
```

## SSH

Check the Agent

```bash
eval `ssh-agent -s`
```

### Copy your key

 ssh-copy-id -i ~/.ssh/id_rsa-{{ID}}.pub {{user}}@url

### SSH Config

Located at `~/.ssh/config`

```bash

Host ID
    HostName github.com
    User ID
    IdentityFile ~/.ssh/id_rsa-ID
    AddKeysToAgent yes
```

### ~/.ssh

All .ssh files in Linux should use the attribute 600

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_rsa-*
# show attributes in chmod style
stat -c '%a %n' ~/.ssh
```

## Websites

* [Pling](https://www.pling.com/)

## Creating a user

```shell
username=[USER]

sudo adduser $username
sudo usermod -aG sudo $username

sudo mkdir /home/$username
sudo usermod --shell /bin/bash --home /home/$username $username
sudo chown -R $username:$username /home/$username
# cp /etc/skel/.* /home/$username/

# NO SUDO
username=[USER]

adduser $username
usermod -aG sudo $username

mkdir /home/$username
usermod --shell /bin/bash --home /home/$username $username
chown -R $username:$username /home/$username
# cp /etc/skel/.* /home/$username/
```
## Installing xfce

```shell
# Do you need a desktop manager?
sudo nala install xfce4

# Do you need a display manager
# [DONE by xfce4] sudo nala install lightdm

# graphics?
sudo systemctl set-default graphical.target
```

## Installing tigervnc

[Install and Configure TigerVNC](https://computingforgeeks.com/install-and-configure-tigervnc-vnc-server-on-debian/)

```shell
# tigervnc
sudo nala install tigervnc-standalone-server tigervnc-common

# you may need to install also
sudo nala install xterm

# add password
vncpasswd

# start the server
vncserver -localhost no

# show list - See which PORT!
vncserver -list 

vncserver -kill :1
```

Add the following to `~/.vnc/xstartup`

```shell
#!/bin/bash
[ -x /etc/vnc/startup  ] && exec /etc/vnc/xstartup
[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
exec /bin/sh /etc/xdg/xfce4/xinitrc
startxfce4 &
```

```shell
sudo chmod u+x  ~/.vnc/xstartup 
sudo chmod 777  ~/.vnc/xstartup

vncserver
```

### Running as a service

Create to '/etc/systemd/system/vncserver@.service'

```shell
[Unit]
Description=Start TightVNC server at startup
After=syslog.target network.target

[Service]
Type=forking
User=contento
Group=contento
WorkingDirectory=/home/contento

PIDFile=/home/contento/.vnc/%H:%i.pid
ExecStartPre=-/usr/bin/vncserver -kill :%i > /dev/null 2>&1
ExecStart=/usr/bin/vncserver -depth 24 -geometry 1920x1080 :%i
ExecStop=/usr/bin/vncserver -kill :%i

[Install]
WantedBy=multi-user.target
```

```shell
sudo systemctl enable vncserver@1.service 
```

## Installing RealVNC - Debian

```shell
# Replace with the actual version (and/or use apt)
sudo nala install ./VNC-Server-7.5.1-Linux-x64.deb
vncserver
sudo systemctl start vncserver-x11-serviced.service
sudo systemctl enable vncserver-x11-serviced.service

```
