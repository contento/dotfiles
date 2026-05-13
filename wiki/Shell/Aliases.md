# Aliases

All aliases are defined in `.zshrc` and guarded behind `type <tool>` checks — they are only set when the tool is installed.

---

## Git

| Alias | Command |
|---|---|
| `g` | `git` |
| `ga` | `git add` |
| `gc` | `git commit` |
| `gca` | `git commit --amend` |
| `gco` | `git checkout` |
| `gd` | `git diff` |
| `gl` | `git log` |
| `gp` | `git pull` |
| `gpu` | `git push` |
| `gst` | `git status` |

Also see [[Tools/Git]] for git config aliases (`lg`, `lga`, `last`, etc.).

---

## Kubernetes

| Alias | Command |
|---|---|
| `k` | `kubectl` |
| `kgp` | `kubectl get pods` |
| `kgs` | `kubectl get svc` |
| `kgn` | `kubectl get nodes` |
| `kga` | `kubectl get all` |
| `kdp` | `kubectl describe pod` |
| `kds` | `kubectl describe svc` |
| `kdel` | `kubectl delete` |
| `kaf` | `kubectl apply -f` |
| `kctx` | `kubectl config use-context` |
| `kns` | `kubectl config set-context --current --namespace` |
| `kl` | `kubectl logs` |
| `kexec` | `kubectl exec -it` |

---

## Podman

| Alias | Command |
|---|---|
| `p` | `podman` |
| `plogs` | `podman logs` |
| `pps` | `podman ps` |
| `ppa` | `podman ps -a` |
| `pi` | `podman images` |
| `prun` | `podman run` |
| `pexec` | `podman exec -it` |
| `pstop` | `podman stop` |
| `prm` | `podman rm` |
| `primi` | `podman rmi` |
| `pbld` | `podman build` |
| `ppull` | `podman pull` |
| `ppush` | `podman push` |
| `pinspect` | `podman inspect` |

---

## Tmux

| Alias | Command |
|---|---|
| `t` | `tmux` |
| `tm` | `tmux new-session -s` |
| `tl` | `tmux list-sessions` |
| `tk` | `tmux kill-session -t` |
| `tks` | `tmux kill-server` |
| `ta` | `tmux attach -t` |

---

## File listing (eza)

| Alias | Command |
|---|---|
| `ls` | `eza --color=always --git --icons=always` |
| `l` | `ls -lA` |
| `ll` | `ls -l` |
| `lt` | `ls --tree` |

---

## Tools

| Alias | Command | Guard |
|---|---|---|
| `cat` | `bat --style=plain --pager=never` | `bat` or `batcat` installed |
| `catp` | `bat` (with pager) | same |
| `cd` | `z` (zoxide) | `zoxide` installed |
| `y` | `yazi` | `yazi` installed |
| `v` | `nvim` | always set |
| `c` | `code` | always set |
| `python` | `python3` | `python3` installed |
| `pip` | `pip3` | `pip3` installed |

---

## Utility

| Alias | Command |
|---|---|
| `df` | `df -h` (human-readable) |
| `free` | `free -m` (MB) |
| `grep` | `grep --color=auto` |
