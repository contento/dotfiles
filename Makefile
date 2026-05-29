# Dotfiles Makefile — convenience targets for common operations
# https://conten.to

SHELL := /usr/bin/env bash
.DEFAULT_GOAL := help

.PHONY: help bootstrap stow dry-run lint check-sync fix-ssh

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*##' $(MAKEFILE_LIST) | sort | \
		awk 'BEGIN {FS = ":.*## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

bootstrap: ## Install packages (minimum set)
	./bootstrap.sh

bootstrap-all: ## Install packages (full set)
	./bootstrap.sh --all

bootstrap-dry-run: ## Preview package installation
	./bootstrap.sh --dry-run

stow: ## Symlink all configs via stow
	./stow-all.sh

stow-dry-run: ## Preview stow symlinks
	./stow-all.sh --dry-run

fix-ssh: ## Fix SSH directory permissions
	./fix-ssh-perms.sh

lint: ## Run shellcheck on all shell scripts
	@echo "Running ShellCheck..."
	@shellcheck --version 2>/dev/null || (echo "shellcheck not installed. Install it and try again." && exit 1)
	@shellcheck --severity=style *.sh
	@echo "✅ All scripts pass shellcheck"

check-sync: ## Verify CLAUDE.md and copilot-instructions.md are in sync
	@echo "Checking CLAUDE.md ↔ .github/copilot-instructions.md sync..."
	@diff CLAUDE.md .github/copilot-instructions.md && \
		echo "✅ Files are in sync" || \
		(echo "❌ Files have diverged!"; exit 1)

install-hooks: ## Install git hooks from .githooks/
	git config core.hooksPath .githooks
	@echo "✅ Git hooks installed from .githooks/"
