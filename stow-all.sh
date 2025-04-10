#!/usr/bin/env bash

# Generic Stow Script
# https://conten.to

verbose_level=1
dry_run=false
verbose=false
exclude_dirs=()
stow_options=""

# Function to display help
function show_help() {
  echo "Usage: $0 [options]"
  echo ""
  echo "Options:"
  echo "  --dry-run           Simulate the stow command without making changes"
  echo "  --verbose           Enable verbose output"
  echo "  --verbose-level=N   Set the verbose level (default: 1)"
  echo "  --exclude=DIRS      Comma-separated list of directories to exclude"
  echo "  --stow-options=OPTS Additional options to pass to the stow command"
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
    --verbose-level=*)
      verbose_level="${arg#*=}"
      ;;
    --exclude=*)
      IFS=',' read -r -a exclude_dirs <<< "${arg#*=}"
      ;;
    --stow-options=*)
      stow_options="${arg#*=}"
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
packages=$(ls -d */ | grep -Ev "^(${exclude_pattern})/$" | sed 's:/*$::' | tr '\n' ' ')
if [[ -z "$packages" ]]; then
  echo "Error: No packages found to stow."
  exit 1
fi

if $verbose; then
  echo "---- Packages: $packages"
fi

# Build stow command
verbose_args=""
if $verbose; then
  verbose_args="--verbose=$verbose_level"
fi

simulate_args=""
if $dry_run; then
  simulate_args="--simulate"
fi

cmd="stow $verbose_args $simulate_args $stow_options -R $packages"

if $verbose; then
  echo "---- Command: $cmd"
fi

# Execute the command
echo "**** Executing stow command ****"
eval $cmd
