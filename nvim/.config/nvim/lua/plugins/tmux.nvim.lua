return {{
    "aserowy/tmux.nvim",
    enabled = false,
    config = function()
        return require("tmux").setup({
            resize = {
                enable_default_keybindings = false
            }
        })
    end
}}
