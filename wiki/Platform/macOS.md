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

Installed from the `brew` column of `packages.txt` (rows with `-` on the Linux columns, or a `cask:` entry):

- **fzf**, **go**, **neovim**, **node**, **herdr**, **superfile**, **tuios** (brew formulas)
- **iterm2**, **supacode**, **veracrypt** (needs macFUSE), **zen**, fonts (brew casks)

---

## Notes

- The `OSTYPE` check in `.zshrc` uses `darwin*` to detect macOS
- `stat` on macOS uses `-f` format strings (BSD), not `-c` (GNU)
- `dircolors` is not available on macOS without GNU coreutils — guarded in `.bashrc`
- `$USERNAME` is not set by default on macOS; `$USER` is used instead
