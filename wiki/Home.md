# dotfiles Wiki

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

**Shells:** bash · zsh  
**Platforms:** macOS · Ubuntu/Debian · Arch Linux

---

## Navigation

### Setup
- [[Installation]] — fresh machine setup, step by step
- [[Scripts]] — `install-base.sh`, `stow-all.sh`, `change-ssh-mod.sh`
- [[SSH]] — key management, permissions, agent setup

### Shell
- [[Shell/ZSH]] — primary shell, XDG layout, plugin init
- [[Shell/Bash]] — fallback shell, prompt, aliases
- [[Shell/Aliases]] — full alias reference (git, k8s, podman, tmux, tools)

### Tools
- [[Tools/Neovim]] — LazyVim config, plugins, keymaps
- [[Tools/Tmux]] — config, plugins, session management
- [[Tools/Starship]] — prompt configuration
- [[Tools/Git]] — global config, aliases, credential helper
- [[Tools/Terminals]] — Kitty and Ghostty config
- [[Tools/Yazi]] — file manager config

### Platform notes
- [[Platform/macOS]] — Homebrew, Apple Silicon vs Intel, fonts
- [[Platform/Ubuntu]] — apt, nala, flatpak, zsh setup
- [[Platform/Arch]] — pacman, yay, AUR

---

## Repository layout

```
dotfiles/
├── bash/         → ~/.bashrc
├── brew/         → brew leaves snapshot
├── btop/         → ~/.config/btop/
├── editorconfig/ → ~/.editorconfig
├── fastfetch/    → ~/.config/fastfetch/
├── ghostty/      → ~/.config/ghostty/
├── git/          → ~/.gitconfig
├── kitty/        → ~/.config/kitty/
├── mc/           → ~/.config/mc/
├── nvim/         → ~/.config/nvim/
├── starship/     → ~/.config/starship/
├── tmux/         → ~/.config/tmux/
├── vim/          → ~/.vim/
├── yazi/         → ~/.config/yazi/
├── zed/          → ~/.config/zed/
├── zsh/          → ~/.zshenv + ~/.config/zsh/
└── wiki/         ← you are here
```

Each directory is a Stow package. Running `stow-all.sh` symlinks everything into `$HOME`.
