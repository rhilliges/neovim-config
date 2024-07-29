return {
    {
        "tpope/vim-fugitive",
        config = function()
            vim.keymap.set("n", "<leader>gs", function ()
                local ok, mod = pcall(require, "dapui")
                if ok then
                    mod.close()

                end

                vim.cmd.Git()
            end)
            local builtin = require 'telescope.builtin'
            vim.keymap.set("n", "<leader>sb", builtin.git_branches)
            vim.keymap.set("n", "<leader>sc", builtin.git_commits)
        end
    },
    'f-person/git-blame.nvim',
    {
        'lewis6991/gitsigns.nvim',
        opts = {}
    }
}
