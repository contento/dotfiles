# Graph Report - .  (2026-05-30)

## Corpus Check
- 4 files · ~15,389 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 303 nodes · 504 edges · 48 communities (33 shown, 15 thin omitted)
- Extraction: 88% EXTRACTED · 12% INFERRED · 0% AMBIGUOUS · INFERRED: 61 edges (avg confidence: 0.82)
- Token cost: 18,755 input · 3,309 output

## Community Hubs (Navigation)
- [[_COMMUNITY_Neovim Plugin Version Pins|Neovim Plugin Version Pins]]
- [[_COMMUNITY_Cross-Platform Package Managers|Cross-Platform Package Managers]]
- [[_COMMUNITY_AI-Assistant Instructions & Repo Rules|AI-Assistant Instructions & Repo Rules]]
- [[_COMMUNITY_Bootstrap App-List Arrays|Bootstrap App-List Arrays]]
- [[_COMMUNITY_Neovim Keymaps & Init|Neovim Keymaps & Init]]
- [[_COMMUNITY_Bootstrap Install Functions|Bootstrap Install Functions]]
- [[_COMMUNITY_Tmux & Neovim Session Tooling|Tmux & Neovim Session Tooling]]
- [[_COMMUNITY_Obsidian App Settings|Obsidian App Settings]]
- [[_COMMUNITY_Guarded Shell Env & PATH Setup|Guarded Shell Env & PATH Setup]]
- [[_COMMUNITY_LSP, Mason & Colorscheme Plugins|LSP, Mason & Colorscheme Plugins]]
- [[_COMMUNITY_Graphify Workflow & Hook|Graphify Workflow & Hook]]
- [[_COMMUNITY_Claude Code Hooks Settings|Claude Code Hooks Settings]]
- [[_COMMUNITY_Noice UI Plugin Stack|Noice UI Plugin Stack]]
- [[_COMMUNITY_Stow Orchestration Script|Stow Orchestration Script]]
- [[_COMMUNITY_VS Code Launch Config|VS Code Launch Config]]
- [[_COMMUNITY_Editor Settings (VS Code  Zed)|Editor Settings (VS Code / Zed)]]
- [[_COMMUNITY_VS Code Settings|VS Code Settings]]
- [[_COMMUNITY_Obsidian Appearance|Obsidian Appearance]]
- [[_COMMUNITY_Dry-run via run_cmd helper|Dry-run via run_cmd helper]]
- [[_COMMUNITY_Obsidian app.json|Obsidian app.json]]
- [[_COMMUNITY_sync-shell-configs.sh|sync-shell-configs.sh]]
- [[_COMMUNITY_Custom autocmds (empty)|Custom autocmds (empty)]]
- [[_COMMUNITY_nvim-tmux-navigation plugin spec|nvim-tmux-navigation plugin spec]]
- [[_COMMUNITY_todo-comments.nvim plugin spec|todo-comments.nvim plugin spec]]
- [[_COMMUNITY_nvim-web-devicons plugin spec|nvim-web-devicons plugin spec]]
- [[_COMMUNITY_LuaSnip plugin spec|LuaSnip plugin spec]]
- [[_COMMUNITY_snacks.nvim plugin spec|snacks.nvim plugin spec]]
- [[_COMMUNITY_Keep README and wiki up to date|Keep README and wiki up to date]]

## God Nodes (most connected - your core abstractions)
1. `branch` - 68 edges
2. `commit` - 68 edges
3. `dotfiles Wiki Home` - 17 edges
4. `lazy.nvim bootstrap and plugin spec` - 13 edges
5. `log()` - 12 edges
6. `ZSH` - 11 edges
7. `bootstrap.sh script` - 9 edges
8. `run_cmd()` - 9 edges
9. `bootstrap.sh installer` - 9 edges
10. `bootstrap.sh` - 9 edges

## Surprising Connections (you probably didn't know these)
- `ShellCheck CI workflow` --references--> `bootstrap.sh installer`  [INFERRED]
  .github/workflows/shellcheck.yml → bootstrap.sh
- `GNU Stow package layout` --semantically_similar_to--> `GNU Stow package layout (copilot)`  [INFERRED] [semantically similar]
  CLAUDE.md → .github/copilot-instructions.md
- `sync-shell-configs.sh drift detector` --implements--> `bash/zsh shell compatibility`  [INFERRED]
  sync-shell-configs.sh → CLAUDE.md
- `stow-all.sh package stower` --implements--> `GNU Stow package layout`  [INFERRED]
  stow-all.sh → CLAUDE.md
- `stow-all.sh package stower` --implements--> `Dry-run via run_cmd pattern`  [INFERRED]
  stow-all.sh → CLAUDE.md

## Hyperedges (group relationships)
- **Mirrored AI-assistant instruction files enforced by pre-commit hook** — claude_instruction_sync_rule, github_copilot_instructions_instruction_sync_rule, claude_pre_commit_hook [EXTRACTED 1.00]
- **Guarded env var rule realized in .zshenv selections** — claude_guarded_env_vars, zsh_zshenv_editor_selection, zsh_zshenv_pager_selection, zsh_zshenv_localbin_path [INFERRED 0.85]

## Communities (48 total, 15 thin omitted)

