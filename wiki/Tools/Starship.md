# Starship

Prompt: [starship.rs](https://starship.rs/)  
Config: `starship/.config/starship.toml` → `~/.config/starship.toml`

---

## What it shows

The prompt spans three lines:

1. **Line 1** — directory (truncated to 10 chars, repo-root aware), with `user@host` prepended when relevant.
2. **Line 2** — git branch, git status, active language runtime, command duration (when > 4s).
3. **Line 3** — `➜` on success, `✗` on error.

Splitting the directory onto its own line keeps each line readable when paths or git status get long.

---

## Installation

Installed by `bootstrap.sh` via:

```bash
curl -fsSL https://starship.rs/install.sh | sh -s -- --bin-dir /usr/local/bin --force
```

Initialised in `.zshrc`:

```zsh
if type starship >/dev/null; then
  eval "$(starship init zsh)"
fi
```

---

## Customisation

Edit `starship/.config/starship/starship.toml`. Full reference: [starship.rs/config](https://starship.rs/config/).
