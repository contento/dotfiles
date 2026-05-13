# Arch Linux

---

## Package manager

Arch uses `pacman` as the system package manager and `yay` as the AUR helper.

`bootstrap.sh` installs `yay` automatically if not present.

---

## Prerequisites

```bash
sudo pacman -S --needed curl git stow base-devel
```

---

## yay (AUR helper)

`bootstrap.sh` installs yay automatically:

```bash
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si
```

---

## Package installation

`bootstrap.sh` tries `yay -S <pkg>` first.  
If that fails, it falls back to `brew install <pkg>`.

`brew_linux_apps` (`fzf`, `neovim`, `node`) are always installed via Homebrew.

---

## ZSH setup

```bash
sudo pacman -S zsh
chsh -s "$(which zsh)"
```

Re-login to activate zsh as the default shell.

---

## Notes

- `/etc/arch-release` is used to detect Arch in `bootstrap.sh`
- `OSTYPE` is `linux-gnu` on Arch (same as Debian/Ubuntu)
