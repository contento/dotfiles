# Yazi

Terminal file manager.  
Config: `yazi/.config/yazi/yazi.toml` → `~/.config/yazi/yazi.toml`

---

## Settings

| Setting | Value |
|---|---|
| Hidden files | Shown by default (toggle with `.`) |
| Layout ratio | 0 : 2 : 3 (no parent, cwd + preview) |
| Theme | Rose Pine |
| Text wrapping | Disabled |
| Open with | Neovim |

## Keymaps

| Key | Action | Description |
|---|---|---|
| `z` | Zoxide jump | Fuzzy-jump to directory from history |
| `.` | Toggle hidden | Show/hide dotfiles |
| `p` | Trash | Move to system trash instead of permanent delete |
| `e` / `enter` | Edit | Open file in Neovim |

---

## Usage

```bash
y        # open yazi (alias in .zshrc)
```

Navigate with hjkl. Press `q` to quit and `cd` to the last visited directory (requires the shell function wrapper — Yazi handles this automatically with the `y` alias when configured).

---

## Install

Installed by `bootstrap.sh`. On macOS:

```bash
brew install yazi
```
