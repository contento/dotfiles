#!/usr/bin/env bash
# Shared aliases — sourced by both .bashrc and .zshrc so the two shells stay
# in sync (drift is reported by sync-shell-configs.sh).
# Must work in bash AND zsh: POSIX guards only — no arrays, no shopt/setopt.
# shellcheck shell=bash

# --- git ---
if command -v git >/dev/null 2>&1; then
  alias g='git'
  alias ga='git add'
  alias gc='git commit'
  alias gca='git commit --amend'
  alias gco='git checkout'
  alias gd='git diff'
  alias gl='git log'
  alias gpl='git pull'
  alias gpu='git push'
  alias gst='git status'
fi

# --- ls / eza ---
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --color=always --git --icons=always'
  alias lt='ls --tree'
fi
alias l='ls -lA'
alias ll='ls -l'

# --- python ---
if command -v python3 >/dev/null 2>&1; then
  alias python='python3'
fi
if command -v pip3 >/dev/null 2>&1; then
  alias pip='pip3'
fi

# --- tmux ---
if command -v tmux >/dev/null 2>&1; then
  alias t='tmux'
  alias tm='tmux new-session -s'
  alias tl='tmux list-sessions'
  alias tk='tmux kill-session -t'
  alias tks='tmux kill-server'
  alias ta='tmux attach -t'
fi

# --- kubernetes ---
if command -v kubectl >/dev/null 2>&1; then
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

# --- podman ---
if command -v podman >/dev/null 2>&1; then
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

# --- navigation ---
alias ..='cd ..'
alias ...='cd ../..'
# create a directory and cd into it
mkd() { mkdir -p "$1" && cd "$1" || return; }

# --- file safety ---
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias rmf='rm -rf'

# --- jobs & system ---
alias f='fg'
alias j='jobs'
command -v btop >/dev/null 2>&1 && alias h='btop'

# --- tools ---
command -v lazygit >/dev/null 2>&1 && alias lg='lazygit'
command -v make >/dev/null 2>&1 && alias m='make'
command -v docker >/dev/null 2>&1 && alias d='docker'
command -v yazi >/dev/null 2>&1 && alias y='yazi'

if command -v rg >/dev/null 2>&1; then
  alias rg='rg --color=auto'
  alias rga='rg --hidden --no-ignore'
  alias rgf='rg --files'
fi

if command -v gh >/dev/null 2>&1; then
  alias ghp='gh pr'
  alias ghc='gh issue create'
  alias ghs='gh status'
fi

if command -v direnv >/dev/null 2>&1; then
  alias de='direnv edit .'
  alias dl='direnv allow'
fi

# --- cat / bat (apt installs the binary as batcat) ---
if command -v batcat >/dev/null 2>&1; then
  alias cat='batcat --style=plain --pager=never'
  alias catp='batcat'
elif command -v bat >/dev/null 2>&1; then
  alias cat='bat --style=plain --pager=never'
  alias catp='bat'
fi

# --- adding flags ---
alias df='df -h'               # human-readable sizes
alias free='free -m'           # show sizes in MB
alias grep='grep --color=auto' # colorize output (good for log files)

# --- editors ---
alias v='nvim .'
alias c='code .'
