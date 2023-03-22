# (-:
#     https://conten.to
# :-)

setopt histignorealldups sharehistory
setopt auto_cd

HYPHEN_INSENSITIVE="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"

# Zsh
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

# PATH

[ -d /opt/homebrew/bin ]    && export PATH="/opt/homebrew/bin:$PATH"

# curl -fsSL https://starship.rs/install.sh | sh
if type starship > /dev/null; then eval "$(starship init zsh)"; fi;

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
