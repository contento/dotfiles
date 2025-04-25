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
  alias v="nvim"

  # vscode aliases
  alias c='code'
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

setup_path() {
  [ -d "/usr/local/bin" ] && export PATH=$PATH:/usr/local/bin
  [ -d "$HOME/bin" ] && export PATH=$PATH:$HOME/bin
  [ -d $HOME/.local/bin ] && export PATH=$HOME/.local/bin:$PATH

  # brew
  # shellcheck disable=SC1091
  [ -d /opt/homebrew/bin ] && export PATH="$PATH:/opt/homebrew/bin"
  [ -d /home/linuxbrew/.linuxbrew/bin ] && export PATH="$PATH:/home/linuxbrew/.linuxbrew/bin"

  # Rust
  [ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

  # CUDA
  cuda_version=12
  [ -d "/usr/local/cuda-$cuda_version/bin" ] && export PATH="$PATH:/usr/local/cuda-$cuda_version/bin"
  [ -d "/usr/local/cuda-$cuda_version/lib64" ] && export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/cuda-$cuda_version/lib64"

  # dotnet
  export DOTNET_ROOT=$HOME/.dotnet
  [ -d $DOTNET_ROOT ] && export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools
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
  if type keychain >/dev/null 2>&1 && [ -f "$HOME/.ssh/id_rsa-$USERNAME" ]; then
    eval $(keychain --eval --agents ssh "id_rsa-$USERNAME")
  fi

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

setup_additional_tools_linux() {
  # ---- brew
  [ -f /home/linuxbrew/.linuxbrew/bin/brew ] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
}

setup_additional_tools_mac() {
  # brew ???
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
setup_path
setup_additional_tools

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

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
