# macOS

---

## Prerequisites

```bash
xcode-select --install   # Xcode CLI tools (required for git, make, gcc)
```

Homebrew is installed automatically by `bootstrap.sh`.

---

## Homebrew

| Architecture | Homebrew prefix |
|---|---|
| Apple Silicon (M1+) | `/opt/homebrew` |
| Intel | `/usr/local` |

`.zprofile` detects the correct prefix automatically.

### Manage packages

```bash
# Save current installed formulae
brew leaves > brew/brew.txt

# Restore on a new machine
xargs brew install < brew/brew.txt
```

---

## Fonts (Cask)

Installed by `bootstrap.sh` as casks:

```bash
brew install --cask font-fira-code font-fira-code-nerd-font font-delugia-complete
```

---

## macOS-specific packages

Installed via `brew_mac_apps` and `mac_cask_brew_apps` in `bootstrap.sh`:

- **fzf**, **go**, **neovim**, **node** (brew formulas)
- **iterm2**, fonts (brew casks)

---

## Notes

- The `OSTYPE` check in `.zshrc` uses `darwin*` to detect macOS
- `stat` on macOS uses `-f` format strings (BSD), not `-c` (GNU)
- `dircolors` is not available on macOS without GNU coreutils — guarded in `.bashrc`
- `$USERNAME` is not set by default on macOS; `$USER` is used instead
