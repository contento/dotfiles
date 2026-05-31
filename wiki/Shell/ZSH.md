# ZSH

ZSH is the primary daily driver shell — richer features (autosuggestions, syntax highlighting, advanced completion) and full XDG compliance. Bash is kept in sync as a fallback so the same aliases, prompt (Starship), and tool integrations work identically on machines where ZSH isn't available or practical to install.

Config follows the XDG Base Directory spec.

---

## File layout

| File | Symlink target | Purpose |
|---|---|---|
| `zsh/.zshenv` | `~/.zshenv` | Always sourced — exports XDG vars, ZDOTDIR, EDITOR, PAGER, FZF |
| `zsh/.config/zsh/.zprofile` | `~/.config/zsh/.zprofile` | Login shell — initialises Homebrew |
| `zsh/.config/zsh/.zshrc` | `~/.config/zsh/.zshrc` | Interactive shell — options, path, aliases, tool init |

`ZDOTDIR` is set to `~/.config/zsh` in `.zshenv`, so zsh reads `.zprofile` and `.zshrc` from there instead of `$HOME`.

---

## .zshenv

Sourced on every zsh invocation (login, interactive, scripts).

### Key exports

| Variable | Value | Notes |
|---|---|---|
| `XDG_CONFIG_HOME` | `~/.config` | XDG default |
| `ZDOTDIR` | `$XDG_CONFIG_HOME/zsh` | Moves zsh config out of `$HOME` |
| `PAGER` | `most` → `less` | Guarded: falls back if `most` missing |
| `EDITOR` | `nvim` → `vim` → `vi` | Guarded: cascading fallback |
| `FZF_DEFAULT_COMMAND` | `fd --hidden …` | Only set when both `fd` and `fzf` exist |
| `PROJECT_HOME` | `~/Projects` | Convenience variable |

---

## .zprofile

Login shell only. Initialises Homebrew based on OS and architecture:

| Condition | Path |
|---|---|
| macOS (Apple Silicon) | `/opt/homebrew/bin/brew` |
| macOS (Intel) | `/usr/local/bin/brew` |
| Linux | `/home/linuxbrew/.linuxbrew/bin/brew` or `~/.linuxbrew/bin/brew` |

---

## .zshrc

### Options

```zsh
setopt histignorealldups sharehistory auto_cd
setopt APPEND_HISTORY HIST_REDUCE_BLANKS HIST_VERIFY
setopt INC_APPEND_HISTORY EXTENDED_HISTORY SHARE_HISTORY
```

History is stored at `$ZDOTDIR/.zsh_history` (1000 entries, timestamped).

### PATH additions (all guarded)

| Directory | Condition |
|---|---|
| `/usr/local/bin` | if directory exists |
| `~/bin` | if directory exists |
| `~/.local/bin` | if directory exists |
| CUDA | auto-detected via `/usr/local/cuda` symlink or version scan |
| `~/.cargo/bin` (via env) | if `~/.cargo/env` exists |
| `~/.dotnet` | if directory exists |
| `WATCOM` paths | if `$WATCOM_DIR` is set or vendored dir exists |
| `~/.opencode/bin` | if directory exists |

Brew PATH is handled by `setup_brew()` which runs `brew shellenv` (auto-detects prefix
on all platforms). The old hardcoded paths (`/opt/homebrew/bin`, `/home/linuxbrew/.linuxbrew/bin`)
have been removed in favor of this dynamic approach.

### Tool initialisation

| Tool | Init method | Guard |
|---|---|---|
| brew | `brew shellenv` | `command -v brew` (handled by `setup_brew()`) |
| Starship | `starship init zsh` | `type starship` |
| zsh-autosuggestions | source plugin file | `[ -f file ]` |
| zsh-syntax-highlighting | source plugin file | `[ -f file ]` |
| keychain / SSH agent | `keychain --eval` | tool + key file present |
| fzf | `fzf --zsh` | `type fzf` |
| zoxide | `zoxide init zsh` | `type zoxide` |
| atuin | `atuin init zsh` | `type atuin` |
| NVM | source nvm.sh | `[ -s file ]` |

### System info

On shell start, shows `pfetch-rs` (primary) if installed, else `fastfetch` (fallback).

---

## Aliases

See [[Aliases]] for the full reference.
