# ~/.bashrc: executed by bash(1) for non-login shells.
# shellcheck shell=bash

function check_interactive() {
  case $- in
  *i*) ;;
  *) return ;;
  esac
}

# Project directories
# PROJECTS_DIR: root for smug session configs (contento projects)
# PROJECT_HOME: general projects directory (may differ, used elsewhere)
export PROJECTS_DIR="$HOME/projects/contento"

# Backup folder for machine-specific configs
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export BACKUP_FOLDER="${XDG_DATA_HOME}/dotfiles/backups"

function configure_history() {
  HISTCONTROL=ignoreboth
  shopt -s histappend
  HISTSIZE=1000
  HISTFILESIZE=2000
}

function configure_terminal() {
  shopt -s checkwinsize
  [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
}

function setup_starship() {
  if command -v starship >/dev/null 2>&1; then
    eval "$(starship init bash)"
  fi
}

function setup_zoxide() {
  if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init bash)"
  fi
}

function setup_atuin() {
  if command -v atuin >/dev/null 2>&1; then
    eval "$(atuin init bash)"
  fi
}

function setup_direnv() {
  if command -v direnv >/dev/null 2>&1; then
    eval "$(direnv hook bash)"
  fi
}

function load_custom_aliases() {
  # shellcheck disable=SC1091
  [ -f "$HOME/.bash_aliases" ] && . "$HOME/.bash_aliases"
}

function enable_completion() {
  if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
      # shellcheck disable=SC1091
      . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
      # shellcheck disable=SC1091
      . /etc/bash_completion
    fi
  fi
}

function setup_ssh_agent() {
  SSH_ENV="$HOME/.ssh/environment"

  function start_agent() {
    echo "Initializing new SSH agent..."
    touch "$SSH_ENV"
    chmod 600 "$SSH_ENV"
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' >>"$SSH_ENV"
    # shellcheck source=/dev/null
    . "$SSH_ENV" >/dev/null
    /usr/bin/ssh-add
  }

  if [ -f "$SSH_ENV" ]; then
    # shellcheck source=/dev/null
    . "$SSH_ENV" >/dev/null
    kill -0 "$SSH_AGENT_PID" 2>/dev/null || start_agent
  else
    start_agent
  fi
}

function source_fzf() {
  # shellcheck disable=SC1091
  [ -f "$HOME/.fzf.bash" ] && source "$HOME/.fzf.bash"
}

function setup_osc7() {
  _emit_osc7() {
    local host
    host="$(hostname 2>/dev/null || echo "${HOSTNAME:-localhost}")"
    if [ -n "$TMUX" ]; then
      printf '\ePtmux;\e\e]7;file://%s%s\e\\\a' "${host}" "$PWD"
    else
      printf '\e]7;file://%s%s\a' "${host}" "$PWD"
    fi
  }
  PROMPT_COMMAND="_emit_osc7${PROMPT_COMMAND:+; $PROMPT_COMMAND}"
}

function setup_typical_aliases() {
  export LS_OPTIONS='--color=auto'
  # dircolors is GNU coreutils — not available on macOS without installing it
  if command -v dircolors >/dev/null 2>&1; then
    eval "$(dircolors)"
  fi
  alias ls='ls $LS_OPTIONS'
  alias ll='ls $LS_OPTIONS -l'
  alias l='ls $LS_OPTIONS -lA'

  alias y='yazi'
  alias v='nvim .'
  alias c='code .'

  # navigation
  alias ..='cd ..'
  alias ...='cd ../..'
  mkd() { mkdir -p "$1" && cd "$1" || return; }

  # file safety
  alias cp='cp -i'
  alias mv='mv -i'
  alias rm='rm -i'
  alias rmf='rm -rf'

  # jobs & system
  alias f='fg'
  alias j='jobs'
  # btop is installed, not htop
  command -v btop >/dev/null 2>&1 && alias h='btop'

  # tool aliases (guarded)
  command -v lazygit >/dev/null 2>&1 && alias lg='lazygit'
  command -v make    >/dev/null 2>&1 && alias m='make'
  command -v docker  >/dev/null 2>&1 && alias d='docker'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
  alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history | tail -n1 | sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
}

function setup_brew() {
  # Activate brew shellenv on all platforms — auto-detects prefix
  if command -v brew >/dev/null 2>&1; then
    eval "$(brew shellenv 2>/dev/null)"
  fi
}

function setup_path() {
  [ -d "/usr/local/bin" ] && export PATH=$PATH:/usr/local/bin
  [ -d "$HOME/bin" ] && export PATH=$PATH:$HOME/bin
  # shellcheck disable=SC1091
  [ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

  # Node.js — fallback if nvm is not installed
  if ! command -v node >/dev/null 2>&1; then
    local latest_node
    # shellcheck disable=SC2012
    latest_node="$(ls -d "$HOME/.config/nvm/versions/node"/* 2>/dev/null | sort -V | tail -1)"
    [ -d "$latest_node/bin" ] && export PATH="$PATH:$latest_node/bin"
  fi

  # CUDA — auto-detect from /usr/local/cuda symlink, fall back to version scan
  if [ -L /usr/local/cuda ] || [ -d /usr/local/cuda ]; then
    local cuda_dir
    cuda_dir="$(readlink -f /usr/local/cuda 2>/dev/null || echo /usr/local/cuda)"
    [ -d "$cuda_dir/bin" ] && export PATH="$PATH:$cuda_dir/bin"
    [ -d "$cuda_dir/lib64" ] && export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$cuda_dir/lib64"
  else
    # Fall back: check the highest installed CUDA version
    # Use nullglob to avoid "no matches found" error when no CUDA versions are installed
    shopt -s nullglob
    local cuda_vers=(/usr/local/cuda-*)
    shopt -u nullglob
    if [ ${#cuda_vers[@]} -gt 0 ]; then
      local cuda_ver
      cuda_ver="$(printf '%s\n' "${cuda_vers[@]}" | sort -V | tail -1)"
      [ -d "$cuda_ver/bin" ] && export PATH="$PATH:$cuda_ver/bin"
      [ -d "$cuda_ver/lib64" ] && export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$cuda_ver/lib64"
    fi
  fi
}

function show_system_info() {
  if command -v pfetch >/dev/null 2>&1; then
    pfetch
  elif command -v fastfetch >/dev/null 2>&1; then
    fastfetch
  fi
}

# Main execution
check_interactive
configure_history
configure_terminal
setup_starship
setup_zoxide
setup_atuin
setup_direnv
setup_brew
setup_path
setup_typical_aliases
load_custom_aliases
enable_completion
setup_ssh_agent
source_fzf
setup_osc7
show_system_info

# nvm
if [ -d "$HOME/.config/nvm" ]; then
  export NVM_DIR="$HOME/.config/nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi

# shellcheck disable=SC1091
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

[ -d "$HOME/.lmstudio/bin" ] && export PATH="$PATH:$HOME/.lmstudio/bin"

[ -d "$HOME/.opencode/bin" ] && export PATH="$HOME/.opencode/bin:$PATH"
