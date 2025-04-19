# ~/.bashrc: executed by bash(1) for non-login shells.

function check_interactive() {
  case $- in
  *i*) ;;
  *) return ;;
  esac
}

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

# Set up the prompt
function setup_prompt() {
  if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
  fi

  case "$TERM" in
  xterm-color | *-256color) color_prompt=yes ;;
  esac

  force_color_prompt=yes
  if [ -n "$force_color_prompt" ] && [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    color_prompt=yes
  else
    color_prompt=
  fi

  if [ "$color_prompt" = yes ]; then
    PS1='\[\e]0;\w\a\]\n\[\e[38;5;39m\]\u@\h: \[\e[38;5;103m\]\w\[\e[0m\]\n\$ '
  else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
  fi
  unset color_prompt force_color_prompt

  case "$TERM" in
  xterm* | rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
  esac
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

function setup_typical_aliases() {
  export LS_OPTIONS='--color=auto'
  eval "$(dircolors)"
  alias ls='ls $LS_OPTIONS'
  alias ll='ls $LS_OPTIONS -l'
  alias l='ls $LS_OPTIONS -lA'

  alias y='yazi'
  alias v='nvim'
  alias c='code'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
  alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history | tail -n1 | sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
}

function setup_path() {
  [ -d "/usr/local/bin" ] && export PATH=$PATH:/usr/local/bin
  [ -d "$HOME/bin" ] && export PATH=$PATH:$HOME/bin
  # [ -d "/opt/homebrew/opt/rustup/bin" ] && export PATH="/opt/homebrew/opt/rustup/bin:$PATH"
  # shellcheck disable=SC1091
  [ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
}

function show_system_info() {
  [ -x "$(command -v pfetch)" ] && pfetch
}

# Main execution
check_interactive
configure_history
configure_terminal
setup_prompt
setup_path
setup_typical_aliases
load_custom_aliases
enable_completion
setup_ssh_agent
source_fzf
show_system_info
