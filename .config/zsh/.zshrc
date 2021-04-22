# (-: 
#     Gonzalo Contento 
# :-)

# See https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
[ ! -n "${XDG_CONFIG_HOME:+1}" ] && export XDG_CONFIG_HOME=$HOME/.config

setopt histignorealldups sharehistory
setopt auto_cd

HYPHEN_INSENSITIVE="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"

# Zsh
export ZSH_PATH=$XDG_CONFIG_HOME/zsh
export UPDATE_ZSH_DAYS=13
ZSH_DISABLE_COMPFIX=true

# History
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=$ZSH_PATH/.zsh_history
HIST_STAMPS="yyyy-mm-dd"

# fonts
# https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/FiraCode

# alias - ls
# https://github.com/Peltoche/lsd#installation
if type lsd > /dev/null; then alias ls='lsd'; fi;

alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'

# alias - python
alias python='python3'
alias pip='pip3'

# alias - tmux
alias tmux="TERM=screen-256color-bce tmux"
alias tm="tmux new-session"
alias tl="tmux list-sessions"
alias ta="tmux attach -t"

# https://github.com/sharkdp/bat
if type bat > /dev/null; then alias cat='bat'; fi;

export PAGER="most"
export EDITOR=vim
export PROJECT_HOME=$HOME/projects

# PATH 

[ -d /opt/mssql-tools/bin ] && export PATH="$PATH:/opt/mssql-tools/bin"
[ -d ~/.cargo/bin ]         && export PATH="$PATH:$HOME/.cargo/bin"

# curl -fsSL https://starship.rs/install.sh | sh
eval "$(starship init zsh)"

eval "$(ssh-agent -s)"

# git clone https://github.com/zsh-users/zsh-autosuggestions ~/.config/zsh/zsh-autosuggestions
[ -f ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh  ] && source ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.config/zsh/zsh-highlighting
[ -f ~/.config/zsh/zsh-highlighting/zsh-syntax-highlighting.zsh ] && source ~/.config/zsh/zsh-highlighting/zsh-syntax-highlighting.zsh

# System Info 
if type pfetch > /dev/null; then 
	# https://github.com/dylanaraps/pfetch
	pfetch
else 
	if type neofetch > /dev/null; then
		neofetch
	fi
fi;
