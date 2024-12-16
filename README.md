# dotfiles

Linux and Mac OS DOT files

## References

-   [wesdoyle/dotfiles](https://github.com/wesdoyle/dotfiles.git)
-   [LazyVim](https://www.lazyvim.org/)
-   [neovim for newbs](https://github.com/cpow/neovim-for-newbs.git)

## Notes

See [Notes.md](./Notes.md)

## Installing Git

```bash
sudo apt install -y curl git
eval $(ssh-agent)
```

## Installing [nala](https://github.com/volitank/nala)

```bash
sudo apt install -y nala
```

## Installing ZSH

```bash
sudo nala install -y zsh
zsh
# and ...
chsh -s $(which zsh)
logout
```

## Installing

### Homebrew installation [OPTIONAL]

```bash
# Leaving a machine
brew leaves > leaves.txt

# Fresh installation
xargs brew install < leaves.txt
```

### Generic

```bash
chmod +x install-base.sh && ./install-base.sh
```

### Adjust $HOME/.config with stow

```bash
sh stow-all.sh # stow */
```
