# Starship

Prompt: [starship.rs](https://starship.rs/)  
Config: `starship/.config/starship.toml` → `~/.config/starship.toml`

---

## What it shows

The prompt is compact — two lines, using the default starship format:

1. **Line 1** — `user@host` + full path under `$HOME` (e.g. `/Projects/contento/dotfiles`) + git branch / status + active language runtime + command duration (when > 4s).
2. **Line 2** — `➜` on success, `✗` on error.

The directory module shows the full path under `$HOME` rather than collapsing to the repo root (`truncate_to_repo = false`) and drops the `~` prefix (`home_symbol = ""`) so a path under home reads `/Projects/...` instead of `~/Projects/...`.

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

Edit `starship/.config/starship.toml`. Full reference: [starship.rs/config](https://starship.rs/config/).
