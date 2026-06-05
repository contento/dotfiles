#!/usr/bin/env bash
# Shared shell environment — sourced by both .bashrc and .zshenv
# Sets BACKUP_FOLDER by detecting cloud storage.
# shellcheck shell=bash

# Backup folder — intelligently detect cloud storage, fallback to XDG_DATA_HOME
if [ -d "$HOME/Library/Mobile Documents/com~apple~CloudDocs" ]; then
  export BACKUP_FOLDER="$HOME/Library/Mobile Documents/com~apple~CloudDocs/backups"
elif [ -d "$HOME/OneDrive" ]; then
  export BACKUP_FOLDER="$HOME/OneDrive/backups"
elif [ -d "$HOME/Google Drive" ]; then
  export BACKUP_FOLDER="$HOME/Google Drive/backups"
else
  export BACKUP_FOLDER="${XDG_DATA_HOME:-$HOME/.local/share}/backups"
fi
# Create backup folder if it doesn't exist
[ -d "$BACKUP_FOLDER" ] || mkdir -p "$BACKUP_FOLDER" 2>/dev/null
