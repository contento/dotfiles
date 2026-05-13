# Neovim

Distribution: [LazyVim](https://www.lazyvim.org/)  
Config: `nvim/.config/nvim/` → `~/.config/nvim/`

---

## Entry point

`init.lua` — bootstraps lazy.nvim, then loads `lua/config/lazy.lua`.

---

## LazyVim extras enabled

### AI
- `lazyvim.plugins.extras.ai.copilot` — GitHub Copilot
- `lazyvim.plugins.extras.ai.copilot-chat` — Copilot chat panel

### Editor
- `lazyvim.plugins.extras.editor.aerial` — symbol outline
- `lazyvim.plugins.extras.editor.harpoon2` — fast file navigation
- `lazyvim.plugins.extras.editor.navic` — breadcrumbs in statusline
- `lazyvim.plugins.extras.editor.telescope` — fuzzy finder

### Language support
- Docker, Go, JSON, Markdown, Python, Rust, TypeScript, YAML
- `lazyvim.plugins.extras.formatting.prettier` — Prettier formatter
- `lazyvim.plugins.extras.linting.eslint` — ESLint

### UI
- `lazyvim.plugins.extras.ui.treesitter-context` — sticky context header
- `lazyvim.plugins.extras.dap.core` — debug adapter protocol

---

## Custom plugins (`lua/plugins/`)

| File | Plugin(s) |
|---|---|
| `alpha.lua` | alpha-nvim (dashboard) |
| `auto-session.lua` | auto-session (session persistence) |
| `comment.lua` | comment.nvim |
| `cyberdream.lua` | cyberdream theme |
| `fidget.lua` | fidget (LSP progress) |
| `lualine.lua` | lualine statusline |
| `luasnip.lua` | LuaSnip snippets |
| `mason.lua` | mason (LSP installer) |
| `noice.lua` | noice (UI replacement for messages/cmdline) |
| `nvim-lspconfig.lua` | LSP configuration |
| `nvim-tmux-navigation.lua` | seamless nvim↔tmux pane navigation |
| `nvim-treesitter.lua` | treesitter + textobjects |
| `package-info.lua` | npm package versions inline |
| `rose-pine.lua` | rose-pine theme (default) |
| `snacks.lua` | snacks.nvim utilities |
| `todo-comments.lua` | TODO/FIXME highlighting |
| `which-key.lua` | which-key keybinding hints |

---

## Custom keymaps (`lua/config/keymaps.lua`)

| Key | Action |
|---|---|
| `Ctrl+/` | Toggle terminal |
| `<leader>gg` | Open lazygit |
| `Ctrl+d` | Scroll down (centred) |
| `Ctrl+u` | Scroll up (centred) |
| `ss` | Split vertical |
| `sv` | Split horizontal |
| `te` | New tab |
| `Tab` | Next tab |
| `Shift+Tab` | Previous tab |

---

## Options (`lua/config/options.lua`)

- `conceallevel = 2` — conceal markdown syntax
- `cmdheight = 1`
- Python 3 path set explicitly for pynvim

---

## Themes

- **rose-pine** (default)
- **cyberdream** (alternative, uncomment in config)
