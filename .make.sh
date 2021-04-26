#!/bin/bash
# .make.sh

# (-: 
#     https://conten.to
# :-)

DOTCONFIG=".config"

# See https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
[ ! -n "${XDG_CONFIG_HOME:+1}" ] && export XDG_CONFIG_HOME=$HOME/$DOTCONFIG

dir=$HOME/dotfiles
backup_dir="$dir/backup/old-dotfiles$(date +"%Y-%m-%d.%H.%M")"

declare -A dotfiles_map 
# [key]=relative-location
dotfiles_map[".bashrc"]="."
dotfiles_map[".zshenv"]="."
dotfiles_map[".zshrc"]="$DOTCONFIG/zsh"
dotfiles_map[".tmux.conf"]="$DOTCONFIG/tmux"
dotfiles_map[".vimrc"]="$DOTCONFIG/vim"

echo "Creating $DOTCONFIG directories ..."
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
    source="$location/$key"
    destination="$HOME/$location/$key"
    echo "- Copying $source -> $destination"
    cp --force $source $destination
done

# rename .vimrc (special case)
[ -f "$HOME/$DOTCONFIG/vim/.vimrc" ] && mv "$HOME/$DOTCONFIG/vim/.vimrc" "$HOME/$DOTCONFIG/vim/vimrc"
