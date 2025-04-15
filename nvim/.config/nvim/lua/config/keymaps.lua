-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keymap = vim.keymap
local opts = { noremap = true, silent = true }
local Util = require("lazyvim.util")

vim.keymap.set("n", "<C-/>", function()
  local is_windows = package.config:sub(1, 1) == "\\"
  local terminal_cmd = is_windows and "powershell.exe" or nil
  Util.terminal(terminal_cmd, { border = "none", opacity = 0.9 })
end, { desc = "Toggle terminal with no border and 90% opacity" })

-- Lazygit (root dir)
vim.keymap.set("n", "<leader>gg", function()
  Util.terminal({ "lazygit" }, { cwd = Util.root(), esc_esc = false, ctrl_hjkl = false, border = "none" })
end, { desc = "Lazygit (root dir)" })

keymap.del({ "n", "i", "v" }, "<A-j>")
keymap.del({ "n", "i", "v" }, "<A-k>")
keymap.del("n", "<C-Left>")
keymap.del("n", "<C-Down>")
keymap.del("n", "<C-Up>")
keymap.del("n", "<C-Right>")

-- Vim navigation
keymap.set("n", "<C-d>", "<C-d>zz", { silent = true })
keymap.set("n", "<C-u>", "<C-u>zz", { silent = true })

-- Split windows
keymap.set("n", "ss", ":vsplit<Return>", opts)
keymap.set("n", "sv", ":split<Return>", opts)

-- Tabs
keymap.set("n", "te", ":tabedit", opts)
keymap.set("n", "<tab>", ":tabnext<Return>", opts)
keymap.set("n", "<s-tab>", ":tabprev<Return>", opts)
