# Tmux

Config: `tmux/.config/tmux/tmux.conf` → `~/.config/tmux/tmux.conf`  
**Prefix: `Ctrl+b`** (default, not changed)

---

## Plugins (TPM)

| Plugin | Purpose |
| --- | --- |
| [tpm](https://github.com/tmux-plugins/tpm) | Plugin manager |
| [tmux-sensible](https://github.com/tmux-plugins/tmux-sensible) | Sensible defaults |
| [tmux-fzf](https://github.com/sainnhe/tmux-fzf) | Fuzzy session/window/pane selection |
| [tmux-yank](https://github.com/tmux-plugins/tmux-yank) | Copy to system clipboard from copy-mode |
| [rose-pine](https://github.com/rose-pine/tmux) | Status bar theme (moon variant) |

---

## Keybindings

### Splits & layout

| Key | Action | Note |
| --- | --- | --- |
| `prefix + v` | New pane below | Replaces default `prefix + "` |
| `prefix + h` | New pane right | Replaces default `prefix + %` |
| `prefix + \` | Toggle status bar | New — no default |

### Pane / nvim navigation (no prefix)

These work globally without a prefix. When the active pane is running nvim, the key is forwarded to nvim for split navigation; otherwise tmux handles it.

| Key | Action | Note |
| --- | --- | --- |
| `C-h` | Move to left pane | Forwarded to nvim when in nvim |
| `C-j` | Move to pane below | Forwarded to nvim when in nvim |
| `C-k` | Move to pane above | Forwarded to nvim when in nvim |
| `C-\` | Last active pane | Forwarded to nvim when in nvim |
| `prefix + l` | Move to right pane | Default tmux — `C-l` intentionally unbound to preserve clear-screen |

Also active in copy-mode-vi.

### Sessions

| Key | Action | Source |
| --- | --- | --- |
| `prefix + F` | Open tmux-fzf menu | tmux-fzf |

### Copy mode (tmux-yank)

| Key | Action |
| --- | --- |
| `prefix + [` | Enter copy-mode |
| `y` | Copy selection to system clipboard |
| `Y` | Copy line to system clipboard |
| `D` | Copy from cursor to end of line |

### Utilities

| Key | Action | Source |
| --- | --- | --- |
| `prefix + C-b` | Send prefix to a nested tmux session | tmux-sensible |
| `prefix + R` | Reload tmux config | tmux-sensible |
| `prefix + I` | Install plugins listed in config | TPM |
| `prefix + U` | Update all installed plugins | TPM |
| `prefix + Alt+u` | Remove plugins not in config | TPM |

---


[smug](https://github.com/ivaturi/smug) defines tmux sessions declaratively in YAML.
Config files live at `smug/.config/smug/` → `~/.config/smug/`.

| Session | Root | Layout |
| --- | --- | --- |
| `caratulai` | `~/projects/contento/caratulai` | shell (100%) |
| `pi` | `~/projects/contento/pi` | agent (75/25 split) + runs omp |
| `dotfiles` | `~/projects/contento/dotfiles` | shell (100%) |
| `conten.to` | `~/projects/contento/conten.to` | shell (100%) |
| `smarttar` | `~/projects/contento/smarttar` | shell (100%) |
| `opensmarttar` | `~/projects/contento/opensmarttar` | shell (100%) |

```bash
smug list              # list available sessions
smug dotfiles          # start session
smug dotfiles -a       # attach if already running
smug stop dotfiles     # kill session
```

---

## Recommended Tools

### Minimal Set (Essential)
| Tool | Purpose | Install |
| --- | --- | --- |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | Fast grep replacement | `brew install ripgrep` |
| [delta](https://github.com/dandavison/delta) | Git diff viewer | `brew install git-delta` |
| [fzf](https://github.com/junegunn/fzf) | Fuzzy finder | `brew install fzf` |
| [eza](https://github.com/eza-community/eza) | Modern ls replacement | `brew install eza` |
| [bat](https://github.com/sharkdp/bat) | Cat with syntax highlighting | `brew install bat` |

### Full Set (Enhanced)
| Tool | Purpose | Install |
| --- | --- | --- |
| [lazygit](https://github.com/jesseduffield/lazygit) | Terminal UI for git | `brew install lazygit` |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | Smarter cd | `brew install zoxide` |
| [atuin](https://github.com/atuinsh/atuin) | Shell history sync | `brew install atuin` |
| [direnv](https://direnv.net/) | Auto-load project env vars | `brew install direnv` |
| [gh](https://cli.github.com/) | GitHub CLI | `brew install gh` |
| [yazi](https://github.com/sxyazi/yazi) | Terminal file manager | `brew install yazi` |

### Aliases
| Alias | Command | Tool |
| --- | --- | --- |
| `rg` | `rg --color=auto` | ripgrep |
| `rga` | `rg --hidden --no-ignore` | ripgrep |
| `rgf` | `rg --files` | ripgrep |
| `ghp` | `gh pr` | gh |
| `ghc` | `gh issue create` | gh |
| `ghs` | `gh status` | gh |
| `de` | `direnv edit .` | direnv |
| `dl` | `direnv allow` | direnv |

See [[Shell/Aliases]] for shell shortcuts (`t`, `tm`, `tl`, `tk`, `tks`, `ta`).
