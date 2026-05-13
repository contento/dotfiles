# Ubuntu / Debian

---

## System update

```bash
sudo apt update -y && sudo apt dist-upgrade -y && sudo apt autoremove -y
```

### nala (faster apt frontend)

```bash
sudo apt install -y nala
sudo nala update && sudo nala upgrade
```

### Desktop components (tasksel)

```bash
sudo tasksel   # interactive selector for desktop environments, server roles, etc.
```

---

## Flatpak

```bash
sudo nala install flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```

---

## ZSH setup

```bash
sudo apt install -y zsh
chsh -s "$(which zsh)"
logout   # re-login to activate zsh
```

---

## Package installation

`bootstrap.sh` uses `apt install` for packages in `common_apps`.  
If a package fails with apt, it falls back to `brew install`.

Packages that require Homebrew on Linux (`brew_linux_apps`): `fzf`, `neovim`, `node`.

---

## User management

```bash
username=newuser

sudo adduser $username
sudo usermod -aG sudo $username
sudo mkdir -p /home/$username
sudo usermod --shell /bin/bash --home /home/$username $username
sudo chown -R $username:$username /home/$username
```

---

## Desktop (optional)

```bash
sudo nala install xfce4
sudo systemctl set-default graphical.target
```

---

## VNC server (TigerVNC)

See [[SSH#Tunnel VNC over SSH]] for secure remote access.

```bash
sudo nala install tigervnc-standalone-server tigervnc-common dbus-x11
vncpasswd
```

Create `~/.vnc/xstartup`:

```bash
#!/bin/bash
[ -x /etc/vnc/startup ] && exec /etc/vnc/xstartup
[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
vncconfig -iconic &
exec /bin/sh /etc/xdg/xfce4/xinitrc
```

```bash
chmod u+x ~/.vnc/xstartup
```

### Run as a systemd service

Create `/etc/systemd/system/vncserver@.service`:

```ini
[Unit]
Description=Start TigerVNC server at startup
After=syslog.target network.target

[Service]
Type=forking
User=contento
Group=contento
WorkingDirectory=/home/contento

PIDFile=/home/contento/.vnc/%H:%i.pid
ExecStartPre=-/usr/bin/vncserver -kill :%i > /dev/null 2>&1
ExecStart=/usr/bin/vncserver :%i -localhost no -depth 32 -geometry 1920x1080
ExecStop=/usr/bin/vncserver -kill :%i

[Install]
WantedBy=multi-user.target
```

> Use `-localhost yes` if you plan to tunnel VNC over SSH (recommended).

```bash
sudo systemctl daemon-reload
sudo systemctl start vncserver@1.service
sudo systemctl enable vncserver@1.service
```

---

## VNC server (RealVNC)

```bash
# Install the .deb directly (replace with current version)
sudo nala install ./VNC-Server-7.x.x-Linux-x64.deb
vncserver
sudo systemctl start vncserver-x11-serviced.service
sudo systemctl enable vncserver-x11-serviced.service
```

---

## Markdown viewing

```bash
# Markdown → HTML in terminal
pandoc README.md | lynx -stdin

# Markdown → plain text
pandoc README.md -t plain | less
```

---

## Resources

- [Pling](https://www.pling.com/) — themes, icons, wallpapers for Linux desktops
