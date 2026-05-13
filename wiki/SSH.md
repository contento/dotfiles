# SSH

---

## Key naming convention

Keys use the pattern `id_<type>-<identifier>` (e.g. `id_ed25519-github`, `id_ed25519-work`).

---

## Generate a key

```bash
ssh-keygen -t ed25519 -C "your@email.com" -f ~/.ssh/id_ed25519-github
```

---

## Fix permissions

```bash
# Preview
./fix-ssh-perms.sh --dry-run

# Apply
./fix-ssh-perms.sh
```

Or manually:

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_rsa-*
```

---

## Agent setup

### macOS / zsh — keychain

The `.zshrc` auto-starts the agent via `keychain` if the key file exists:

```zsh
# Runs automatically on shell init if keychain is installed
eval "$(keychain --eval --agents ssh "id_rsa-$USER")"
```

### Linux / bash — persistent agent

The `.bashrc` manages a persistent agent via `~/.ssh/environment`:

```bash
# Runs automatically on shell init
setup_ssh_agent
```

### Manual start

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa-github
```

---

## SSH config

File: `~/.ssh/config`

```sshconfig
Host github
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_rsa-github
    AddKeysToAgent yes

Host myserver
    HostName 192.168.1.100
    User contento
    IdentityFile ~/.ssh/id_rsa-work
    AddKeysToAgent yes
```

---

## Copy key to remote host

```bash
ssh-copy-id -i ~/.ssh/id_rsa-<ID>.pub <user>@<host>
```

---

## Tunnel VNC over SSH

```bash
ssh -L 15901:127.0.0.1:5901 -C -N <user>@<host>
# Then connect to vnc://127.0.0.1:15901
```
