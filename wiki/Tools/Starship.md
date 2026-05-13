# Starship

Prompt: [starship.rs](https://starship.rs/)  
Config: `starship/.config/starship/starship.toml` → `~/.config/starship/starship.toml`

---

## What it shows

From left to right:

| Segment | Content |
|---|---|
| OS icon | Current operating system |
| User | `user@host` (shown when relevant) |
| Directory | Truncated to 10 chars, repo-root aware |
| Git branch | Current branch name |
| Git status | Staged / unstaged / ahead / behind indicators |
| Language | Active runtime (Go, Node, Python, Rust, …) |
| Duration | Command duration when > 4 seconds |
| Status | `➜` on success, `✗` on error |

---

## Installation

Installed by `install-base.sh` via:

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
