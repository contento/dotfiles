return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "eslint-lsp",
        "hadolint",
        "prettierd",
        "shfmt",
        "stylua",
        "selene",
        "shellcheck",
        "delve",
        "sql-formatter",
      },
    },
  },
}
