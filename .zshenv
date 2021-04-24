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

# Vim
# export VIMINIT='let $MYVIMRC = !has("nvim") ? "$XDG_CONFIG_HOME/vim/vimrc" : "$XDG_CONFIG_HOME/nvim/init.vim" | so $MYVIMRC'
export VIMINIT="$XDG_CONFIG_HOME/vim/vimrc"

# Rust Cargo 
[ -f $HOME/.cargo/env ] && source "$HOME/.cargo/env"
