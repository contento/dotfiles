# dotfiles

Linux dot files

## References

* [wesdoyle/dotfiles](https://github.com/wesdoyle/dotfiles.git)

## Notes

* You my need to start the SSH Agent `eval $(ssh-agent)' and add your SSH keys


## Installing Dependencies

    pushd $HOME/dotfiles
    chmod +x install-base.sh && ./install-base.sh
    popd

## Install dot files

    pushd $HOME/dotfiles
    chmod +x .make.sh && ./.make.sh
    popd

# Additional Notes

[Notes.md](./Notes.md)
