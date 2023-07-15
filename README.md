# dotfiles

Linux dot files

## References

* [wesdoyle/dotfiles](https://github.com/wesdoyle/dotfiles.git)

## Notes

You my need to start the SSH Agent and add your SSH keys

```bash
eval $(ssh-agent)
```

## install nala

```bash
sudo apt install -y nala 
```

## Installing ZSH

sudo nala install -y zsh 
zsh
# and ...
chsh -s $(which zsh)
logout

## Installing Dependencies

```bash
pushd $HOME/dotfiles
chmod +x install-base.sh && ./install-base.sh
popd
```

## Running 'dotfiles'

```bash
pushd $HOME/dotfiles
chmod +x .make.sh && ./.make.sh
popd
```

## Additional Notes

[Notes.md](./Notes.md)
