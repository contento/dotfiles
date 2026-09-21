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

## Diff viewer (delta)

Config: `delta/.config/git/delta/config` — a separate stow package from `git/`. The
tracked `.gitconfig` does **not** set `core.pager`, so delta isn't wired in
automatically; enable it per-machine via `~/.gitconfig.local` (see
[Machine-specific overrides](#machine-specific-overrides) above):

```ini
[core]
    pager = delta
[interactive]
    diffFilter = delta --color-only
```

| Setting | Value |
| --- | --- |
| `syntax-theme` | Dracula |
| `side-by-side` | `true` |
| `line-numbers` | `true`, green, boxed |
| `navigate` | `true` — jump between file diffs with `n` / `N` |
| `decorations` | bold yellow commit/file headers, bold purple hunk headers |

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
