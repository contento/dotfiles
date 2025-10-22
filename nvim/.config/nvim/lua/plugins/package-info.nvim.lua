return {
  {
    "vuki656/package-info.nvim",
    ft = "json",
    dependencies = { "MunifTanjim/nui.nvim" },
    config = function()
      require("package-info").setup({
        autostart = false,
        package_manager = "npm",

        highlights = {
          up_to_date = { fg = "#3C4048" },
          outdated = { fg = "#d19a66" },
          invalid = { fg = "#ee4b2b" },
        },
        hide_up_to_date = true,
      })
    end,
  },
}
