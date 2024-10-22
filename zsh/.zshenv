#!/bin/zsh

#   o  o
# \______/
#   |
#      |    https://conten.to
# --------

# Set XDG_CONFIG_HOME to default if not set (See: https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html)
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

# ZSH and Vim configurations
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export ZSH_PATH="$ZDOTDIR" # Assuming ZSH_PATH and ZDOTDIR are the same
export UPDATE_ZSH_DAYS=13

# vim/nvim configurations
local nvim_config="${XDG_CONFIG_HOME}/nvim"
local nvim_init="${nvim_config}/init.lua"
if [ -f "${nvim_init}" ]; then
  export VIMINIT="set nocp | source ${nvim_init}"
else
  export VIMINIT="set nocp | source ${XDG_CONFIG_HOME}/vim/vimrc"
fi

# Default applications
export PAGER="most"
export EDITOR="nvim"
export VISUAL="$EDITOR"

# Projects directory
export PROJECT_HOME="$HOME/Projects"

# Rust Cargo environment
CARGO_ENV="$HOME/.cargo/env"
[ -f "$CARGO_ENV" ] && source "$CARGO_ENV"

# -- Use fd instead of fzf --

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

export FZF_CTRL_T_OPTS="--preview 'cat -n --color=always --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
  cd) fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
  export | unset) fzf --preview "eval 'echo $'{}" "$@" ;;
  ssh) fzf --preview 'dig {}' "$@" ;;
  *) fzf --preview "cat -n --color=always --line-range :500 {}" "$@" ;;
  esac
}
