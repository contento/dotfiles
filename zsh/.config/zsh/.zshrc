#!/bin/zsh

#   o  o
# \______/
#   |
#      |    https://conten.to
# --------

export TERM="xterm-256color" # getting proper colors

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

  export HISTSIZE=1000
  export SAVEHIST=1000
  export HISTFILE=$ZSH_PATH/.zsh_history
  export HIST_STAMPS="yyyy-mm-dd"
  export HISTIGNORE='&:*:(ls|cd|pwd|exit|sudo reboot|history|cd -|cd ..)'
}

setup_aliases() {
  setup_git_aliases

  setup_eza_aliases

  setup_python_aliases

  setup_tmux_aliases

  setup_k8s_aliases

  setup_podman_aliases

  setup_nav_aliases

  setup_file_aliases

  setup_job_aliases

  setup_tool_aliases

  if type zoxide >/dev/null 2>&1; then
    alias cd="z"
  fi

  setup_cat_aliases

  # yazi aliases
  if type yazi >/dev/null 2>&1; then
    alias y="yazi"
  fi

  # adding flags
  alias df='df -h'               # human-readable sizes
  alias free='free -m'           # show sizes in MB
  alias grep='grep --color=auto' # colorize output (good for log files)

  # vim/nvim aliases
  alias v="nvim ."

  # vscode aliases
  alias c='code .'
}

setup_nav_aliases() {
  alias ..='cd ..'
  alias ...='cd ../..'

  # create a directory and cd into it
  mkd() {
    mkdir -p "$1" && cd "$1"
  }
}

setup_file_aliases() {
  alias cp='cp -i'
  alias mv='mv -i'
  alias rm='rm -i'
  alias rmf='rm -rf'
}

setup_job_aliases() {
  alias f='fg'
  alias j='jobs'
  alias h='htop'
}

setup_tool_aliases() {
  if type lazygit >/dev/null 2>&1; then
    alias lg='lazygit'
  fi

  if type make >/dev/null 2>&1; then
    alias m='make'
  fi

  if type docker >/dev/null 2>&1; then
    alias d='docker'
  fi
}

setup_cat_aliases() {
  local alternatives=("batcat" "bat")
  for alt in "${alternatives[@]}"; do
    if type "$alt" >/dev/null; then
      alias cat="$alt --style=plain --pager=never"
      alias catp="$alt"
      break
    fi
  done
}

setup_eza_aliases() {
  if type eza >/dev/null 2>&1; then
    alias ls='eza --color=always --git --icons=always'
  fi

  alias l='ls -lA'
  alias ll='ls -l'
  alias lt='ls --tree'

}
setup_python_aliases() {
  if type python3 >/dev/null 2>&1; then
    alias python='python3'
  fi
  if type pip3 >/dev/null 2>&1; then
    alias pip='pip3'
  fi
}

setup_tmux_aliases() {
  if type tmux >/dev/null 2>&1; then
    alias t="tmux"
    alias tm="tmux new-session -s"
    alias tl="tmux list-sessions"
    alias tk="tmux kill-session -t"
    alias tks="tmux kill-server"
    alias ta="tmux attach -t"
  fi
}

setup_git_aliases() {
  if type git >/dev/null 2>&1; then
    alias g='git'
    alias ga='git add'
    alias gc='git commit'
    alias gca='git commit --amend'
    alias gco='git checkout'
    alias gd='git diff'
    alias gl='git log'
    alias gp='git pull'
    alias gpu='git push'
    alias gst='git status'
  fi
}

setup_k8s_aliases() {
  if type kubectl >/dev/null 2>&1; then
    alias k='kubectl'
    alias kgp='kubectl get pods'
    alias kgs='kubectl get svc'
    alias kgn='kubectl get nodes'
    alias kga='kubectl get all'
    alias kdp='kubectl describe pod'
    alias kds='kubectl describe svc'
    alias kdel='kubectl delete'
    alias kaf='kubectl apply -f'
    alias kctx='kubectl config use-context'
    alias kns='kubectl config set-context --current --namespace'
    alias kl='kubectl logs'
    alias kexec='kubectl exec -it'
  fi
}

setup_podman_aliases() {
  if type podman >/dev/null 2>&1; then
    alias p='podman'
    alias plogs='podman logs'
    alias pps='podman ps'
    alias ppa='podman ps -a'
    alias pi='podman images'
    alias prun='podman run'
    alias pexec='podman exec -it'
    alias pstop='podman stop'
    alias prm='podman rm'
    alias primi='podman rmi'
    alias pbld='podman build'
    alias ppull='podman pull'
    alias ppush='podman push'
    alias pinspect='podman inspect'
  fi
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
  [ -d $HOME/.local/bin ] && export PATH=$HOME/.local/bin:$PATH

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
    local cuda_ver
    cuda_ver="$(ls -d /usr/local/cuda-*(N) 2>/dev/null | sort -V | tail -1)"
    if [ -n "$cuda_ver" ]; then
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

  # Initialize fzf if available
  if type fzf >/dev/null 2>&1; then
    source <(fzf --zsh)
  fi

  # Initialize zoxide if available
  if type zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
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

setup_additional_tools_linux() {
  # No-op: brew shellenv is handled by setup_brew() above
  :
}

setup_additional_tools_mac() {
  # No-op: brew shellenv is handled by setup_brew() above
  :
}

# Function to show system info
show_system_info() {
  if type pfetch-rs >/dev/null; then
    pfetch-rs
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

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  setup_additional_tools_linux
elif [[ "$OSTYPE" == "darwin"* ]]; then
  setup_additional_tools_mac
else
  echo "Unsupported $OSTYPE"
  exit 1
fi

setup_aliases

show_system_info

if [ -d "$HOME/.config/nvm" ]; then
  export NVM_DIR="$HOME/.config/nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# opencode
[ -d "$HOME/.opencode/bin" ] && export PATH="$HOME/.opencode/bin:$PATH"
