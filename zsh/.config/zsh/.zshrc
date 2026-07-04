#!/bin/zsh

#   o  o
# \______/
#   |
#      |    https://conten.to
# --------

# NOTE: TERM is intentionally NOT set here — the terminal emulator (Ghostty,
# tmux, iTerm2) advertises its own terminfo; overriding it breaks colors/italics.
# PROJECTS_DIR comes from shared-env.sh (sourced in .zshenv).

# Function to set basic zsh options
setup_zsh_options() {
  setopt histignorealldups sharehistory
  setopt auto_cd
  ZSH_DISABLE_COMPFIX=true
}

setup_history() {
  setopt APPEND_HISTORY
  setopt HIST_REDUCE_BLANKS
  setopt HIST_VERIFY
  setopt INC_APPEND_HISTORY
  setopt EXTENDED_HISTORY
  setopt SHARE_HISTORY

  export HISTSIZE=10000
  export SAVEHIST=10000
  export HISTFILE=$ZSH_PATH/.zsh_history
  export HIST_STAMPS="yyyy-mm-dd"
  # zsh's equivalent of bash HISTIGNORE: single pattern of commands not written to the history file
  HISTORY_IGNORE='(ls|cd|cd ..|pwd|exit|history|sudo reboot)'
}

setup_aliases() {
  # Shared bash/zsh aliases — single source of truth for both shells
  # (cd is replaced by zoxide via `zoxide init --cmd cd` in setup_additional_tools)
  [ -f "$HOME/.config/shell/shared-aliases.sh" ] && . "$HOME/.config/shell/shared-aliases.sh"
}

setup_brew() {
  # Activate brew shellenv on all platforms — auto-detects prefix
  if command -v brew >/dev/null 2>&1; then
    eval "$(brew shellenv 2>/dev/null)"
  fi
}

