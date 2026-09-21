# Bash

Bash is maintained alongside ZSH as a fallback / secondary shell config. While ZSH is the primary daily driver with richer features (autosuggestions, syntax highlighting, advanced completion), Bash ensures compatibility everywhere: it's the default shell on most Linux distros (`/bin/sh`), the Docker container base, and minimal or headless environments where installing ZSH isn't practical. Both configs share the same aliases, prompt (Starship), and tool integrations so the experience is consistent regardless of which shell is active.

File: `bash/.bashrc` → `~/.bashrc`

---

## Startup sequence

The file first sources `~/.config/shell/shared-env.sh`, then bails out early
(inline `case $- in` check at file level — a function can't `return` from the
file) when the session is not interactive, so scp/sftp/rsync never see output.

Functions called in order:

1. `configure_history` — `HISTCONTROL=ignoreboth`, 10000 entries
2. `configure_terminal` — `checkwinsize`, `lesspipe`
3. `setup_starship` — cross-shell prompt
4. `setup_zoxide` — replaces `cd` via `zoxide init bash --cmd cd`
5. `setup_atuin` — shell history search via `atuin init bash`
6. `setup_direnv` — per-directory env vars via `direnv hook bash`
7. `setup_brew` — activates `brew shellenv` (detects prefix automatically)
8. `setup_path` — adds `/usr/local/bin`, `~/bin`, `~/.local/bin`, Rust cargo env, a
   Node.js fallback (latest version under `~/.config/nvm/versions/node` if `nvm` itself
   isn't installed), and CUDA (auto-detected via the `/usr/local/cuda` symlink)
9. `setup_typical_aliases` — ls/grep fallbacks, then sources `~/.config/shell/shared-aliases.sh` (shared with zsh)
10. `load_custom_aliases` — sources `~/.bash_aliases` if present
11. `enable_completion` — bash-completion
12. `setup_ssh_agent` — `keychain --eval` (same mechanism as zsh)
13. `source_fzf` — sources `~/.fzf.bash` if present
14. `setup_osc7` — terminal URL support (uses `$(hostname)` for portability)
15. `show_system_info` — `pfetch-rs` (primary) or `fastfetch` (fallback)
16. **nvm** — loads `$HOME/.config/nvm/nvm.sh` if present

---

After all functions, the following machine-specific guards run:

- `$HOME/.local/bin/env` — sourced only if file exists
- `$HOME/.lmstudio/bin` — added to PATH only if directory exists
- `$HOME/.opencode/bin` — added to PATH only if directory exists

---

## Prompt

```
user@host: ~/path
$
```

Colour: user+host in bright blue (`\e[38;5;39m`), path in slate (`\e[38;5;103m`).

---

## SSH agent (bash)

Bash uses `keychain` — the same mechanism as zsh — when both `keychain` and
the key file `~/.ssh/id_rsa-$USER` exist:

```bash
eval "$(keychain --eval "id_rsa-$USER")"
```

---

## Notable guards

| Check | Guard |
|---|---|
| `dircolors` | Only called if `command -v dircolors` succeeds (GNU only) |
| `starship`, `zoxide`, `atuin`, `direnv` | Guarded by `command -v` |
| `brew shellenv` | Only called if `brew` is in PATH |
| `.local/bin/env` | Only sourced if the file exists |
| LM Studio / opencode PATH | Only added if directory exists |
| Rust cargo env | Only sourced if `~/.cargo/env` exists |
| nvm | Only loaded if `~/.config/nvm` directory exists |

---

## Adding aliases

Place custom aliases in `~/.bash_aliases` — it is sourced automatically if present.
