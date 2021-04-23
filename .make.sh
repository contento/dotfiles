#!/bin/bash
# .make.sh

# (-: 
#     https://conten.to
# :-)

# See https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
[ ! -n "${XDG_CONFIG_HOME:+1}" ] && export XDG_CONFIG_HOME=$HOME/.config

dir=$HOME/dotfiles
backup_dir="$dir/backup/old-dotfiles$(date +"%Y-%m-%d.%H.%M")"

declare -A dotfiles_map 
# [key]=relative-location
dotfiles_map[".bashrc"]=".bashrc"
dotfiles_map[".zshenv"]=".zshenv"
dotfiles_map[".zshrc"]=".config/zsh/.zshrc"
dotfiles_map[".tmux.conf"]=".config/tmux/.tmux.conf"
dotfiles_map[".vimrc"]=".config/vim/vimrc"

echo "Creating .config directories ..."
mkdir -p "$HOME/${dotfiles_map[".zshrc"]}"
mkdir -p "$HOME/${dotfiles_map[".tmux.conf"]}"
mkdir -p "$HOME/${dotfiles_map[".vimrc"]}"

echo "Moving existing dot files from $HOME to $backup_dir ..."
mkdir -p $backup_dir
for key in "${!dotfiles_map[@]}"; do
    source="$HOME/$key"
    echo "- Moving $source"
    mv $source $backup_dir
done

echo "Copying files ..."
for key in "${!dotfiles_map[@]}"; do
    location="${dotfiles_map[$key]}"
    source="./$location"
    destination="$HOME/$location"
    echo "- Copying $source -> $destination"
    cp --force $source $destination
done