### Community 0 - "Neovim Plugin Version Pins"
Cohesion: 0.08
Nodes (68): aerial.nvim, alpha-nvim, blink.cmp, blink-copilot, bufferline.nvim, catppuccin, Comment.nvim, conform.nvim (+60 more)

### Community 1 - "Cross-Platform Package Managers"
Cohesion: 0.06
Nodes (54): Arch Linux, pacman, yay (AUR helper), macOS, Homebrew Prefix Detection, Brew Casks (Fonts/GUI), Homebrew, Ubuntu / Debian (+46 more)

### Community 2 - "AI-Assistant Instructions & Repo Rules"
Cohesion: 0.09
Nodes (27): CLAUDE.md instructions, Pre-commit hook enforcing instruction sync, GNU Stow package layout, Dry-run via run_cmd pattern, Guarded env vars and PATH additions, CLAUDE.md / copilot-instructions sync rule, bash/zsh shell compatibility, Copilot instructions (+19 more)

### Community 3 - "Bootstrap App-List Arrays"
Cohesion: 0.15
Nodes (22): bootstrap.sh installer, bootstrap brew_mac_apps array, bootstrap common_apps array, bootstrap install_brew, bootstrap install_linux_app, bootstrap install_mac_apps, bootstrap install_tmux_plugin_manager, bootstrap install_with_brew_cask (+14 more)

### Community 4 - "Neovim Keymaps & Init"
Cohesion: 0.12
Nodes (21): Custom keymaps, Lazygit root keymap (leader gg), LazyVim Util helper module, Toggle terminal keymap (C-/), LazyVim plugin distribution import, rose-pine install colorscheme, lazy.nvim bootstrap and plugin spec, python3_host_prog homebrew path (+13 more)

### Community 5 - "Bootstrap Install Functions"
Cohesion: 0.36
Nodes (16): install_brew(), install_linux_app(), install_mac_apps(), install_tmux_plugin_manager(), install_with_apt(), install_with_brew_cask(), install_with_brew_formula(), install_with_yay() (+8 more)

### Community 6 - "Tmux & Neovim Session Tooling"
Cohesion: 0.21
Nodes (12): Neovim, auto-session, lazy.nvim, LazyVim, nvim-tmux-navigation, Tmux, tmux-continuum, tmux-resurrect (+4 more)

### Community 7 - "Obsidian App Settings"
Cohesion: 0.25
Nodes (7): defaultViewMode, legacyEditor, livePreview, newFileLocation, newLinkFormat, showUnsupportedFiles, useMarkdownLinks

### Community 8 - "Guarded Shell Env & PATH Setup"
Cohesion: 0.29
Nodes (7): Guard env vars depending on file/command, Machine-specific files handled with guards, Guarded EDITOR/VISUAL selection (nvim/vim/vi), _fzf_comprun preview dispatcher, FZF + fd integration (guarded), Guarded ~/.local/bin PATH addition, Guarded PAGER selection (most/less)

### Community 9 - "LSP, Mason & Colorscheme Plugins"
Cohesion: 0.50
Nodes (5): cyberdream.nvim colorscheme spec, LazyVim distro spec, mason.nvim plugin spec, LSP hover handler override, nvim-lspconfig plugin spec

### Community 10 - "Graphify Workflow & Hook"
Cohesion: 0.50
Nodes (4): graphify query/path/explain/update workflow, grep/find/rg command detection in hook, PreToolUse Bash graphify hint hook, graphify workflow (copilot)

### Community 12 - "Noice UI Plugin Stack"
Cohesion: 0.67
Nodes (3): fidget.nvim plugin spec, nui.nvim plugin spec, package-info.nvim plugin spec

### Community 15 - "Editor Settings (VS Code / Zed)"
Cohesion: 0.67
Nodes (3): VS Code launch (bashdb), VS Code settings, Zed editor settings

## Knowledge Gaps
- **74 isolated node(s):** `sync-shell-configs.sh script`, `defaultViewMode`, `newFileLocation`, `newLinkFormat`, `useMarkdownLinks` (+69 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **15 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `dotfiles Wiki Home` connect `Cross-Platform Package Managers` to `Tmux & Neovim Session Tooling`?**
  _High betweenness centrality (0.099) - this node is a cross-community bridge._
- **Why does `nvim-tmux-navigation` connect `Tmux & Neovim Session Tooling` to `Neovim Plugin Version Pins`?**
  _High betweenness centrality (0.069) - this node is a cross-community bridge._
- **Why does `Neovim` connect `Tmux & Neovim Session Tooling` to `Cross-Platform Package Managers`?**
  _High betweenness centrality (0.055) - this node is a cross-community bridge._
- **Are the 10 inferred relationships involving `lazy.nvim bootstrap and plugin spec` (e.g. with `alpha-nvim startify dashboard` and `auto-session session restore config`) actually correct?**
  _`lazy.nvim bootstrap and plugin spec` has 10 INFERRED edges - model-reasoned connections that need verification._
- **What connects `sync-shell-configs.sh script`, `defaultViewMode`, `newFileLocation` to the rest of the system?**
  _77 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Neovim Plugin Version Pins` be split into smaller, more focused modules?**
  _Cohesion score 0.08439897698209718 - nodes in this community are weakly interconnected._
- **Should `Cross-Platform Package Managers` be split into smaller, more focused modules?**
  _Cohesion score 0.06289308176100629 - nodes in this community are weakly interconnected._