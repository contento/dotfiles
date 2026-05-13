# Installation

Step-by-step guide for setting up a fresh machine.

---

## 1. Prerequisites

### macOS

```bash
# Xcode command-line tools (required for Homebrew and git)
xcode-select --install
```

Homebrew is installed automatically by `install-base.sh`.

### Ubuntu / Debian

```bash
sudo apt update && sudo apt install -y curl git stow
```

### Arch Linux

```bash
sudo pacman -S --needed curl git stow
```

---

## 2. Clone the repo

```bash
# HTTPS (no SSH key needed yet)
git clone https://github.com/contento/dotfiles.git ~/dotfiles

# SSH (once keys are set up)
git clone git@github.com:contento/dotfiles.git ~/dotfiles

cd ~/dotfiles
```

---

## 3. Install base packages

```bash
# Preview first — no changes made
./install-base.sh --dry-run

# Install
./install-base.sh
```

What this installs:

| Category | Tools |
|---|---|
| Shell | zsh plugins, Starship, TPM |
| Editors | Neovim (via brew), Vim |
| CLI | bat, eza, fd, fzf, ripgrep, zoxide, atuin, lazygit |
| Monitoring | btop, fastfetch |
| Terminals | Kitty, Ghostty (macOS) |
| Languages | Go, Node, Rust (rustup), Python 3 |
| Utilities | stow, tmux, keychain, pandoc, tldr, mc |

See [[Scripts#install-base.sh]] for full flag reference.

---

## 4. Symlink configs with Stow

```bash
# Preview
./stow-all.sh --dry-run

# Apply
./stow-all.sh
```

This runs `stow -R` on every package directory, creating symlinks in `$HOME`.

---

## 5. Post-install checklist

- [ ] Set zsh as default shell → see [[Platform/Ubuntu]] or [[Platform/Arch]]
- [ ] Set up SSH keys → see [[SSH]]
- [ ] Install tmux plugins: open tmux, press `prefix + I`
- [ ] Install Neovim plugins: open `nvim`, let lazy.nvim auto-install
- [ ] Copy Homebrew packages to new machine: `xargs brew install < brew/brew.txt`

---

## Environment variable safety

All env vars that depend on a command or file are guarded at shell init:

| Variable | Fallback |
|---|---|
| `PAGER` | `less` if `most` not found |
| `EDITOR` | `vim` → `vi` if `nvim` not found |
| `FZF_*` | Not set if `fd` or `fzf` missing |
| `PATH` additions | Skipped if directory does not exist |
| `.local/bin/env` | Sourced only if file exists |

This means the shell never errors on a machine where tools are partially installed.
