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

## Default applications — guarded so missing tools don't break shell init
if command -v most >/dev/null 2>&1; then
  export PAGER="most"
elif command -v less >/dev/null 2>&1; then
  export PAGER="less"
fi

if command -v nvim >/dev/null 2>&1; then
  export EDITOR="nvim"
elif command -v vim >/dev/null 2>&1; then
  export EDITOR="vim"
else
  export EDITOR="vi"
fi
export VISUAL="$EDITOR"

# Projects directory
export PROJECT_HOME="$HOME/Projects"

# -- Use fd instead of find for fzf (guarded: only set if both fd and fzf exist) --

if command -v fd >/dev/null 2>&1 && command -v fzf >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

  _fzf_compgen_path() {
    fd --hidden --exclude .git . "$1"
  }

  _fzf_compgen_dir() {
    fd --type=d --hidden --exclude .git . "$1"
  }

  export FZF_CTRL_T_OPTS="--preview 'cat {}'"
  if command -v eza >/dev/null 2>&1; then
    export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"
  fi

  _fzf_comprun() {
    local command=$1
    shift
    case "$command" in
    cd)
      if command -v eza >/dev/null 2>&1; then
        fzf --preview 'eza --tree --color=always {} | head -200' "$@"
      else
        fzf --preview 'ls -la {}' "$@"
      fi
      ;;
    export | unset) fzf --preview "eval 'echo \$'{}" "$@" ;;
    ssh)           fzf --preview 'dig {}' "$@" ;;
    *)             fzf --preview "cat -n --color always --line-range :500 {}" "$@" ;;
    esac
  }
fi
