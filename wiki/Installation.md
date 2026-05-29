# Installation

Step-by-step guide for setting up a fresh machine.

---

## 1. Prerequisites

### macOS

```bash
# Xcode command-line tools (required for Homebrew and git)
xcode-select --install
```

Homebrew is installed automatically by `bootstrap.sh`.

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
./bootstrap.sh --dry-run

# Install the minimum tool set (default)
./bootstrap.sh

# Install everything (~50 tools + macOS casks)
./bootstrap.sh --all
```

The default is **minimum** — just enough for this dotfiles config to be usable:

`stow`, `zsh`, `tmux`, `vim`, `unzip`, `make`, `gcc`, `fzf`, `ripgrep`, `jq`,
plus Starship + zsh/tmux plugins.

On **Linux**, minimum mode also skips installing Homebrew — every minimum
tool is in apt/yay, so the brew bootstrap isn't needed. Use `--all` (or
install brew manually) if you want it. macOS always installs brew.

Pass `--all` to install the full catalog:

| Category | Tools |
|---|---|
| Shell, prompt & session | zsh plugins, Starship, TPM, tmux, atuin, fzf, zoxide, direnv, keychain |
| File navigation & search | bat, eza, fd, ripgrep, yazi, mc |
| System monitoring | btop, fastfetch, duf, dust, hyperfine |
| Networking | httpie, mtr, wakeonlan, lynx, w3m |
| Git & GitHub | gh, lazygit, git-delta |
| Data & documents | jq, yq, pandoc, tldr, most |
| Images & media | imagemagick, pngquant, jpegoptim, ffmpegthumbnailer, poppler |
| Shell scripting | shellcheck, shfmt, make, gcc |
| Languages | Python 3, Rust (rustup), Go (golang), Node |
| Editors | Neovim (via brew), Vim |
| Terminals | Ghostty, iTerm2 (macOS) |
| Utilities | stow, portal, pfetch-rs (Linux), xsel/xclip (Linux) |

See [[Scripts#bootstrap.sh]] for full flag reference, or the
[Tools section in README](../README.md#tools) for per-tool descriptions and homepage links.

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
- [ ] Install git hooks: `make install-hooks`

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
