# Git

Config: `git/.gitconfig` → `~/.gitconfig`

---

## Identity

```
user.name  = Gonzalo Contento
user.email = 3741250+contento@users.noreply.github.com  (GitHub noreply)
```

---

## Core settings

| Setting | Value |
|---|---|
| `core.editor` | `vim` |
| `core.autocrlf` | `input` (LF on checkout, unchanged on commit) |
| `credential.helper` | `gh auth git-credential` (GitHub CLI) |
| `merge.tool` | `vimdiff` |
| `diff.tool` | `vimdiff` |

---

## Aliases

| Alias | Expands to |
|---|---|
| `git st` | `status` |
| `git co` | `checkout` |
| `git br` | `branch` |
| `git cm` | `commit` |
| `git last` | `log -1 HEAD` |
| `git lg` | One-line graph log with colours |
| `git lga` | Same as `lg` but all branches |

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
