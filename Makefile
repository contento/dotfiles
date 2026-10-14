# Dotfiles Makefile — convenience targets for common operations
# https://conten.to

SHELL := /usr/bin/env bash
.DEFAULT_GOAL := help

.PHONY: help bootstrap bootstrap-all bootstrap-dry-run stow stow-dry-run lint fix-ssh

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

lint: ## Run shellcheck on all shell scripts and check packages.txt
	@echo "Running ShellCheck..."
	@shellcheck --version 2>/dev/null || (echo "shellcheck not installed. Install it and try again." && exit 1)
	@shellcheck --severity=style --exclude=SC1091 *.sh bash/.bashrc shared/.config/shell/*.sh
	@echo "✅ All scripts pass shellcheck"
	@# Every row: 6 columns (an optional trailing # comment is ignored), tier min|full
	@awk '!/^[[:space:]]*(#|$$)/ { n = 0; for (i = 1; i <= NF && $$i !~ /^#/; i++) n++; \
		if (n != 6 || ($$2 != "min" && $$2 != "full")) { print FILENAME ":" NR ": " $$0; bad = 1 } } \
		END { exit bad }' packages.txt
	@echo "✅ packages.txt is well-formed"
