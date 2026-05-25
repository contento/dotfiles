# TODO

## Pre-commit hook to keep AI instructions in sync

[CLAUDE.md](CLAUDE.md) and [.github/copilot-instructions.md](.github/copilot-instructions.md)
must stay byte-identical in their shared body. Replace the manual rule with a
pre-commit hook that diffs them and fails the commit if they've drifted.
