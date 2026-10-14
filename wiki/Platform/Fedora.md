# Fedora

---

## System update

```bash
sudo dnf upgrade --refresh -y
```

---

## Prerequisites

```bash
sudo dnf install -y curl git stow
```

---

## Package installation

`bootstrap.sh` detects Fedora via `/etc/fedora-release` and uses `sudo dnf install -y`.
If a package fails with dnf, it falls back to `brew install`.

The `dnf` column of `packages.txt` holds the Fedora name. These differ from the
other platforms:

| name | dnf package |
|---|---|
| `dust` | `du-dust` |
| `fd` | `fd-find` (binary is still `fd`) |
| `fonts-firacode` | `fira-code-fonts` |
| `imagemagick` | `ImageMagick` |
| `poppler` | `poppler-utils` |
| `shellcheck` | `ShellCheck` |
| `vim` | `vim-enhanced` |

Tools not in the Fedora repos (e.g. `lazygit`, `yazi`, `smug`, `pfetch-rs`)
fall back to Homebrew, so install brew (`--all` does this) if you want them.
Ghostty is installed from the `scottames/ghostty` COPR repository because its
Homebrew cask requires macOS.
Packages whose `dnf` column is `brew` (`herdr`, `neovim`, `portal`, `superfile`, `tuios`) always come from Homebrew.

---

## Python

`bootstrap.sh` installs `python3.12` and `python3.12-devel` from the Fedora repos
(`venv` is built in). Unlike on Ubuntu, it does **not** repoint `/usr/bin/python3`:
dnf and other system tools rely on the distro's default interpreter. Call
`python3.12` explicitly or create a venv with it.

---

## Flatpak

Flatpak ships with Fedora Workstation. Make sure the full Flathub remote is enabled:

```bash
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```

`bootstrap.sh --all` installs Zen browser from Flathub (`app.zen_browser.zen`).

`bootstrap.sh --all` downloads the matching VeraCrypt `.rpm` from the official
GitHub release, verifies its signature against VeraCrypt's published signing-key
fingerprint, then installs it with dnf. The release must provide a package for
the installed Fedora version and `x86_64` architecture.

---

## ZSH setup

```bash
sudo dnf install -y zsh util-linux-user   # util-linux-user provides chsh
chsh -s "$(which zsh)"
```

Re-login to activate zsh as the default shell.

---

## Notes

- `/etc/fedora-release` is used to detect Fedora in `bootstrap.sh`
- `OSTYPE` is `linux-gnu` on Fedora (same as Debian/Ubuntu and Arch)
