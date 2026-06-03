#!/usr/bin/env bash
set -euo pipefail

# Backup script for machine-specific, non-stowed configs
# Creates a timestamped snapshot of local configs in $BACKUP_FOLDER
# Usage: ./backup-local.sh [--dry-run] [--format zip|7z]

dry_run=false
format="zip"  # default format

# Parse flags
while [[ $# -gt 0 ]]; do
  case "$1" in
  --dry-run)
    dry_run=true
    shift
    ;;
  --format)
    format="$2"
    shift 2
    ;;
  --help | -h)
    cat <<EOF
Usage: $0 [OPTIONS]

Creates a timestamped archive of machine-specific, non-stowed configs.

OPTIONS:
  --format FORMAT    Compression format: zip (default) or 7z
  --dry-run          Show what would be backed up without creating files
  --help, -h         Show this help message

BACKUP LOCATION:
  \$BACKUP_FOLDER (default: ~/.local/share/dotfiles/backups/)

BACKUP FORMATS:
  zip (default)  - Universal compatibility, unzip built-in on all systems
  7z             - Better compression, requires p7zip to be installed

BACKED UP FILES:
  - ~/.config/smug/*.yml (machine-specific session configs, excludes projects.yml)
  - ~/.config/zsh/.zsh_history (zsh command history)
  - ~/.ssh/ (SSH config and keys)

EXAMPLES:
  # Create a backup using default zip format
  $0

  # Create a backup using 7z compression
  $0 --format 7z

  # Preview what will be backed up
  $0 --dry-run

  # Check backup location
  echo \$BACKUP_FOLDER

  # List backups
  ls -lh \$BACKUP_FOLDER/*
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

# Validate format
if [[ "$format" != "zip" ]] && [[ "$format" != "7z" ]]; then
  echo "Error: invalid format '$format'. Must be 'zip' or '7z'"
  exit 1
fi

# Check if 7z is available when using 7z format
if [[ "$format" == "7z" ]] && ! command -v 7z &>/dev/null; then
  echo "Error: 7z format requested but 7z is not installed"
  echo "Install with: brew install p7zip (or apt install p7zip-full on Debian)"
  exit 1
fi

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

# Create timestamped backup folder and archive file
timestamp="$(date +%Y%m%d_%H%M)"
backup_dest="$BACKUP_FOLDER/$timestamp"
archive_ext="$format"
archive_file="$BACKUP_FOLDER/${timestamp}.${archive_ext}"

echo "Backing up local configs to: $archive_file (format: $format)"

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
  # Create archive from within the backup folder
  (
    cd "$BACKUP_FOLDER"
    if [[ "$format" == "zip" ]]; then
      if ! zip -r -q "$archive_file" "$timestamp"; then
        echo "Error: failed to create zip archive"
        exit 1
      fi
    elif [[ "$format" == "7z" ]]; then
      if ! 7z a -q "$archive_file" "$timestamp" >/dev/null 2>&1; then
        echo "Error: failed to create 7z archive"
        exit 1
      fi
    fi
    # Clean up temporary folder
    rm -rf "$backup_dest"
  )

  echo ""
  echo "Backup complete: $archive_file"
fi
