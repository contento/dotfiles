# CLAUDE.md

## System Prompt for Claude Code

At the start of every conversation in this repository, immediately read `./CLAUDE.md` and follow all rules herein. Treat this file as your primary system instructions.


Guidelines for Claude Code when working in this repository.

> **Kept in sync with [`.github/copilot-instructions.md`](.github/copilot-instructions.md).**
> Any change to one must be mirrored in the other so both assistants follow the same rules.
> A pre-commit hook ([`.githooks/pre-commit`](.githooks/pre-commit)) enforces this — configure with `make install-hooks`.

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

**Keep AI-assistant instructions in sync.** `CLAUDE.md` and `.github/copilot-instructions.md`
share the same body. Any rule change must be applied to both in the same commit. A pre-commit
hook ([`.githooks/pre-commit`](.githooks/pre-commit)) fails the commit if the two files diverge.
Run `make install-hooks` to activate.

## Stow layout

**This repo is the source of truth.** Files under `.config/` and other XDG paths in the live
system are symlinks pointing back here. When you need to create or modify a config file, always
edit it in this repo, then restow. If a new stow package or stow operation is needed, recommend
running `./stow-all.sh` (or `stow <package>` for a single package).

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
- `~/.ssh/` — **never stow.** This repo is public; there is intentionally no `ssh/`
  package. Keys, `config`, and `known_hosts` stay on the machine. `.gitignore` has a
  safety net (`**/.ssh/`, `id_*`, `*.pem`, `*.key`, `config*`, `known_hosts*`,
  `authorized_keys`, `agent/`). Back up `~/.ssh` privately via `./backup-local.sh`.

## graphify

This project has a knowledge graph at graphify-out/ with god nodes, community structure, and cross-file relationships.

Rules:
- For codebase questions, first run `graphify query "<question>"` when graphify-out/graph.json exists. Use `graphify path "<A>" "<B>"` for relationships and `graphify explain "<concept>"` for focused concepts. These return a scoped subgraph, usually much smaller than GRAPH_REPORT.md or raw grep output.
- If graphify-out/wiki/index.md exists, use it for broad navigation instead of raw source browsing.
- Read graphify-out/GRAPH_REPORT.md only for broad architecture review or when query/path/explain do not surface enough context.
- After modifying code, run `graphify update .` to keep the graph current (AST-only, no API cost).
