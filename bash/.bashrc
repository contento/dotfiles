# ~/.bashrc: executed by bash(1) for non-login shells.
# shellcheck shell=bash

# Backup folder and project directories — sourced from shared shell config
[ -f "$HOME/.config/shell/shared-env.sh" ] && . "$HOME/.config/shell/shared-env.sh"

# Bail out when not running interactively. This must stay inline at file level:
# a `return` inside a function only exits the function, not this file, and any
# output from the rest of this file breaks scp/sftp/rsync.
case $- in
*i*) ;;
*) return ;;
esac

function configure_history() {
  HISTCONTROL=ignoreboth
  shopt -s histappend
  HISTSIZE=10000
  HISTFILESIZE=20000
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
  # --cmd cd replaces cd (with completions), same as zsh
  if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init bash --cmd cd)"
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
  # Use keychain to manage ssh-agent, same as zsh.
  # $USER is POSIX-portable; $USERNAME is bash/Linux-only and unset on macOS by default
  local _ssh_user="${USER:-$USERNAME}"
  if command -v keychain >/dev/null 2>&1 && [ -f "$HOME/.ssh/id_rsa-$_ssh_user" ]; then
    eval "$(keychain --eval "id_rsa-$_ssh_user")"
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
  # plain-ls fallback; shared-aliases.sh overrides ls with eza when available
  alias ls='ls $LS_OPTIONS'

  # bash-only extras
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
  alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history | tail -n1 | sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

  # Shared bash/zsh aliases — single source of truth for both shells
  # shellcheck disable=SC1091
  [ -f "$HOME/.config/shell/shared-aliases.sh" ] && . "$HOME/.config/shell/shared-aliases.sh"
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
  [ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"
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
