# dotfiles

```text
  o  o
\______/
  |
     |    https://conten.to
--------
```


Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).
Supports **macOS**, **Ubuntu/Debian**, and **Arch Linux**. Works with **bash** and **zsh**.

## Repository Structure

```
dotfiles/
├── bash/                 # bash configuration
├── btop/                 # btop resource monitor config
├── editorconfig/         # .editorconfig
├── fastfetch/            # fastfetch system info config
├── ghostty/              # Ghostty terminal config
├── git/                  # git global config & aliases
├── mc/                   # Midnight Commander config
├── nvm/                  # nvm (Node Version Manager) config
├── nvim/                 # Neovim (LazyVim) config
├── smug/                 # Smug declarative tmux session configs
├── starship/             # Starship prompt config
├── tmux/                 # tmux config + TPM
├── vim/                  # Vim config
├── yazi/                 # Yazi file manager config
├── zed/                  # Zed editor config
├── zsh/                  # zsh config (primary shell)
├── wiki/                 # Obsidian knowledge base
├── .githooks/            # Git hooks (pre-commit checks)
├── .github/              # CI workflows
├── bootstrap.sh          # Install packages and terminal tools
├── fix-ssh-perms.sh      # Fix SSH key file permissions
├── Makefile              # Convenience targets (make bootstrap, make stow, etc.)
├── stow-all.sh           # Symlink all configs via stow
└── sync-shell-configs.sh # Detect drift between bash/zsh configs
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

# Install the minimum tool set (default)
./bootstrap.sh

# Install everything
./bootstrap.sh --all
```

