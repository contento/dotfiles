#!/bin/zsh  # This looks like a zsh configuration, so we specify zsh as the interpreter

# Function to set basic zsh options
setup_zsh_options() {
  setopt histignorealldups sharehistory
  setopt auto_cd
  ZSH_DISABLE_COMPFIX=true
}

# Function to set up history
setup_history() {
  HISTSIZE=1000
  SAVEHIST=1000
  HISTFILE=$ZSH_PATH/.zsh_history
  HIST_STAMPS="yyyy-mm-dd"
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
  alias python='python3'
  alias pip='pip3'

  # Tmux aliases
  alias tmux="TERM=screen-256color-bce tmux"
  alias tm="tmux new-session"
  alias tl="tmux list-sessions"
  alias ta="tmux attach -t"

  # Eza - lz aliases
  # ---- Eza (better ls) -----
  alias lz="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"

  # xoxide aliases
  alias cd="z"
}

# Function to find an alternative to 'cat'
setup_cat_alternative() {
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

  [ -d $HOME/miniconda3/bin ] && export PATH="$PATH:$HOME/miniconda3/bin"

  # CUDA
  cuda_version=11.8
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

  # Initialize ssh-agent and use keychain to manage keys
  eval $(keychain --eval --agents ssh "id_rsa-$USERNAME")

  # Initialize fzf
  eval "$(fzf --zsh)"

  # ---- Zoxide (better cd) ----
  eval "$(zoxide init zsh)"
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
setup_cat_alternative
setup_path
setup_additional_tools
setup_aliases
show_system_info
