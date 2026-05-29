# Bash

Bash is maintained alongside ZSH as a fallback / secondary shell config. While ZSH is the primary daily driver with richer features (autosuggestions, syntax highlighting, advanced completion), Bash ensures compatibility everywhere: it's the default shell on most Linux distros (`/bin/sh`), the Docker container base, and minimal or headless environments where installing ZSH isn't practical. Both configs share the same aliases, prompt (Starship), and tool integrations so the experience is consistent regardless of which shell is active.

File: `bash/.bashrc` → `~/.bashrc`

---

## Startup sequence

Functions called in order:

1. `check_interactive` — exits early if not an interactive session
2. `configure_history` — `HISTCONTROL=ignoreboth`, 1000 entries
3. `configure_terminal` — `checkwinsize`, `lesspipe`
4. `setup_starship` — cross-shell prompt
5. `setup_zoxide` — smarter `cd` via `zoxide init bash`
6. `setup_atuin` — shell history search via `atuin init bash`
7. `setup_direnv` — per-directory env vars via `direnv hook bash`
8. `setup_brew` — activates `brew shellenv` (detects prefix automatically)
9. `setup_path` — adds `/usr/local/bin`, `~/bin`, Rust cargo env
10. `setup_typical_aliases` — ls, grep, yazi, nvim, code
11. `load_custom_aliases` — sources `~/.bash_aliases` if present
12. `enable_completion` — bash-completion
13. `setup_ssh_agent` — persistent agent via `~/.ssh/environment`
14. `source_fzf` — sources `~/.fzf.bash` if present
15. `setup_osc7` — terminal URL support (uses `$(hostname)` for portability)
16. `show_system_info` — `pfetch-rs` or `fastfetch`
17. **nvm** — loads `$HOME/.config/nvm/nvm.sh` if present

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

Bash manages a persistent agent through `~/.ssh/environment`:

- If the file exists and the agent PID is alive → re-uses the running agent
- Otherwise → starts a new agent and writes PID/socket to the file

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
