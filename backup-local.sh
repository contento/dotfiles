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
  --help | -h)
    cat <<EOF
Usage: $0 [OPTIONS]

Creates a timestamped zip archive of machine-specific, non-stowed configs.

OPTIONS:
  --dry-run    Show what would be backed up without creating files
  --help, -h   Show this help message

BACKUP LOCATION:
  \$BACKUP_FOLDER (default: ~/.local/share/dotfiles/backups/)

BACKUP FORMAT:
  {yyyyMMdd_HHmm}.zip (e.g. 20260603_1430.zip)

BACKED UP FILES:
  - ~/.config/smug/*.yml (machine-specific session configs, excludes projects.yml)
  - ~/.config/zsh/.zsh_history (zsh command history)
  - ~/.ssh/ (SSH config and keys)

EXAMPLES:
  # Preview what will be backed up
  $0 --dry-run

  # Create a backup zip
  $0

  # Check backup location
  echo \$BACKUP_FOLDER

  # List backups
  ls -lh \$BACKUP_FOLDER/*.zip
EOF
    exit 0
    ;;
  *)
    echo "Error: unknown option '$1'"
    echo "Run '$0 --help' for usage information."
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

# Create timestamped backup folder and zip file
timestamp="$(date +%Y%m%d_%H%M)"
backup_dest="$BACKUP_FOLDER/$timestamp"
zip_file="$BACKUP_FOLDER/${timestamp}.zip"

echo "Backing up local configs to: $zip_file"

# Create backup destination (temporary folder for staging files before zipping)
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
  # Create zip archive from within the backup folder
  (
    cd "$BACKUP_FOLDER"
    if [[ "$dry_run" == true ]]; then
      echo "[dry-run] zip -r -q $zip_file $timestamp"
    else
      zip -r -q "$zip_file" "$timestamp" || {
        echo "Error: failed to create zip archive"
        exit 1
      }
      # Clean up temporary folder
      rm -rf "$backup_dest"
    fi
  )

  echo ""
  echo "Backup complete: $zip_file"
fi
