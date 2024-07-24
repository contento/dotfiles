#!/bin/zsh  # This looks like a zsh configuration, so we specify zsh as the interpreter

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
  export HIST_IGNORE_PATTERN="(ls|cd|pwd|exit|sudo reboot|history|cd -|cd ..)"
}

# Function to set up aliases
setup_aliases() {
  # lsd aliases
  if type lsd >/dev/null; then
    alias ls='lsd'
  fi

  alias l='ls -l'
  alias la='ls -a'
  alias lla='ls -la'
  alias lt='ls --tree'

  # Python aliases
  if type python3 >/dev/null 2>&1; then
    alias python='python3'
  fi
  if type pip3 >/dev/null 2>&1; then
    alias pip='pip3'
  fi

  # Tmux aliases
  if type tmux >/dev/null 2>&1; then
    alias tmux="TERM=screen-256color-bce tmux"
    alias tm="tmux new-session"
    alias tl="tmux list-sessions"
    alias ta="tmux attach -t"
  fi

  # Eza - lz aliases
  # Check if eza is installed before creating alias
  if type eza >/dev/null 2>&1; then
    alias lz="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
  fi

  # xoxide aliases
  # Check if zoxide is installed before overriding cd
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
}

# Function to find an alternative to 'cat'
setup_cat_aliases() {
  local alternatives=("batcat" "bat")
  for alt in "${alternatives[@]}"; do
    if type "$alt" >/dev/null; then
      alias cat="$alt"
      alias catp="$alt -pp"
      break
    fi
  done
}

# Function to set up PATH
setup_path() {
  [ -d /opt/homebrew/bin ] && export PATH="$PATH:/opt/homebrew/bin"
  [ -d /home/linuxbrew/.linuxbrew/bin ] && export PATH="$PATH:/home/linuxbrew/.linuxbrew/bin"

  [ -d $HOME/miniconda3/bin ] && export PATH="$PATH:$HOME/miniconda3/bin"

  # CUDA
  cuda_version=12
  [ -d "/usr/local/cuda-$cuda_version/bin" ] && export PATH="$PATH:/usr/local/cuda-$cuda_version/bin"
  [ -d "/usr/local/cuda-$cuda_version/lib64" ] && export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/cuda-$cuda_version/lib64"
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
    eval "$(fzf --zsh)"
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
  elif type neofetch >/dev/null; then
    neofetch
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
