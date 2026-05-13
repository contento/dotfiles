# Terminals

---

## Ghostty

Config: `ghostty/.config/ghostty/config` → `~/.config/ghostty/config`

| Setting | Value |
|---|---|
| Font | FiraCode Nerd Font Mono, size 14 |
| Theme | Rose Pine |
| Window decoration | `client` (custom titlebar) |

Ghostty is the primary terminal. GPU-accelerated, native macOS feel, fast startup.

---

## Font

Both terminals use **FiraCode Nerd Font Mono** for ligatures and icon support.

### Install on macOS

```bash
brew install --cask font-fira-code-nerd-font
```

### Install on Linux

```bash
# Ubuntu/Debian
sudo apt install fonts-firacode

# Or download from nerdfonts.com and place in ~/.local/share/fonts/
fc-cache -fv
```

---

## Starship prompt

Both terminals render the Starship prompt. See [[Tools/Starship]].
