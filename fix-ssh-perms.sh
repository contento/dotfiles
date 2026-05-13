#!/usr/bin/env bash

#   o  o
# \______/
#   |
#      |    https://conten.to
# --------

set -euo pipefail

dry_run=false

for arg in "$@"; do
    case $arg in
    --dry-run)
        dry_run=true
        ;;
    --help)
        echo "Usage: $0 [--dry-run]"
        echo ""
        echo "Options:"
        echo "  --dry-run   Show what would be changed without applying it"
        echo "  --help      Show this help message"
        exit 0
        ;;
    *)
        echo "Unknown option: $arg" && exit 1
        ;;
    esac
done

if [[ "$dry_run" == true ]]; then
    echo "**** DRY RUN — no changes will be made ****"
fi

run_cmd() {
    if [[ "$dry_run" == true ]]; then
        echo "[dry-run] $*"
    else
        "$@"
    fi
}

# Define the SSH directory
SSH_DIR="$HOME/.ssh"

echo "Updating permissions for the SSH directory..."
run_cmd chmod 700 "$SSH_DIR"

echo "Changing permissions for SSH private keys..."
if [[ "$dry_run" == true ]]; then
    echo "[dry-run] find $SSH_DIR -maxdepth 1 -type f ! -name '*.pub' ! -name 'known_hosts*' ! -name 'config' ! -name 'authorized_keys' ! -name 'environment' -exec chmod 600 {} \\;"
else
    find "$SSH_DIR" -maxdepth 1 -type f \
        ! -name "*.pub" \
        ! -name "known_hosts*" \
        ! -name "config" \
        ! -name "authorized_keys" \
        ! -name "environment" \
        -exec chmod 600 {} \;
fi

echo "Current permissions for SSH directory and keys:"
echo "$SSH_DIR:"
ls -ld "$SSH_DIR"

echo "SSH keys in the directory:"
OS="$(uname)"
if [[ "$OS" == "Darwin" ]]; then
    stat -f "%A %N" "$SSH_DIR"/id_* 2>/dev/null || echo "(no private keys found)"
else
    stat -c "%a %n" "$SSH_DIR"/id_* 2>/dev/null || echo "(no private keys found)"
fi
