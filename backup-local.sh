#!/usr/bin/env bash
set -euo pipefail

# Backup script for machine-specific, non-stowed configs
# Creates a timestamped snapshot of local configs in $BACKUP_FOLDER
# Usage: ./backup-local.sh [--dry-run]

dry_run=false

# Parse flags
while [[ $# -gt 0 ]]; do
  case "$1" in
  --dry-run)
    dry_run=true
    shift
    ;;
  *)
    echo "Usage: $0 [--dry-run]"
    exit 1
    ;;
  esac
done

# Helper to conditionally run commands
run_cmd() {
  if [[ "$dry_run" == true ]]; then
    echo "[dry-run] $*"
  else
    "$@"
  fi
}

# Resolve BACKUP_FOLDER with same fallback as shell configs
BACKUP_FOLDER="${BACKUP_FOLDER:-${XDG_DATA_HOME:-$HOME/.local/share}/dotfiles/backups}"

# Create timestamped backup folder
timestamp="$(date +%Y-%m-%d_%H-%M-%S)"
backup_dest="$BACKUP_FOLDER/$timestamp"

echo "Backing up local configs to: $backup_dest"

# Create backup destination
run_cmd mkdir -p "$backup_dest"

# Backup 1: Smug session files (all .yml except projects.yml template)
if [[ -d "$HOME/.config/smug" ]]; then
  smug_count=0
  for yml in "$HOME"/.config/smug/*.yml; do
    # Skip the template file
    if [[ "$(basename "$yml")" != "projects.yml" ]]; then
      run_cmd mkdir -p "$backup_dest/smug"
      run_cmd cp -p "$yml" "$backup_dest/smug/"
      smug_count=$((smug_count + 1))
    fi
  done
  if [[ $smug_count -gt 0 ]]; then
    echo "  ✓ Backed up $smug_count smug session file(s)"
  fi
fi

# Backup 2: Zsh history
if [[ -f "$HOME/.config/zsh/.zsh_history" ]]; then
  run_cmd mkdir -p "$backup_dest/zsh"
  run_cmd cp -p "$HOME/.config/zsh/.zsh_history" "$backup_dest/zsh/"
  echo "  ✓ Backed up zsh history"
fi

# Backup 3: SSH config and keys (if exists)
if [[ -d "$HOME/.ssh" ]]; then
  run_cmd mkdir -p "$backup_dest/ssh"
  run_cmd cp -rp "$HOME/.ssh" "$backup_dest/"
  echo "  ✓ Backed up ~/.ssh/"
fi

if [[ "$dry_run" == true ]]; then
  echo ""
  echo "Dry-run complete. No files were created."
else
  echo ""
  echo "Backup complete: $backup_dest"
fi
