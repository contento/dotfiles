# dotfiles Wiki

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

**Shells:** bash · zsh
**Platforms:** macOS · Ubuntu/Debian · Arch Linux

---

## Navigation

### Setup
- [[Installation]] — fresh machine setup, step by step
- [[Scripts]] — `bootstrap.sh`, `stow-all.sh`, `fix-ssh-perms.sh`, `sync-shell-configs.sh`, `backup-local.sh`
- [[Makefile]] — `make bootstrap`, `make stow`, `make lint`, etc.
- [[SSH]] — key management, permissions, agent setup
- [Architecture](../README.md#architecture) — diagram of how the scripts, packages, and `$HOME` connect

### Shell
- [[Shell/ZSH]] — primary shell, XDG layout, plugin init
- [[Shell/Bash]] — fallback shell, prompt, aliases
- [[Shell/Aliases]] — full alias reference (git, k8s, podman, tmux, tools)

### Tools
- [[Tools/Neovim]] — LazyVim config, plugins, keymaps
- [[Tools/Tmux]] — config, plugins, session management
- [[Tools/Starship]] — prompt configuration
- [[Tools/Git]] — global config, aliases, credential helper, delta diff viewer
- [[Tools/Terminals]] — Kitty and Ghostty config
- [[Tools/Yazi]] — file manager config
- [[Tools/Zed]] — editor config, panels, agent settings

### Platform notes
- [[Platform/macOS]] — Homebrew, Apple Silicon vs Intel, fonts
- [[Platform/Ubuntu]] — apt, nala, flatpak, zsh setup
- [[Platform/Arch]] — pacman, yay, AUR

---

## Repository layout

```
dotfiles/
├── bash/                 → ~/.bashrc
├── btop/                 → ~/.config/btop/
├── delta/                → ~/.config/git/delta/config (git diff pager)
├── direnv/               → ~/.config/direnv/
├── editorconfig/         → ~/.editorconfig
├── fastfetch/            → ~/.config/fastfetch/
├── ghostty/              → ~/.config/ghostty/
├── git/                  → ~/.gitconfig
├── mc/                   → ~/.config/mc/
├── nvim/                 → ~/.config/nvim/
├── nvm/                  → ~/.config/nvm/ (Node Version Manager)
├── ripgrep/              → ~/.config/ripgrep/
├── shared/               → ~/.config/shell/ (env + aliases sourced by BOTH bash and zsh)
├── smug/                 → ~/.config/smug/ (declarative tmux sessions)
├── starship/             → ~/.config/starship.toml
├── tmux/                 → ~/.config/tmux/
├── vim/                  → ~/.vim/
├── yazi/                 → ~/.config/yazi/
├── zed/                  → ~/.config/zed/
├── zsh/                  → ~/.zshenv + ~/.config/zsh/
├── .github/              → CI workflows
├── AGENTS.md             → AI-assistant instructions (Claude Code, Copilot, etc.)
├── Makefile              → Convenience targets
├── bootstrap.sh          → Cross-platform package installer
├── stow-all.sh           → Symlinks every package into $HOME
├── fix-ssh-perms.sh      → Fixes ~/.ssh permissions
├── backup-local.sh       → Archives machine-specific, non-stowed config
├── sync-shell-configs.sh → Bash/ZSH config drift detector
└── wiki/                 ← you are here
```

Each top-level directory (except `logs/` and `wiki/`) is a Stow package. Running
`stow-all.sh` symlinks all of them into `$HOME`. See
[Architecture](../README.md#architecture) for how the scripts and packages fit together.
