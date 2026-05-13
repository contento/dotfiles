#!/usr/bin/env bash

# Generic Stow Script
# https://conten.to

set -euo pipefail

dry_run=false
verbose=false
exclude_dirs=("logs" "wiki")

# Determine the directory of the script
dotfiles_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

show_help() {
  echo "Usage: $0 [options]"
  echo ""
  echo "Options:"
  echo "  --dry-run           Simulate the stow command without making changes"
  echo "  --verbose           Enable verbose output"
  echo "  --exclude=DIRS      Comma-separated list of dirs to exclude (replaces default: logs,wiki)"
  echo "  --help              Show this help message"
  exit 0
}

# Parse arguments
for arg in "$@"; do
  case $arg in
    --dry-run)
      dry_run=true
      ;;
    --verbose)
      verbose=true
      ;;
    --exclude=*)
      IFS=',' read -r -a exclude_dirs <<< "${arg#*=}"
      ;;
    --help)
      show_help
      ;;
    *)
      echo "Unknown option: $arg"
      show_help
      ;;
  esac
done

# Ensure stow is installed
if ! command -v stow &>/dev/null; then
  echo "Error: 'stow' is not installed. Please install it and try again."
  exit 1
fi

# Build the exclusion pattern
if [[ ${#exclude_dirs[@]} -gt 0 ]]; then
  exclude_pattern=$(printf "|%s" "${exclude_dirs[@]}")
  exclude_pattern=${exclude_pattern:1} # Remove the leading '|'
else
  exclude_pattern=""
fi

if $verbose; then
  echo "---- Exclude pattern: $exclude_pattern"
fi

# Find packages to stow
cd "$dotfiles_dir" || exit 1
packages=()
for dir in */; do
  dir="${dir%/}"
  # Skip if it matches the exclude pattern (bash built-in, no subprocess)
  if [[ -n "$exclude_pattern" && "$dir" =~ ^(${exclude_pattern})$ ]]; then
    continue
  fi
  packages+=("$dir")
done
if [[ ${#packages[@]} -eq 0 ]]; then
  echo "Error: No packages found to stow."
  exit 1
fi

if $verbose; then
  echo "---- Packages: ${packages[*]}"
fi

# Build stow base args
stow_args=()
if $dry_run; then
  stow_args+=("--simulate")
fi
if $verbose; then
  stow_args+=("-v")
fi

echo "**** Unstowing existing stow packages ****"
if $verbose; then
  echo "---- Unstow Command: stow ${stow_args[*]+"${stow_args[*]}"} -D -t $HOME ${packages[*]}"
fi
stow "${stow_args[@]+"${stow_args[@]}"}" -D -t "$HOME" "${packages[@]}"

# Build stow command
if $verbose; then
  echo "---- Dotfiles directory: $dotfiles_dir"
  echo "---- Stow Command: stow ${stow_args[*]+"${stow_args[*]}"} -R -t $HOME ${packages[*]}"
fi

# Execute the command
echo "**** Executing stow command ****"
stow "${stow_args[@]+"${stow_args[@]}"}" -R -t "$HOME" "${packages[@]}"
