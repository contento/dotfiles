#!/bin/zsh

#   o  o
# \______/
#   |
#      |    https://conten.to
# --------

# Homebrew setup for macOS and Linux
OS_TYPE="$(uname)"
if [ "$OS_TYPE" = "Darwin" ]; then
    # macOS
    if [ -d "/opt/homebrew/bin" ]; then
        # Apple Silicon Macs
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -d "/usr/local/bin" ]; then
        # Intel Macs
        eval "$(/usr/local/bin/brew shellenv)"
    fi
elif [ "$OS_TYPE" = "Linux" ]; then
    # Linux
    if [ -d "/home/linuxbrew/.linuxbrew/bin" ]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    elif [ -d "$HOME/.linuxbrew/bin" ]; then
        # Homebrew installed in user's home directory
        eval "$($HOME/.linuxbrew/bin/brew shellenv)"
    fi
fi
