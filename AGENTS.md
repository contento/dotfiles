# AGENTS.md

Instructions for AI coding assistants (Claude Code, Copilot, etc.) working in this repo.

## Overview

Personal dotfiles managed with GNU Stow. The repo is **public**.

- **Shells:** bash and zsh — shared shell code must work in both.
- **Platforms:** macOS, Ubuntu/Debian, Fedora, Arch — every script must work on all four.

## Layout

Each top-level directory is a Stow package mirroring `$HOME`
(`nvim/.config/nvim/init.lua` → `~/.config/nvim/init.lua`). Non-package directories:
`logs/`, `wiki/`, `.github/`, `.claude/`, `.vscode/`.

| Path | Purpose |
|---|---|
| `bootstrap.sh` | Installs packages per platform (`--all`, `--dry-run`) |
| `stow-all.sh` | Unstows then restows every package (excludes `logs`, `wiki`) |
| `sync-shell-configs.sh` | Reports drift between bash and zsh configs |
| `backup-local.sh` | Private backup of machine-local files (incl. `~/.ssh`) |
| `fix-ssh-perms.sh` | Fixes `~/.ssh` permissions |
| `bash/.bashrc` | bash config |
| `zsh/.zshenv`, `zsh/.config/zsh/` | zsh config (`.zprofile`, `.zshrc`) |
| `shared/.config/shell/` | `shared-env.sh`, `shared-aliases.sh` — sourced by both shells; put common env/aliases here |
| `wiki/` | Obsidian vault documenting the repo |

## Workflow

- **This repo is the source of truth.** Live configs are symlinks into it — edit here, never
  the target. For new packages or files, tell the user to run `./stow-all.sh` (or
  `stow <package>`); run `--dry-run` first.
- **Verify** with `make lint` (shellcheck) and `./sync-shell-configs.sh` after touching shell
  configs. `make bootstrap-dry-run` / `make stow-dry-run` preview the scripts.
- **Docs are part of the change.** Update `README.md` and the relevant `wiki/` page whenever
  scripts, configs, install steps, or supported tools change.

## Scripting rules

- Start every bash script with `#!/usr/bin/env bash` and `set -euo pipefail` before any logic.
- Every script that mutates state (files, symlinks, permissions, packages) must accept
  `--dry-run`. Route every mutating command through `run_cmd`; don't write separate inline
  `if [[ "$dry_run" == true ]]` branches that duplicate the action.

  ```bash
  run_cmd() {
      if [[ "$dry_run" == true ]]; then
          echo "[dry-run] $*"
      else
          "$@"
      fi
  }
  ```

## Shell config rules

- Guard anything that depends on a command, file, or directory:

  ```bash
  if command -v nvim >/dev/null 2>&1; then export EDITOR=nvim
  elif command -v vim >/dev/null 2>&1; then export EDITOR=vim
  else export EDITOR=vi; fi

  [ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
  [ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"
  ```

- Never hardcode user paths (`/Users/contento/...`) — use `$HOME`.
- In shared files, guard zsh-only syntax with `[ -n "$ZSH_VERSION" ]` and bash-isms with
  `[ -n "$BASH_VERSION" ]`.
- Use `${USER:-$USERNAME}` for the username (`$USERNAME` is unset on macOS).
- `dircolors` is GNU-only: `command -v dircolors >/dev/null 2>&1 && eval "$(dircolors)"`.

## Cross-platform reference

| Concern | macOS | Ubuntu | Fedora | Arch |
|---|---|---|---|---|
| Package manager | `brew` | `apt` → `brew` | `dnf` → `brew` | `yay` → `brew` |
| Brew prefix | `/opt/homebrew` (ARM), `/usr/local` (Intel) | `/home/linuxbrew/.linuxbrew` | same | same |
| `stat` format | `-f "%A %N"` | `-c "%a %n"` | `-c "%a %n"` | `-c "%a %n"` |
| `$OSTYPE` | `darwin*` | `linux-gnu*` | `linux-gnu*` | `linux-gnu*` |
| Distro file | — | `/etc/debian_version` | `/etc/fedora-release` | `/etc/arch-release` |

## Package lists in `bootstrap.sh`

Pick the right array — `common_apps` is also installed via brew on macOS, so a Linux-only
name there (`fonts-firacode`, `python3-pip`, `golang`) breaks macOS.

| Array | Contents |
|---|---|
| `common_apps` | Same name in brew, apt, and yay. Map differing dnf names in the `case` block of `install_with_dnf()` |
| `linux_apps` | Linux-only, native package manager |
| `brew_linux_apps` | Linux packages that must come from brew |
| `brew_mac_apps` | macOS-only brew formulas |
| `mac_cask_brew_apps` | macOS casks (GUI apps, fonts) |

## Machine-specific files

Handle with existence guards in shell configs; don't remove or stow them:
`~/.local/bin/env`, `~/.opencode/bin`, `~/.lmstudio/bin`.

**Never stow or commit `~/.ssh/`** — there is intentionally no `ssh/` package. `.gitignore`
blocks keys, `config*`, `known_hosts*`, etc. as a safety net; `backup-local.sh` handles
private backups.
