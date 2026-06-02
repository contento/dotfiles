# TODO

## Pending

- [ ] Add smug for declarative tmux session management

## All items tackled ✅

- [x] Fix pfetch → pfetch-rs in bashrc, zshrc
- [x] Fix h='htop' → h='btop' in bashrc
- [x] Add brew shellenv to bashrc
- [x] Add missing tool inits to bashrc (atuin, zoxide, direnv)
- [x] Fix empty setup_additional_tools_mac in zshrc
- [x] Fix hardcoded CUDA version in zshrc (auto-detect via `/usr/local/cuda` symlink, fall back to version scan)
- [x] Fix hardcoded Open Watcom path in zshrc (added `$WATCOM_DIR` env var guard)
- [x] Fix brew path hardcoding → `brew shellenv` in zshrc
- [x] Add git-delta binary name comment to bootstrap.sh
- [x] OSC7 portability fix (use `$(hostname)` instead of `$HOSTNAME`/`$HOST`)
- [x] Add nvm loading to bashrc
- [x] Add `.githooks/pre-commit` + configured `core.hooksPath` in gitconfig
- [x] Remove brew/ stow package + README section
- [x] CI workflow for shellcheck (`.github/workflows/shellcheck.yml`)
- [x] Remove "editorconfig duplication" item (both serve different purposes — keep both)
- [x] Update LICENSE year to 2026
- [x] Add Makefile with common targets
- [x] Adjust .editorconfig max_line_length for .sh from 80 → 100
- [x] Remove Brewfile idea (user declined)
- [x] Add `sync-shell-configs.sh` drift detector
- [x] Update CLAUDE.md and .github/copilot-instructions.md TODO references to point to the pre-commit hook
- [x] Update README structure diagram and Homebrew section
