return {
    {
         "rose-pine/neovim",
         name = "rose-pine",
        priority = 1000,
        config = function ()
            require"rose-pine".setup({
                -- variant = "dawn"
                -- transparent_background = false,
                -- integrations = {
                --     fidget = true
                -- }
            })
            vim.cmd.colorscheme "rose-pine"
        end
    }, {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function ()
            require"catppuccin".setup({
                transparent_background = false,
                integrations = {
                    fidget = true
                }
            })
            -- vim.cmd.colorscheme "catppuccin-latte"
        end
    },
    {
      "folke/tokyonight.nvim",
      lazy = false,
      priority = 1000,
      config = function()
        require"tokyonight".setup {
              style = "day"
        }
        -- vim.cmd.colorscheme "tokyonight"
      end
    }
}
