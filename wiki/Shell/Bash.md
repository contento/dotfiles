# Bash

Fallback / secondary shell. Used on machines where zsh is not the default.

File: `bash/.bashrc` → `~/.bashrc`

---

## Startup sequence

Functions called in order:

1. `check_interactive` — exits early if not an interactive session
2. `configure_history` — `HISTCONTROL=ignoreboth`, 1000 entries
3. `configure_terminal` — `checkwinsize`, `lesspipe`
4. `setup_prompt` — colour-aware PS1 (blue user@host, grey path)
5. `setup_path` — adds `/usr/local/bin`, `~/bin`, Rust cargo env
6. `setup_typical_aliases` — ls, grep, yazi, nvim, code
7. `load_custom_aliases` — sources `~/.bash_aliases` if present
8. `enable_completion` — bash-completion
9. `setup_ssh_agent` — persistent agent via `~/.ssh/environment`
10. `source_fzf` — sources `~/.fzf.bash` if present
11. `show_system_info` — pfetch or fastfetch

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

| Line | Guard |
|---|---|
| `dircolors` | Only called if `command -v dircolors` succeeds (GNU only) |
| `.local/bin/env` | Only sourced if the file exists |
| LM Studio PATH | Only added if `~/.lmstudio/bin` exists |
| Rust cargo env | Only sourced if `~/.cargo/env` exists |

---

## Adding aliases

Place custom aliases in `~/.bash_aliases` — it is sourced automatically if present.
