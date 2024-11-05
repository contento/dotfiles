#!/bin/zsh

#   o  o
# \______/
#   |
#      |    https://conten.to
# --------

stow -D --verbose=3 */

exclude_dirs=(
    'logs'
    'backup'
    'temp'
)

# Build the exclusion pattern
exclude_pattern=$(printf "|%s" "${exclude_dirs[@]}")
exclude_pattern=${exclude_pattern:1} # Remove the leading '|'

packages=$(ls -d */ | grep -Ev "^(${exclude_pattern})/$" | sed 's:/*$::')
stow --verbose=3 $packages

