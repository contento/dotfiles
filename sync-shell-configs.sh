#!/usr/bin/env bash
# Detect drift between bash and zsh shell configs
# Reports differences in aliases, tool inits, and env vars
#
# Usage: ./sync-shell-configs.sh [--diff]

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
bashrc="$script_dir/bash/.bashrc"
zshrc="$script_dir/zsh/.config/zsh/.zshrc"

echo "===== Shell Config Drift Detector ====="
echo ""
echo "Comparing:"
echo "  bash: $bashrc"
echo "  zsh:  $zshrc"
echo ""

# 1. Extract function definitions from each
echo "--- Functions in bash but not in zsh ---"
while IFS= read -r func; do
    if ! grep -q "function $func\|^$func()" "$zshrc" 2>/dev/null; then
        echo "  ⚠️  '$func' exists in bashrc but not in zshrc"
    fi
done < <(grep -oP '^function \K\w+|^[a-zA-Z_][a-zA-Z0-9_]*\(\).*' "$bashrc" | sed 's/()//')

echo ""
echo "--- Functions in zsh but not in bash ---"
while IFS= read -r func; do
    if ! grep -q "function $func\|^$func()" "$bashrc" 2>/dev/null; then
        echo "  ⚠️  '$func' exists in zshrc but not in bashrc"
    fi
done < <(grep -oP '^function \K\w+|^[a-zA-Z_][a-zA-Z0-9_]*\(\).*' "$zshrc" | sed 's/()//')

echo ""
echo "--- Tool initializations (command -v / type guards) ---"
echo "bash has:"
while IFS= read -r tool; do
    in_zsh=$(grep -c "type $tool\|command.*-v.*$tool" "$zshrc" || true)
    echo "  $tool (zsh: $([ "$in_zsh" -gt 0 ] && echo '✅' || echo '❌'))"
done < <(grep -oP '(?:command -v |type )(\w+)' "$bashrc" | sort -u | sed 's/.* //')

echo ""
echo "--- Actions ---"
echo "  To see the full diff:  ./sync-shell-configs.sh --diff"
echo "  To fix: extract shared logic into a common file sourced by both shells"

# Optional full diff
if [[ "${1:-}" == "--diff" ]]; then
    echo ""
    echo "===== Raw diff (bashrc → zshrc) ====="
    diff -u \
        <(grep -v '^\s*#' "$bashrc" | grep -v '^\s*$') \
        <(grep -v '^\s*#' "$zshrc" | grep -v '^\s*$') \
        || true
fi
