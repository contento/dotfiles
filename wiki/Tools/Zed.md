# Zed

Config: `zed/.config/zed/settings.json` → `~/.config/zed/settings.json`

---

## Panels

| Panel | Dock |
| --- | --- |
| Project | left |
| Outline | left |
| Git | left |
| Collaboration | left |
| Agent | right |

---

## Editor

| Setting | Value |
| --- | --- |
| `base_keymap` | VSCode |
| `vim_mode` | `true` |
| `ui_font_family` | FiraCode Nerd Font Mono |
| `ui_font_size` | 16 |
| `buffer_font_size` | 15 |
| `soft_wrap` | `none` |
| `relative_line_numbers` | `true` |

---

## Theme

Follows the system light/dark setting:

| Mode | Theme |
| --- | --- |
| Light | One Light |
| Dark | Gruvbox Dark Hard |

---

## Agent panel

`favorite_models` and `model_parameters` are left empty in the tracked config —
configure per-machine from Zed's own settings UI rather than committing model
choices or API-adjacent settings to a public repo.
