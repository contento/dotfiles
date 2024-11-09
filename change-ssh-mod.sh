#!/bin/zsh

#   o  o
# \______/
#   |
#      |    https://conten.to
# --------

# Define the SSH directory
SSH_DIR="$HOME/.ssh"

echo "Updating permissions for the SSH directory..."

# Change permissions for the SSH directory
chmod 700 "$SSH_DIR"

echo "Changing permissions for SSH keys and their symlinks..."

# Change permissions for regular files and symlinks
find "$SSH_DIR" -maxdepth 1 -name "id_rsa*" -exec chmod 600 {} \;

echo "Current permissions for SSH directory and keys:"

# Display the permissions for the SSH directory
echo "$SSH_DIR:"
ls -ld "$SSH_DIR"

echo "SSH keys in the directory:"
# Determine the operating system and use the appropriate stat command
OS="$(uname)"
if [ "$OS" = "Darwin" ]; then
    # macOS uses a different syntax for stat
    stat -f "%A %N" "$SSH_DIR"/id_rsa*
else
    # Assume Linux
    stat -c "%a %n" "$SSH_DIR"/id_rsa*
fi
