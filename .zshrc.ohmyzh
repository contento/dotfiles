export ZSH="$HOME/.oh-my-zsh"
export PROJECT_HOME=$HOME/projects

ZSH_THEME="fino"

HYPHEN_INSENSITIVE="true"

export UPDATE_ZSH_DAYS=13

ENABLE_CORRECTION="true"

COMPLETION_WAITING_DOTS="true"

HIST_STAMPS="yyyy-mm-dd"

plugins=(git ssh-agent httpie tmux zsh-autosuggestions vi-mode)

[ -f ~/.ssh/id_rsa-contento ] && zstyle :omz:plugins:ssh-agent identities id_rsa-contento
zstyle :omz:plugins:ssh-agent lifetime 168h

source $ZSH/oh-my-zsh.sh

ZSH_DISABLE_COMPFIX=true

# alias - python
alias python='python3'
alias pip='pip3'

# alias - tmux
alias tmux="TERM=screen-256color-bce tmux"
alias tm="tmux new-session"
alias tl="tmux list-sessions"
alias ta="tmux attach -t"

# >>> PATH >>>

[ -d /opt/mssql-tools/bin ] && export PATH="$PATH:/opt/mssql-tools/bin"
[ -d ~/.cargo/bin ]         && export PATH="$PATH:$HOME/.cargo/bin"

# <<< PATH <<<

export PAGER="most"
export EDITOR=vim

