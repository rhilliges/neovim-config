return {
    "folke/zen-mode.nvim",
    opts = {
        plugins = {
            tmux = {
                enabled = true,
            },
            alacritty = {
                enabled = true
            }
        }
    },
    config = function ()
        vim.keymap.set("n", "<leader>z", require("zen-mode").toggle)
    end
}
