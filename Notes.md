
# Notes

Some notes on Linux Installations, especially on Ubuntu >= 20

# Update/Upgrade Ubuntu

```bash
sudo apt update -y && sudo apt upgrade -y && sudo apt dist-upgrade -y && sudo apt autoremove -y

```

# Install Dependencies and Tools

```bash
sudo apt install -y curl
sudo apt install -y nodejs
sudo apt install -y npm
sudo apt install -y tmux
sudo apt install -y most
sudo apt install -y python3-pip
sudo apt install -y ranger
sudo apt install -y mc
sudo apt install -y neofetch
sudo apt install -y git
sudo apt install -y bat

```

## bat
You mayt need to create a link for `bat` see [bat and Ubuntu](https://github.com/sharkdp/bat#on-ubuntu-using-apt)

```bash
# check your $PATH
sudo ln -s /usr/bin/batcat /usr/local/bin/
```

## Snaps [ OPTIONAL ]

```bash
sudo snap install bpytop lsd

```

## Python PIP Modules [ OPTIONAL ]

```bash
#
# pip3 install bpytop

```

## Install Fonts

```bash
sudo apt install fonts-firacode

```

## Install Rust and Tools

```bash
curl https://sh.rustup.rs -sSf | sh
sh -c "$(curl -fsSL https://starship.rs/install.sh)"

```

## Install pfetch

[pfetch Linux and Unix hardware information tool - nixCraft (cyberciti.biz)](https://www.cyberciti.biz/open-source/command-line-hacks/pfetch-linux-and-unix-hardware-information-tool/)

```bash
git clone https://github.com/dylanaraps/pfetch.git
sudo install pfetch/pfetch /usr/local/bin/

```

# ZSH

Installation: <https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH>

```bash
sudo apt install zsh -y
zsh
logout
##
chsh -s $(which zsh)
logout
```

## Plug-ins

```bash
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.config/zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.config/zsh/zsh-highlighting

```

# dotfiles repository

```bash
# HTTPS
git clone https://github.com/contento/dotfiles.git
# Set-up
pushd ~/dotfiles
chmod +x .make.sh
./.make.sh
popd

```

## LSD

```bash
appv=0.21.0
appcpu=amd
# appcpu=arm

wget -q https://github.com/Peltoche/lsd/releases/download/${appv}/lsd_${appv}_${appcpu}64.deb
sudo dpkg -i lsd_${appv}_${appcpu}64.deb
```

## LF

```bash
appv=r26
appcpu=amd
# appcpu=arm

wget https://github.com/gokcehan/lf/releases/download/${appv}/lf-linux-${appcpu}64.tar.gz -O lf-linux-${appcpu}64.tar.gz
tar xvf lf-linux-${appcpu}64.tar.gz
chmod +x lf
sudo mv lf /usr/local/bin
```

## View Files

install [pandoc ](https://pandoc.org/)and:

- Markdown files to HTML use:

```bash
 pandoc README.md| lynx -stdin
```

- Markdown to text:

```bash
pandoc README.md -t plain | less
```

## Updating to Vim 8.2 (Ubuntu 18 LTS)

```bash
sudo add-apt-repository ppa:jonathonf/vim
sudo apt update
sudo apt install vim
```

# SSH

Check the Agent

```bash
eval `ssh-agent -s`
```

## SSH Config

Located at `~/.ssh/config`

```bash

Host contento
    HostName github.com
    User contento
    IdentityFile ~/.ssh/<<id_file>>
    AddKeysToAgent yes

```

## ~/.ssh

All .ssh files in Linux should use the attribute 600

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_rsa-*
# show attributes in chmod style
stat -c '%a %n' ~/.ssh
```

# Websites

-   Pling <https://www.pling.com/>
-

# Various Apps

This is the Top 10 MUST HAVE Linux apps going into the year 2021. All of these applications are free and open source, some do have optional paid features. This list is my opinion of the top Linux applications. Make sure you check out the 2020 video for 10 more great applications.

- Privacy web browser - [Librewolf](https://librewolf-community.gitlab.io/)
- Joplin - Text and markdown editor.
- Bitwarden - Open source password manager.
- KDE Connect - Link your phone to your PC.
- MailSpring - [https://youtu.be/Oij2U1d3yL4](https://www.youtube.com/watch?v=Oij2U1d3yL4&t=0s)​
- bpytop - [https://youtu.be/hH2ENEew9RI](https://www.youtube.com/watch?v=hH2ENEew9RI&t=0s)​
- Lutris - Play your games on Linux.
- Fluent Reader - [https://youtu.be/T1ekR](https://www.youtube.com/watch?v=T1ekRJTkzJw&t=0s)

# Rust Apps

[(1) Rust Programs Every Linux User Should Know About - YouTube](https://www.youtube.com/watch?v=dQa9mveTSV4)

REFERENCED:

► [https://starship.rs/](https://www.youtube.com/redirect?event=video_description&redir_token=QUFFLUhqbUg5Nk4wOGZoeGxocUZiZkUzR20zSnBKY193Z3xBQ3Jtc0ttMGlRSXl2Z3pGLWJnQ0tNZTBXQkowcENIU1d0dUhxcGpUTXYzbnNvNy1DUy1GbHFlT2t2bDZRLXRPd1hXTHdNYmhFVjBHUDFRR0ludF9UdEZxUFFrSDRVSlpGT1BEVlhGWmpxTFlQUFFZLW8zTXBVNA&q=https%3A%2F%2Fstarship.rs%2F)​ - Starship Prompt

► [https://the.exa.website/](https://www.youtube.com/redirect?event=video_description&redir_token=QUFFLUhqa1hYbzFmRUY0VjRyMURpU1ZOT2h3ZkdsWVhUZ3xBQ3Jtc0tuTHFaS05yeDEwOUxObVlsYW9GOElXcVhxZ3NVdXJTTHBZZktOT19XZ2FJbmd2YlBNc0VxTzVTSmV4U0JDdWdPa0lSTFppMXk5c3V1WkVBUUFIcXl2MWZDczBoRWFFTzZXdjJ3SE9pLVNjOVJZWFgtbw&q=https%3A%2F%2Fthe.exa.website%2F)​ - exa

► [https://github.com/sharkdp/bat](https://www.youtube.com/redirect?event=video_description&redir_token=QUFFLUhqa2lzdjFqTklnM1ZKN1pvTnVydWNsTU1KOWthQXxBQ3Jtc0tseUw2cjlQU2d5aEM3YlZxMXpUNk9BWnQwV29tUVByd0RZdWt4b2hjTUdDUzNmWld3dlV3M3h4VnVoLWtXdGM2dm84d1NpdFBXa2Z6eHpGSnZ4cmFybXBmc3hNLUdQWTdiV09rNF9tbDZiSlVmSE9YQQ&q=https%3A%2F%2Fgithub.com%2Fsharkdp%2Fbat)​ - bat

► [https://github.com/BurntSushi/ripgrep](https://www.youtube.com/redirect?event=video_description&redir_token=QUFFLUhqbHNVTDlPalBLV3haVGZvb1BJOUYtQzBrTmZvUXxBQ3Jtc0tsQXI5RXFEZUxFaVhRNXI4UzVRU1VoSUdXc20tU09YRjdoZGIybi1vYkMtRm9DSVg4OUx4dFd4V3lQbzkwWlg2c0dUN2VLVURvYi1YanVrNkloLXlRM3A4OW9TN05LNGRjOEJvVl9oZTYwX0hmOG9xWQ&q=https%3A%2F%2Fgithub.com%2FBurntSushi%2Fripgrep)​ - ripgrep (rg)

► [https://github.com/sharkdp/fd](https://www.youtube.com/redirect?event=video_description&redir_token=QUFFLUhqa2Z1eGlNckMxUkRXT05VY3ppT2IzdTZaalJMUXxBQ3Jtc0tsYy0wZWJBdEFKbEJ2azJxbFNxbUFhUVFqWEUxa1VtX09uNVBxdG9zQlhZZWhNN19DZ0ZtRHViNjJRMmlEbGgzUEtNSHotdGZsVWlFbzExSmE4Q0JDQmdhWEo5UUFLazFURFgyOG9qdXRkNlhMYVlUdw&q=https%3A%2F%2Fgithub.com%2Fsharkdp%2Ffd)​ - fd

► [https://github.com/XAMPPRocky/tokei](https://www.youtube.com/redirect?event=video_description&redir_token=QUFFLUhqbHlBOXVFbkpJRDdGSDhQTDBiN0ZQWFZHMEZ1UXxBQ3Jtc0trZ1FNYTdSVnJWRG43MVdXSkFSM0hETVJtUnNNWXY2eFY5Z0E1WnhKdzRyYy1sWk00N1hHdVlRdnk4REZqcDBXR2VQOEtIcm04UzkzaXBmQUE2TEtSbmNla1dfWmowcTV2Q0lnanpLU0JiRkE3S3poRQ&q=https%3A%2F%2Fgithub.com%2FXAMPPRocky%2Ftokei)​ - tokei

► [https://github.com/dalance/procs](https://www.youtube.com/redirect?event=video_description&redir_token=QUFFLUhqa0M5RjNMc2luSzA5ZTBHaEZPem1WRG9HTmFjQXxBQ3Jtc0ttd2dXRkxqVE9aNERTUjlHazI1RTEwcE9qN0FuTDNKRUlrb3dsZjZ4ajhyRWMtWEg0aUV1LVlfbXMtRkpVUHR4RDJMWEo4bHVlQm5ySDJNV3pvcjRjZUY1UVZBVWtHMmlmM1VNODZlZVNCZERucjBYNA&q=https%3A%2F%2Fgithub.com%2Fdalance%2Fprocs)​ - procs
