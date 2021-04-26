#!/bin/bash
# .make.sh

# (-: 
#     https://conten.to
# :-)

# See https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
[ ! -n "${XDG_CONFIG_HOME:+1}" ] && export XDG_CONFIG_HOME=$HOME/.config

dotfiles_dir=$(pwd)

# Backing up
echo "Moving existing dot files from $HOME to $backup_dir ..."

dotfiles_list=".bashrc .zshenv .zshrc .tmux.conf .vimrc"
backup_dir="$dotfiles_dir/backup/old-dotfiles$(date +"%Y-%m-%d.%H.%M")"
[ ! -d $backup_dir ] && mkdir -p $backup_dir

for file in $dotfiles_list; do
    source="$HOME/$file"
    echo "- Moving $source"
    [ -f $source ] && mv $source $backup_dir
done

# Making sure .config folders exist
echo "Creating $XDG_CONFIG_HOME directories ..."
dotconfig_dirs="zsh tmux vim"
for dir in $dotconfig_dirs; do
    config_dir="$XDG_CONFIG_HOME/dir"
    [ ! -d $config_dir ] && mkdir -p $config_dir
done

# Using own copy
echo "Copying files ..."
cp --force "$dotfiles_dir/.bashrc"              "$HOME"
cp --force "$dotfiles_dir/.zshenv"              "$HOME"
cp --force --recursive "$dotfiles_dir/.config"  "$HOME"
