return { -- modicator (auto color line number based on vim mode)
{
    "mawkler/modicator.nvim",
    enabled = true,
    dependencies = "scottmckendry/cyberdream.nvim",
    init = function()
      -- These are required for Modicator to work
      vim.o.cursorline = true
      vim.o.number = true
      vim.o.termguicolors = true
    end,
    opts = {
    }
}}
