# dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).
Supports **macOS**, **Ubuntu/Debian**, and **Arch Linux**. Works with **bash** and **zsh**.

## Repository Structure

```
dotfiles/
├── bash/             # bash configuration
├── brew/             # Homebrew bundle / leaves
├── btop/             # btop resource monitor config
├── editorconfig/     # .editorconfig
├── fastfetch/        # fastfetch system info config
├── ghostty/          # Ghostty terminal config
├── git/              # git global config & aliases
├── kitty/            # Kitty terminal config
├── mc/               # Midnight Commander config
├── nvim/             # Neovim (LazyVim) config
├── starship/         # Starship prompt config
├── tmux/             # tmux config + TPM
├── vim/              # Vim config
├── yazi/             # Yazi file manager config
├── zed/              # Zed editor config
├── zsh/              # zsh config (primary shell)
├── wiki/             # Obsidian knowledge base
├── bootstrap.sh   # Install packages and terminal tools
├── stow-all.sh       # Symlink all configs via stow
└── fix-ssh-perms.sh # Fix SSH key file permissions
```

## Quick Start

### 1. Prerequisites

**macOS** — Homebrew is required and installed automatically:

```bash
xcode-select --install
```

**Ubuntu/Debian:**

```bash
sudo apt update && sudo apt install -y curl git stow
```

**Arch:**

```bash
sudo pacman -S --needed curl git stow
```

### 2. Clone

```bash
# HTTPS
git clone https://github.com/contento/dotfiles.git ~/dotfiles

# SSH
git clone git@github.com:contento/dotfiles.git ~/dotfiles

cd ~/dotfiles
```

### 3. Install base packages

```bash
chmod +x bootstrap.sh

# Preview what will happen (no changes made)
./bootstrap.sh --dry-run

# Run
./bootstrap.sh
```

### 4. Symlink dotfiles with Stow

```bash
chmod +x stow-all.sh

# Preview
./stow-all.sh --dry-run

# Run
./stow-all.sh
```

---

## Scripts

### `bootstrap.sh`

Installs packages across platforms. On macOS uses Homebrew; on Ubuntu uses `apt` (with Homebrew fallback for some tools); on Arch uses `yay` (with Homebrew fallback).

Also installs:
- [Starship](https://starship.rs/) prompt
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
- [Tmux Plugin Manager (TPM)](https://github.com/tmux-plugins/tpm) + plugins: tmux-sensible, tmux-resurrect, tmux-continuum, tmux-fzf, tmux-sessionx, tmux-yank, rose-pine

```
Options:
  --dry-run       Simulate installation without making changes
  --no-brew       Skip Homebrew installation (Linux only; required on macOS)
  --no-terminal   Skip terminal/shell plugin setup
  --help          Show help
```

Logs are written to `logs/bootstrap-YYYY-MM-DD.log`.

### `stow-all.sh`

Unstows and re-stows all config packages into `$HOME` using GNU Stow.
Skips the `logs/` directory by default.

```
Options:
  --dry-run           Simulate without making changes (uses stow --simulate)
  --verbose           Enable verbose output
  --exclude=DIR,...   Comma-separated list of dirs to skip (default: logs)
  --help              Show help
```

**Examples:**

```bash
# Dry run
./stow-all.sh --dry-run

# Exclude multiple dirs
./stow-all.sh --exclude=logs,brew

# Verbose dry run
./stow-all.sh --dry-run --verbose
```

### `fix-ssh-perms.sh`

Sets correct permissions on `~/.ssh` and all `id_rsa*` key files (`700` / `600`).

```
Options:
  --dry-run   Show what would be changed without applying it
  --help      Show help
```

```bash
# Preview
./fix-ssh-perms.sh --dry-run

# Apply
./fix-ssh-perms.sh
```

---

## Homebrew

```bash
# Save current packages before leaving a machine
brew leaves > brew/leaves.txt

# Restore on a new machine
xargs brew install < brew/leaves.txt
```

---

## Shell Setup

### ZSH (primary)

```bash
# Ubuntu/Debian
sudo apt install -y zsh
chsh -s "$(which zsh)"
logout

# Arch
sudo pacman -S zsh
chsh -s "$(which zsh)"
```

ZSH config lives in `~/.config/zsh/` (XDG-compliant). Entry point is `~/.zshenv`.

### Bash

`.bashrc` is a fallback / secondary shell config. Activated on machines where zsh is not the default.

### Environment variable guards

All env vars that depend on a command or file are guarded so the shell never fails on a fresh machine:

- `PAGER` — falls back to `less` if `most` is not installed
- `EDITOR` — falls back to `vim` then `vi` if `nvim` is not installed
- `FZF_*` vars — only set when both `fd` and `fzf` are installed
- `PATH` additions — only added when the target directory exists
- `.local/bin/env` — only sourced if the file exists

---

## SSH

```bash
# Start the agent
eval "$(ssh-agent -s)"

# Fix permissions
./fix-ssh-perms.sh

# Copy public key to a remote host
ssh-copy-id -i ~/.ssh/id_rsa-<ID>.pub <user>@<host>
```

Example `~/.ssh/config` entry:

```
Host <alias>
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_rsa-<ID>
    AddKeysToAgent yes
```

---

## Wiki

A full Obsidian knowledge base lives in [`wiki/`](./wiki/Home.md).  
Open the `wiki/` folder as an Obsidian vault to browse with graph view and wikilinks.

---

## References

- [GNU Stow](https://www.gnu.org/software/stow/)
- [LazyVim](https://www.lazyvim.org/)
- [Starship](https://starship.rs/)
- [wesdoyle/dotfiles](https://github.com/wesdoyle/dotfiles.git)

## Notes

See the [[wiki/Platform/Ubuntu]] page for Linux-specific setup notes.
