# Scripts

All scripts support `--dry-run` to preview changes without applying them.

---

## bootstrap.sh

Cross-platform package installer.

```
./bootstrap.sh [options]

Options:
  --dry-run       Print what would happen, make no changes
  --no-brew       Skip Homebrew installation (Linux only; required on macOS)
  --no-terminal   Skip Starship + zsh plugin + TPM installation
  --minimum       Install only the minimum tool set (default)
  --all           Install the full tool set
  --help          Show help
```

### Tiers

By default the script installs only the **minimum** tool set — just enough for
this dotfiles config to be fully usable:

`stow`, `zsh`, `tmux`, `vim`, `unzip`, `make`, `gcc`, `fzf`, `ripgrep`, `jq`,
plus Starship and the zsh/tmux plugins. `git` and `curl` are repo prerequisites.

Pass `--all` to install the full ~50-tool catalog (extras for media, system
monitoring, networking, GitHub CLI, language toolchains, macOS casks, etc.).

The minimum set is defined by the `is_minimum()` function in
[bootstrap.sh](../bootstrap.sh) — edit that function to change the cutoff.

**Linux + minimum skips Homebrew installation.** Every minimum tool is
available via apt/yay, so the ~500MB brew bootstrap is wasted in this mode.
Use `--all` (or install brew manually) on Linux if you want it. macOS always
installs brew — it's the only package manager.

### How it works

1. Installs `yay` on Arch (if missing)
2. Installs Homebrew (if missing, unless `--no-brew`)
3. Installs packages (filtered by tier):
   - **Arch** → `yay -S`, falls back to `brew install`
   - **Ubuntu** → `apt install`, falls back to `brew install`
   - **macOS** → `brew install` + `brew install --cask` (casks only with `--all`)
4. Installs Starship, zsh-autosuggestions, zsh-syntax-highlighting, TPM

### Package lists

| List | Used on | Naming rule |
|---|---|---|
| `common_apps` | All platforms | Package name identical across brew, apt, and yay |
| `linux_apps` | Linux only (apt/yay) | apt-name; yay falls back to brew on mismatch |
| `brew_linux_apps` | Linux via brew | Pulled from brew on Linux (newer versions than apt/yay) |
| `brew_mac_apps` | macOS via brew | macOS-only formulas |
| `mac_cask_brew_apps` | macOS casks | GUI apps and fonts |

For the full per-tool catalog (with homepage links and purpose), see the
[Tools section in README](../README.md#tools).

Logs go to `logs/bootstrap-YYYY-MM-DD.log`.

---

## stow-all.sh

GNU Stow wrapper — symlinks all config packages into `$HOME`.

```
./stow-all.sh [options]

Options:
  --dry-run           Simulate (passes --simulate to stow)
  --verbose           Verbose output
  --exclude=DIR,...   Comma-separated dirs to skip (default: logs)
  --help              Show help
```

### What it does

1. Discovers all subdirectories in the repo (excluding `logs/` by default)
2. Runs `stow -D` (unstow) on all packages
3. Runs `stow -R` (restow) on all packages, target `$HOME`

### Examples

```bash
./stow-all.sh --dry-run
./stow-all.sh --exclude=logs,git
./stow-all.sh --dry-run --verbose
```

---

---

## sync-shell-configs.sh

Detects drift between the bash and zsh shell configs — reports differences in functions,
tool initializations, and environment variables.

```
./sync-shell-configs.sh [--diff]

Options:
  --diff   Show a full diff of bashrc vs zshrc content (stripped of comments/blank lines)
```

Useful after making changes to one shell config to see if the other needs the same update.

---

## Makefile

Convenience targets for common operations. Run `make` without arguments to see all targets.

| Target | Description |
|---|---|
| `make bootstrap` | Install minimum packages |
| `make bootstrap-all` | Install full package set |
| `make bootstrap-dry-run` | Preview package installation |
| `make stow` | Symlink all configs |
| `make stow-dry-run` | Preview stow |
| `make lint` | Run shellcheck on all scripts |
| `make check-sync` | Verify CLAUDE.md ↔ copilot-instructions.md sync |
| `make install-hooks` | Activate pre-commit hook (sets `core.hooksPath`) |
| `make fix-ssh` | Fix SSH directory permissions |

---

## fix-ssh-perms.sh

Fixes SSH key permissions to the values required by OpenSSH.

```
./fix-ssh-perms.sh [options]

Options:
  --dry-run   Show what would change, apply nothing
  --help      Show help
```

### What it does

| Target | Permission |
|---|---|
| `~/.ssh/` | `700` |
| `~/.ssh/id_rsa*` | `600` |

Works on both macOS (`stat -f`) and Linux (`stat -c`).

```bash
# Preview
./fix-ssh-perms.sh --dry-run

# Apply
./fix-ssh-perms.sh
```

---

## backup-local.sh

Creates a timestamped archive of machine-specific, **non-stowed** configs — the
files that intentionally never enter this public repo. This is the supported way
to preserve `~/.ssh` across machines (see [[SSH]]).

```
./backup-local.sh [options]

Options:
  --format FORMAT   Compression format: zip (default) or 7z
  --dry-run         Show what would be backed up, create nothing
  --help, -h        Show help
```

### What it backs up

| Source | Notes |
|---|---|
| `~/.config/smug/*.yml` | Session configs; excludes the `projects.yml` template |
| `~/.config/zsh/.zsh_history` | Zsh command history |
| `~/.ssh/` | SSH config **and keys** — kept out of git, backed up here instead |

### Where it writes

Archives land under `$BACKUP_FOLDER` (default
`~/.local/share/dotfiles/backups/dotfiles_locals/`) as
`dotfiles_locals_<YYYYMMDD_HHMM>.<zip|7z>`.

```bash
# Preview
./backup-local.sh --dry-run

# Create a backup (zip)
./backup-local.sh

# Better compression (needs p7zip)
./backup-local.sh --format 7z
```

> [!warning] These archives contain private keys
> Store them somewhere private (encrypted disk, password manager, private remote).
> Never commit a `dotfiles_locals_*` archive to this repo.
