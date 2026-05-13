# Yazi

Terminal file manager.  
Config: `yazi/.config/yazi/yazi.toml` → `~/.config/yazi/yazi.toml`

---

## Settings

| Setting | Value |
|---|---|
| Hidden files | Shown by default |
| Layout ratio | 1 : 2 : 5 (parent : current : preview) |
| Theme | Rose Pine |
| Text wrapping | Disabled |

---

## Usage

```bash
y        # open yazi (alias in .zshrc)
```

Navigate with hjkl. Press `q` to quit and `cd` to the last visited directory (requires the shell function wrapper — Yazi handles this automatically with the `y` alias when configured).

---

## Install

Installed by `install-base.sh`. On macOS:

```bash
brew install yazi
```
