# >>>> PowerLevel10K >>> 

export ZSH="$HOME/.oh-my-zsh"
export PROJECT_HOME=$HOME/projects

ZSH_THEME="powerlevel10k/powerlevel10k"


POWERLEVEL9K_MODE='nerdfont-complete'
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_TIME_FORMAT='%D{%Y-%m-%d %K:%M}'

POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_middle"

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon virtualenv root_indicator dir dir_writable)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(vi_mode command_execution_time vcs background_jobs time)

# <<<< PowerLevel10K <<<< 

HYPHEN_INSENSITIVE="true"

export UPDATE_ZSH_DAYS=13

ENABLE_CORRECTION="true"

COMPLETION_WAITING_DOTS="true"

HIST_STAMPS="yyyy-mm-dd"

plugins=(git ssh-agent httpie tmux zsh-autosuggestions vi-mode)

[ -f ~/.ssh/id_rsa-contento ] && zstyle :omz:plugins:ssh-agent identities id_rsa-contento
zstyle :omz:plugins:ssh-agent lifetime 168h 

source $ZSH/oh-my-zsh.sh

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

ZSH_DISABLE_COMPFIX=true
# alias - python
alias python='python3'
alias pip='pip3'

# alias - tmux 
alias tmux="TERM=screen-256color-bce tmux"
alias tm="tmux new-session"
alias tl="tmux list-sessions"
alias ta="tmux attach -t"

# >>> JMeter >>>

if [[ ! "$OSTYPE" == "darwin"* ]] then
    # OSX doesn't require these variables for JMeter to work
    # To install jmeter use:
    #   brew install jmeter
    JMETER_INSTALL=~/apache-jmeter-5.2.1

    export JMETER_HOME=~/apache-jmeter
    [[ ! -d $JMETER_HOME && -d $JMETER_INSTALL ]] && ln -s $JMETER_INSTALL $JMETER_HOME
 
    export JMETER_BIN=$JMETER_HOME/bin
fi

# <<< JMeter <<<

# >>> PATH >>>

export PATH="$PATH:/opt/mssql-tools/bin"

# <<< PATH <<<

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export PAGER="most"
export EDITOR=vim

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
