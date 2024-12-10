return {
    {
         "rose-pine/neovim",
         name = "rose-pine",
        priority = 1000,
        config = function ()
            require"rose-pine".setup({
                -- dim_inactive_windows = true,
                extend_background_behind_borders = true,
                styles = {
                    transparency = true
                }
            })
            vim.cmd.colorscheme "rose-pine"
        end
    }, {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        opts = {
            transparent_background = false,
            integrations = {
                fidget = true
            }
        }
    },
    {
      "folke/tokyonight.nvim",
      lazy = false,
      priority = 1000,
      opts = {}
    }
}
