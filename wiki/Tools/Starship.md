# Starship

Prompt: [starship.rs](https://starship.rs/)  
Config: `starship/.config/starship.toml` → `~/.config/starship.toml`

---

## What it shows

The prompt is compact — two lines, using the default starship format:

1. **Line 1** — `user@host` + directory (last 3 path components) + git branch / status + active language runtime + command duration (when > 4s).
2. **Line 2** — `➜` on success, `✗` on error.

The directory module shows at most the last 3 path components (`truncation_length = 3`) and prepends `…/` only when truncation actually happened (`truncation_symbol = "…/"`). Shallow paths under `$HOME` keep the leading `~`; deep paths render as `…/parent/child/cwd`.

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
