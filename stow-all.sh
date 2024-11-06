#!/bin/zsh

#   o  o
# \______/
#   |
#      |    https://conten.to
# --------

verbose_level=1

# Initialize flags
dry_run=false
verbose=false

# Parse arguments
for arg in "$@"; do
  case $arg in
    --dry-run)
      dry_run=true
      ;;
    --verbose)
      verbose=true
      ;;
  esac
done

exclude_dirs=(
    'logs'
    'backup'
    'temp'
)
if $verbose; then
fi

# Build the exclusion pattern
exclude_pattern=$(printf "|%s" "${exclude_dirs[@]}")
exclude_pattern=${exclude_pattern:1} # Remove the leading '|'

if $verbose; then
    echo "---- exclude pattern:\n$exclude_pattern\n"
fi

packages=$(ls -d */ | grep -Ev "^(${exclude_pattern})/$" | sed 's:/*$::' | tr '\n' ' ')
if $verbose; then
    echo "---- packages:\n$packages\n"
fi

verbose_args=""
if $verbose; then
    verbose_args="--verbose=$verbose_level"
fi

simulate_args=""
if $dry_run;  then
    simulate_args="--simulate"
fi

cmd="stow $verbose_args $simulate_args -R $packages"
if $verbose; then
    echo "---- command:\n$cmd\n"
fi
echo "****"
eval $cmd


# ---- Typical Command:
# stow --verbose=0 --simulate -R bash editorconfig fastfetch git kitty mc nvim starship tmux vim yazi zsh

