#!/bin/bash
# .make.sh

# (-:
#     https://conten.to
# :-)

# See https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
[ -z "${XDG_CONFIG_HOME:+1}" ] && export XDG_CONFIG_HOME=$HOME/.config

dotfiles_dir=$(pwd)

# Backing up
echo "[ ] Backing up existing dot files from $HOME to $backup_dir ..."

dotfiles_list=".bashrc .zshenv .zshrc .tmux.conf .vimrc"
backup_dir="$dotfiles_dir/backup/old-dotfiles$(date +"%Y-%m-%d.%H.%M")"
[ ! -d "$backup_dir" ] && mkdir -p "$backup_dir"

for file in $dotfiles_list; do
    source="$HOME/$file"
    echo "- Backing up $source"
    [ -f "$source" ] && mv "$source" "$backup_dir"
done

echo "[X] Done"

# Making sure .config folders exist
echo "[ ] Creating $XDG_CONFIG_HOME directories ..."
dotconfig_dirs="zsh vim"
for dir in $dotconfig_dirs; do
    config_dir="$XDG_CONFIG_HOME/$dir"
    [ ! -d "$config_dir" ] && mkdir -p "$config_dir"
done
echo "[X] Done"

# Using own copy
echo "[ ] Copying new files ..."

cp -f       "$dotfiles_dir/.bashrc"    "$HOME"
cp -f       "$dotfiles_dir/.zshenv"    "$HOME"
cp -f       "$dotfiles_dir/.tmux.conf" "$HOME"
cp -f -R    "$dotfiles_dir/.config"    "$HOME"

echo "[X] Done"
