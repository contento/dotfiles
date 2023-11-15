# https://conten.to

# Set XDG_CONFIG_HOME to default if not set (See: https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html)
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

# ZSH and Vim configurations
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export ZSH_PATH="$ZDOTDIR" # Assuming ZSH_PATH and ZDOTDIR are the same
export UPDATE_ZSH_DAYS=13

# Default applications
export PAGER="most"
export EDITOR="vim"
export VISUAL="$EDITOR"

# Projects directory
export PROJECT_HOME="$HOME/projects"

# Vim initialization (See: https://blog.joren.ga/tools/vim-xdg)
export VIMINIT="set nocp | source ${XDG_CONFIG_HOME}/vim/vimrc"

# Rust Cargo environment
CARGO_ENV="$HOME/.cargo/env"
[ -f "$CARGO_ENV" ] && source "$CARGO_ENV"
