# (-: 
#     https://conten.to
# :-)

# See https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
[ ! -n "${XDG_CONFIG_HOME:+1}" ] && export XDG_CONFIG_HOME=$HOME/.config

export ZDOTDIR=$XDG_CONFIG_HOME/zsh
export ZSH_PATH=$XDG_CONFIG_HOME/zsh
export UPDATE_ZSH_DAYS=13

export PAGER="most"
export EDITOR=vim

export PROJECT_HOME=$HOME/projects

# https://blog.joren.ga/tools/vim-xdg
export VIMINIT="set nocp | source ${XDG_CONFIG_HOME:-$HOME/.config}/vim/vimrc"

# Rust Cargo 
[ -f $HOME/.cargo/env ] && source "$HOME/.cargo/env"
