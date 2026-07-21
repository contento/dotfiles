# Git

Config: `git/.gitconfig` → `~/.gitconfig`

---

## Identity

```ini
user.name  = Gonzalo Contento
user.email = 3741250+contento@users.noreply.github.com  (GitHub noreply)
```

---

## Core settings

| Setting | Value |
| --- | --- |
| `core.autocrlf` | `input` (LF on checkout, unchanged on commit) |
| `init.defaultBranch` | `main` |
| `push.autoSetupRemote` | `true` — first push creates the upstream branch |
| `fetch.prune` | `true` — remote-tracking branches deleted on the remote are pruned |
| `merge.conflictstyle` | `zdiff3` — conflict markers include the merge base |
| `rebase.autostash` | `true` — uncommitted changes are stashed around a rebase |
| `credential.helper` | `gh auth git-credential` (GitHub CLI) for github.com/gist |

---

## Machine-specific overrides

The last line of `.gitconfig` includes `~/.gitconfig.local`:

```ini
[include]
    path = ~/.gitconfig.local
```

That file is not tracked. Use it for per-machine settings (e.g. tool-managed
credential helpers). If an app rewrites the tracked `~/.gitconfig` (it is a
symlink into the repo), restore it and move the setting into `~/.gitconfig.local`.

---

## Shell aliases

See [[Shell/Aliases#Git]] for short shell-level aliases (`g`, `ga`, `gc`, `gco`, etc.).

---

## Credential helper

Authentication goes through the GitHub CLI:

```bash
gh auth login
```

After that, `git push` / `git pull` use the stored token automatically.
