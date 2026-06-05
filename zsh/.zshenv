#!/bin/zsh

#   o  o
# \______/
#   |
#      |    https://conten.to
# --------

# Set XDG_CONFIG_HOME to default if not set (See: https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html)
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

# Backup folder — sourced from shared shell config
[ -f "$HOME/.config/shell/shared-env.sh" ] && . "$HOME/.config/shell/shared-env.sh"

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

# Project directories — mirrors .bashrc (PROJECTS_DIR used by smug session configs)
export PROJECTS_DIR="$HOME/projects/contento"

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

# nvm — Node.js version manager
if [ -d "$HOME/.config/nvm" ]; then
  export NVM_DIR="$HOME/.config/nvm"
fi

# uv (and other user-local binaries) — added only if the directory exists
[ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"

# Node.js — fallback if nvm is not installed, or use nvm's node directly
if command -v node >/dev/null 2>&1; then
  : # node is available, nothing to do
elif command -v nvm >/dev/null 2>&1; then
  : # nvm is available, will be fully initialized in .zshrc
elif [ -d "$HOME/.config/nvm/versions/node" ]; then
  # nvm is installed but not yet sourced, find the latest node version
  latest_node="$(ls -d "$HOME/.config/nvm/versions/node"/* 2>/dev/null | sort -V | tail -1)"
  [ -d "$latest_node/bin" ] && export PATH="$latest_node/bin:$PATH"
fi
