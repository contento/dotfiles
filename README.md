# dotfiles

Linux dot files

## References

* [wesdoyle/dotfiles](https://github.com/wesdoyle/dotfiles.git)

## Notes

See [Notes.md](./Notes.md)

## Installing Git

```bash
sudo apt install -y git 
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

```bash
pushd $HOME/dotfiles

# software 
chmod +x install-base.sh && ./install-base.sh

# configuration files
chmod +x .make.sh && ./.make.sh

popd
```
