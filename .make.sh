#!/bin/bash
# .make.sh
# This script creates symlinks from ~/ to dotfiles dir

dir=~/dotfiles
olddir=~/dotfiles_old
files=".bashrc .vimrc .zshrc .gitconfig .tmux.conf"

declare -A dotfiles_map
dotfiles_map[".bashrc"]=".bashrc"
dotfiles_map[".vimrc"]=".vimrc"
dotfiles_map[".zshenv"]=".zshenv"
dotfiles_map[".zshrc"]=".config/zsh/.zhrc"
dotfiles_map[".tmux"]=".config/tmux/.tmux"

echo "Moving existing dotfiles from ~ to $olddir ..."
mkdir -p $olddir

for file in "${dotfiles_map[@]}"; do
    echo - Moving ~/$file ~/dotfiles_old/
    # echo mv ~/$file ~/dotfiles_old/
done

echo "Copying files ..."
for file in "${dotfiles_map[@]}"; do
    echo - Copying ~/$file ./${dotfiles_map[$file]}
done

# echo "Creating symlink to $file in home directory."
# ln -s $dir/$file ~/$file