setup_path() {
  [ -d "/usr/local/bin" ] && export PATH=$PATH:/usr/local/bin
  [ -d "$HOME/bin" ] && export PATH=$PATH:$HOME/bin
  [ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"

  # Rust
  [ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

  # CUDA — auto-detect from /usr/local/cuda symlink, fall back to version scan
  if [ -L /usr/local/cuda ] || [ -d /usr/local/cuda ]; then
    local cuda_dir
    cuda_dir="$(readlink -f /usr/local/cuda 2>/dev/null || echo /usr/local/cuda)"
    [ -d "$cuda_dir/bin" ] && export PATH="$PATH:$cuda_dir/bin"
    [ -d "$cuda_dir/lib64" ] && export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$cuda_dir/lib64"
  else
    # Fall back: check the highest installed CUDA version
    # (N) nullglob qualifier: empty array instead of an error when nothing matches
    local cuda_vers cuda_ver
    cuda_vers=(/usr/local/cuda-*(N))
    if [ ${#cuda_vers[@]} -gt 0 ]; then
      cuda_ver="$(printf '%s\n' "${cuda_vers[@]}" | sort -V | tail -1)"
      [ -d "$cuda_ver/bin" ] && export PATH="$PATH:$cuda_ver/bin"
      [ -d "$cuda_ver/lib64" ] && export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$cuda_ver/lib64"
    fi
  fi

  # dotnet
  if [ -d "$HOME/.dotnet" ]; then
    export DOTNET_ROOT="$HOME/.dotnet"
    export PATH="$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools"
  fi

  # Open Watcom (vendored) — guarded by env var or directory existence
  if [ -n "${WATCOM_DIR:-}" ] && [ -d "$WATCOM_DIR" ]; then
    export WATCOM="$WATCOM_DIR"
    export PATH="$WATCOM/armo64:$PATH"
  elif [ -d "$HOME/projects/contento/open-watcom-zinc/vendor/watcom" ]; then
    export WATCOM=$HOME/projects/contento/open-watcom-zinc/vendor/watcom
    export PATH=$WATCOM/armo64:$PATH
  fi
}

# Function to set up additional tools
setup_additional_tools() {
  # Initialize Starship prompt if available
  if type starship >/dev/null; then
    eval "$(starship init zsh)"
  fi

  # Initialize zsh-autosuggestions if available
  [ -f ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

  # Initialize zsh-syntax-highlighting if available
  [ -f ~/.config/zsh/zsh-highlighting/zsh-syntax-highlighting.zsh ] && source ~/.config/zsh/zsh-highlighting/zsh-syntax-highlighting.zsh

  # Initialize ssh-agent and use keychain to manage keys, if keychain is available
  # $USER is POSIX-portable; $USERNAME is bash/Linux-only and unset on macOS by default
  _ssh_user="${USER:-$USERNAME}"
  if type keychain >/dev/null 2>&1 && [ -f "$HOME/.ssh/id_rsa-$_ssh_user" ]; then
    eval "$(keychain --eval "id_rsa-$_ssh_user")"
  fi
  unset _ssh_user
  # Initialize direnv if available
  if type direnv >/dev/null 2>&1; then
    eval "$(direnv hook zsh)"
  fi

  # Initialize fzf if available
  if type fzf >/dev/null 2>&1; then
    source <(fzf --zsh)
  fi

  # Initialize zoxide if available — --cmd cd replaces cd (with completions)
  if type zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh --cmd cd)"
  fi

  # Initialize atuin if available
  if type atuin >/dev/null 2>&1; then
    eval "$(atuin init zsh)"
  fi
}

setup_osc7() {
  _emit_osc7() {
    local host
    host="$(hostname 2>/dev/null || echo "${HOSTNAME:-localhost}")"
    if [ -n "$TMUX" ]; then
      printf '\ePtmux;\e\e]7;file://%s%s\e\\\a' "${host}" "$PWD"
    else
      printf '\e]7;file://%s%s\a' "${host}" "$PWD"
    fi
  }
  autoload -Uz add-zsh-hook
  add-zsh-hook precmd _emit_osc7
}

# Function to show system info
show_system_info() {
  if type pfetch >/dev/null; then
    pfetch
  elif type fastfetch >/dev/null; then
    fastfetch --config $XDG_CONFIG_HOME/fastfetch/config.jsonc
  fi
}
# Execute all setup functions
setup_zsh_options
setup_history
setup_brew
setup_path
setup_additional_tools
setup_osc7

setup_aliases

show_system_info

setup_nvm() {
  export NVM_DIR="$HOME/.config/nvm"

  # Try Homebrew first
  if command -v brew >/dev/null 2>&1; then
    local brew_nvm_prefix
    brew_nvm_prefix="$(brew --prefix nvm 2>/dev/null)"
    if [ -n "$brew_nvm_prefix" ] && [ -s "$brew_nvm_prefix/nvm.sh" ]; then
      . "$brew_nvm_prefix/nvm.sh"
      [ -s "$brew_nvm_prefix/etc/bash_completion.d/nvm" ] && . "$brew_nvm_prefix/etc/bash_completion.d/nvm"
      return 0
    fi
  fi

  # Try common Linux system paths
  local nvm_paths=(
    "/usr/local/nvm/nvm.sh"
    "/opt/nvm/nvm.sh"
    "/usr/nvm/nvm.sh"
  )
  for nvm_script in "${nvm_paths[@]}"; do
    if [ -s "$nvm_script" ]; then
      . "$nvm_script"
      [ -s "${nvm_script%/*}/bash_completion" ] && . "${nvm_script%/*}/bash_completion"
      return 0
    fi
  done

  # Try git clone in home directory (fallback)
  if [ -s "$NVM_DIR/nvm.sh" ]; then
    . "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
    return 0
  fi
}
setup_nvm

[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# opencode
[ -d "$HOME/.opencode/bin" ] && export PATH="$HOME/.opencode/bin:$PATH"