The default **minimum** set is enough to use this dotfiles config day-to-day
(shell, prompt, multiplexer, editor, git, search). Pass `--all` to add the
full ~50-tool catalog. See [Tools](#tools) below for the per-tier breakdown.

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

**What it installs:**

1. **Package managers** (if missing) — Homebrew on all platforms; `yay` on Arch.
2. **CLI tools** — ~50 utilities defined in five arrays at the top of the script:
   - `common_apps` — same package name across brew, apt, and yay
   - `linux_apps` — apt-native names (yay falls back to brew on mismatch)
   - `brew_linux_apps` — Linux packages that must come from brew (newer versions)
   - `brew_mac_apps` — macOS-only brew formulas
   - `mac_cask_brew_apps` — macOS brew casks (GUI apps, fonts)

   See the [Tools](#tools) section below for the full categorized reference.
3. **Shell prompt** — [Starship](https://starship.rs/) via its official installer.
4. **Zsh plugins** — cloned to `~/.config/zsh/`:
   - [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
   - [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
5. **Tmux plugins** — [TPM](https://github.com/tmux-plugins/tpm) cloned to `~/.tmux/plugins/tpm`, plugins declared in [tmux/.config/tmux/tmux.conf](tmux/.config/tmux/tmux.conf): tmux-sensible, tmux-resurrect, tmux-continuum, tmux-fzf, tmux-sessionx, tmux-yank, rose-pine.
6. **Node Version Manager** — [nvm](https://github.com/nvm-sh/nvm) cloned to `~/.config/nvm` (XDG-compliant location), with default Node.js version installed from `.nvmrc`.

```
Options:
  --dry-run       Simulate installation without making changes
  --no-brew       Skip Homebrew installation (Linux only; required on macOS)
  --no-terminal   Skip terminal/shell plugin setup
  --minimum       Install only the minimum tool set (default)
  --all           Install the full tool set
  --help          Show help
```

**Tiers:**

- **Minimum (default)** — `stow`, `zsh`, `tmux`, `vim`, `unzip`, `make`, `gcc`, `fzf`, `ripgrep`, `jq`. Plus `starship` and the zsh/tmux plugins (unless `--no-terminal`). This is enough for the shell config in this repo to be fully usable. `git` and `curl` are repo prerequisites and assumed present.
- **Full (`--all`)** — everything above plus the rest of the [Tools](#tools) catalog and macOS GUI casks.

**Linux + minimum skips Homebrew entirely** — every minimum tool is available via `apt`/`yay`, so the ~500MB brew install is unnecessary. Run with `--all` (or install brew manually) if you want it. macOS always installs brew since it's the only package manager.

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
./stow-all.sh --exclude=logs,git

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

## Tools

Reference of CLI tools installed by `bootstrap.sh`. All work on macOS, Ubuntu/Debian, and Arch.

### Shell, prompt & session

| Tool | Purpose |
|---|---|
| [atuin](https://atuin.sh) | Shell history with search and sync |
| [starship](https://starship.rs) | Cross-shell prompt |
| [tmux](https://github.com/tmux/tmux) | Terminal multiplexer |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | Smarter `cd` that learns frequent dirs |
| [fzf](https://github.com/junegunn/fzf) | Fuzzy finder |
| [direnv](https://direnv.net) | Per-directory environment variables |
| [keychain](https://www.funtoo.org/Keychain) | SSH / GPG agent manager |
| [smug](https://github.com/ivaturi/smug) | Declarative tmux session manager |

### File navigation & search

| Tool | Replaces | Purpose |
|---|---|---|
| [eza](https://github.com/eza-community/eza) | `ls` | Modern listing with icons & git status |
| [bat](https://github.com/sharkdp/bat) | `cat` | Syntax-highlighted file viewer |
| [fd](https://github.com/sharkdp/fd) | `find` | Faster, friendlier file finder |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | `grep` | Fast recursive code search |
| [yazi](https://yazi-rs.github.io) | — | Terminal file manager (with previews) |
| [mc](https://midnight-commander.org) | — | Midnight Commander (classic dual-pane) |

### System monitoring & info

| Tool | Replaces | Purpose |
|---|---|---|
| [btop](https://github.com/aristocratos/btop) | `top`/`htop` | Resource monitor |
| [fastfetch](https://github.com/fastfetch-cli/fastfetch) | `neofetch` | System info banner |
| [duf](https://github.com/muesli/duf) | `df` | Disk usage / free space |
| [dust](https://github.com/bootandy/dust) | `du` | Visual directory size |
| [hyperfine](https://github.com/sharkdp/hyperfine) | `time` | Command-line benchmarking |

### Networking

| Tool | Purpose |
|---|---|
| [httpie](https://httpie.io) | Friendlier `curl` |
| [mtr](https://www.bitwizard.nl/mtr) | Traceroute + ping combined |
| [wakeonlan](https://github.com/jpoliv/wakeonlan) | Wake-on-LAN packet sender |
| [lynx](https://lynx.invisible-island.net), [w3m](http://w3m.sourceforge.net) | Text-mode web browsers |

### Git & GitHub

| Tool | Purpose |
|---|---|
| [gh](https://cli.github.com) | GitHub CLI (issues, PRs, releases) |
| [lazygit](https://github.com/jesseduffield/lazygit) | Terminal UI for git |
| [git-delta](https://github.com/dandavison/delta) | Better `git diff` viewer (binary: `delta`) |

### Data & documents

| Tool | Purpose |
|---|---|
| [jq](https://jqlang.org) | JSON processor |
| [yq](https://github.com/mikefarah/yq) | YAML / TOML / XML processor |
| [pandoc](https://pandoc.org) | Universal document converter |
| [tldr](https://tldr.sh) | Simplified, example-based man pages |
| [most](https://www.jedsoft.org/most) | Pager with multi-window support |

### Images & media

| Tool | Purpose |
|---|---|
| [imagemagick](https://imagemagick.org) | Image processing toolkit |
| [pngquant](https://pngquant.org) | Lossy PNG compression |
| [jpegoptim](https://github.com/tjko/jpegoptim) | JPEG compression |
| [ffmpegthumbnailer](https://github.com/dirkvdb/ffmpegthumbnailer) | Video thumbnails (used by yazi) |
| [poppler](https://poppler.freedesktop.org) | PDF rendering (used by yazi) |

### Shell scripting & build

| Tool | Purpose |
|---|---|
| [shellcheck](https://www.shellcheck.net) | Bash / sh linter |
| [shfmt](https://github.com/mvdan/sh) | Shell script formatter |
| `make`, `gcc` | Build essentials |

### Languages & toolchains

| Tool | Purpose |
|---|---|
| [python3](https://www.python.org), `python3-pip` | Python interpreter & package manager |
| [rustup](https://rustup.rs) | Rust toolchain installer |
| [go](https://go.dev) | Go toolchain |
| [nvm](https://github.com/nvm-sh/nvm) | Node.js version manager (installs multiple Node versions) |
| [node](https://nodejs.org) | Node.js runtime (managed via nvm) |

### Editors & terminals

| Tool | Purpose |
|---|---|
| [neovim](https://neovim.io) | Modern Vim (LazyVim config in this repo) |
| [vim](https://www.vim.org) | Classic Vim (fallback editor) |
| [ghostty](https://ghostty.org) | GPU-accelerated terminal |
| [iterm2](https://iterm2.com) | macOS terminal (cask) |

### Misc

| Tool | Purpose |
|---|---|
| [stow](https://www.gnu.org/software/stow) | Symlink farm manager (this repo's foundation) |
| [portal](https://github.com/SpatiumPortae/portal) | Encrypted peer-to-peer file transfer |
| [pfetch-rs](https://github.com/Macchina-CLI/pfetch-rs) | Minimal system info fetch (primary shell fetch tool) |
| `xsel`, `xclip` | X11 clipboard helpers (Linux) |
| `unzip` | Archive extraction |

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

Bash is maintained alongside ZSH as a fallback / secondary shell config. While ZSH is the primary daily driver with richer features (autosuggestions, syntax highlighting, advanced completion), Bash ensures compatibility everywhere: it's the default shell on most Linux distros (`/bin/sh`), the Docker container base, and minimal or headless environments where installing ZSH isn't practical. Both configs share the same aliases, prompt (Starship), and tool integrations so the experience is consistent regardless of which shell is active.

### Node.js & nvm

[nvm](https://github.com/nvm-sh/nvm) (Node Version Manager) is installed at `~/.config/nvm` (XDG-compliant) by `bootstrap.sh`. It allows managing multiple Node.js versions per-project.

```bash
# Check nvm is installed
nvm --version

# List installed Node versions
nvm list

# Install a specific version
nvm install 20

# Use a specific version in the current shell
nvm use 18

# Set a default version
nvm alias default 20
```

The shell configs automatically source nvm on startup, making all installed Node versions available. A `.nvmrc` file at `nvm/.config/nvm/.nvmrc` specifies the default Node version (`lts/*` = latest LTS).

Project-specific `.nvmrc` files in your code repos tell nvm which version to use: `nvm use` reads and switches to that version automatically in compatible shells.

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


---

## Docker Environment

These dotfiles power [contento/linux-dev](https://github.com/contento/linux-dev) — a lightweight Docker container that delivers the same terminal environment on any machine with Docker, without touching the host.

When the image is built with `SETUP_DOTFILES=true` (the default), the container:

1. Clones this repository to `~/.dotfiles`
2. Runs `bootstrap.sh` to install packages via apt + Homebrew
3. Runs `stow-all.sh` to symlink all configs into `$HOME`

The result is a container where the shell, prompt, editor, and tools behave exactly as they do on a native machine. Useful for onboarding, remote work, or keeping a consistent environment across different host OSes (macOS, Linux, Windows via WSL2).

```bash
git clone https://github.com/contento/linux-dev.git
cd linux-dev
./start.sh   # prompts, then drops you into the configured environment
```

## References

- [GNU Stow](https://www.gnu.org/software/stow/)
- [LazyVim](https://www.lazyvim.org/)
- [Starship](https://starship.rs/)
- [wesdoyle/dotfiles](https://github.com/wesdoyle/dotfiles.git)

## Notes

See the [[wiki/Platform/Ubuntu]] page for Linux-specific setup notes.
