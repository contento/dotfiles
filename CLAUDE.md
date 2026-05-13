# CLAUDE.md

Guidelines for Claude Code when working in this repository.

## Project overview

Personal dotfiles managed with GNU Stow.
Each top-level directory is a Stow package that symlinks into `$HOME`.

Target shells: **bash** and **zsh** — all shell code must work in both.  
Target platforms: **macOS**, **Ubuntu/Debian**, **Arch Linux** — all scripts must work on all three.

## Scripting rules

### Every script must implement `--dry-run`

All scripts that mutate state (files, symlinks, permissions, package installs) must accept a
`--dry-run` flag that prints actions without executing them. Use a `run_cmd()` helper:

```bash
run_cmd() {
    if [[ "$dry_run" == true ]]; then
        echo "[dry-run] $*"
    else
        "$@"
    fi
}
```

Dry-run must be consistent — do not bypass `run_cmd` with inline `if [[ "$dry_run" == true ]]`
blocks in individual functions.

### Guard env vars that depend on a file or command

Never assign an env var from a command substitution or file path without a guard:

```bash
# command-dependent
if command -v nvim >/dev/null 2>&1; then
  export EDITOR="nvim"
elif command -v vim >/dev/null 2>&1; then
  export EDITOR="vim"
else
  export EDITOR="vi"
fi

# file-dependent
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# directory-dependent PATH addition
[ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"
```

Never hardcode absolute user paths like `/Users/contento/...` — always use `$HOME`.

### Shell compatibility

- Avoid zsh-only syntax (`setopt`, `[[` zsh extensions, `=(...)`) in shared files; guard with `[ -n "$ZSH_VERSION" ]`
- Avoid bash-isms in shared files; guard with `[ -n "$BASH_VERSION" ]`
- `$USER` is POSIX-portable. `$USERNAME` is bash/Linux-only and unset on macOS — always use `${USER:-$USERNAME}` when you need a username
- `dircolors` is GNU coreutils only — not available on macOS; always guard: `command -v dircolors >/dev/null 2>&1 && eval "$(dircolors)"`

### Cross-platform differences

| Concern | macOS | Ubuntu | Arch |
|---|---|---|---|
| Package manager | `brew` (required) | `apt`, fallback `brew` | `yay`, fallback `brew` |
| Brew prefix | `/opt/homebrew` (ARM) or `/usr/local` (Intel) | `/home/linuxbrew/.linuxbrew` | `/home/linuxbrew/.linuxbrew` |
| `stat` format | `-f "%A %N"` | `-c "%a %n"` | `-c "%a %n"` |
| `$OSTYPE` | `darwin*` | `linux-gnu*` | `linux-gnu*` |
| Distro detection | — | `/etc/debian_version` | `/etc/arch-release` |

### Package name mapping

Package names differ between brew, apt, and yay. Do not put Linux-specific package names
(e.g. `fonts-firacode`, `python3-pip`, `golang`) in `common_apps` — that array is iterated over
by `install_mac_apps` via brew and will fail.

Use the correct list for each platform:
- `common_apps` — only packages whose name is identical across brew, apt, and yay
- `linux_apps` — Linux-only packages installed via the native package manager
- `brew_linux_apps` — Linux packages that must come from brew
- `brew_mac_apps` — macOS-only brew formulas
- `mac_cask_brew_apps` — macOS brew casks (GUI apps, fonts)

### `set -euo pipefail`

Every bash script must start with `set -euo pipefail` immediately after the shebang.

## Documentation rules

**Keep `README.md` up to date.** After any change to scripts, configs, install steps, or
supported tools, update the relevant README section before considering the task done.

**Keep `wiki/` accurate.** The `wiki/` directory is an Obsidian vault (open `wiki/` as a vault).
Update the relevant wiki page when a config or behaviour changes.

## Stow layout

Each package directory mirrors the target filesystem rooted at `$HOME`:

```
nvim/.config/nvim/init.lua  →  ~/.config/nvim/init.lua
git/.gitconfig               →  ~/.gitconfig
zsh/.zshenv                  →  ~/.zshenv
```

Running `./stow-all.sh` unstows then restows all packages. The `logs/` directory is excluded by
default. Always test changes with `--dry-run` first.

## Known machine-specific files (do not stow blindly)

These files exist on the current machine but are machine-specific and not suitable for all
targets. Handle them with guards in the shell configs rather than removing them:

- `~/.local/bin/env` — sourced only if the file exists
- `~/.opencode/bin` — added to PATH only if the directory exists
- `~/.lmstudio/bin` — added to PATH only if the directory exists
