# Terminals

---

## Kitty

Config: `kitty/.config/kitty/kitty.conf` → `~/.config/kitty/kitty.conf`

| Setting | Value |
|---|---|
| Font | FiraCode Nerd Font Mono, size 14 |
| Theme | Custom (background `#2f2f2f`, foreground `#afc2c2`) |
| Theme file | `current-theme.conf` (Solarized-inspired) |

Kitty is the feature-rich option: GPU rendering, ligatures, image protocol, layout splits.

---

## Ghostty

Config: `ghostty/.config/ghostty/config` → `~/.config/ghostty/config`

| Setting | Value |
|---|---|
| Font | FiraCode Nerd Font Mono, size 14 |
| Theme | Rose Pine |
| Window decoration | `client` (custom titlebar) |

Ghostty is the lighter / faster option. Preferred on macOS for its native feel.

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
