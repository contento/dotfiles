# Scripts

All scripts support `--dry-run` to preview changes without applying them.

---

## install-base.sh

Cross-platform package installer.

```
./install-base.sh [options]

Options:
  --dry-run       Print what would happen, make no changes
  --no-brew       Skip Homebrew installation (Linux only; required on macOS)
  --no-terminal   Skip Starship + zsh plugin + TPM installation
  --help          Show help
```

### How it works

1. Installs `yay` on Arch (if missing)
2. Installs Homebrew (if missing, unless `--no-brew`)
3. Installs packages:
   - **Arch** → `yay -S`, falls back to `brew install`
   - **Ubuntu** → `apt install`, falls back to `brew install`
   - **macOS** → `brew install` + `brew install --cask`
4. Installs Starship, zsh-autosuggestions, zsh-syntax-highlighting, TPM

### Package lists

| List | Used on |
|---|---|
| `common_apps` | All platforms |
| `linux_apps` | Linux only (apt/yay) |
| `brew_linux_apps` | Linux via brew |
| `brew_mac_apps` | macOS via brew |
| `mac_cask_brew_apps` | macOS casks (GUI apps, fonts) |

Logs go to `logs/install-base-YYYY-MM-DD.log`.

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
./stow-all.sh --exclude=logs,brew
./stow-all.sh --dry-run --verbose
```

---

## change-ssh-mod.sh

Fixes SSH key permissions to the values required by OpenSSH.

```
./change-ssh-mod.sh [options]

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
./change-ssh-mod.sh --dry-run

# Apply
./change-ssh-mod.sh
```
