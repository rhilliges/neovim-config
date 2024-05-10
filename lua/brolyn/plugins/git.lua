return {
    {
        "tpope/vim-fugitive",
        config = function()
            vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
            local builtin = require 'telescope.builtin'
            vim.keymap.set("n", "<leader>sb", builtin.git_branches)
            vim.keymap.set("n", "<leader>sc", builtin.git_commits)
        end
    },
    'f-person/git-blame.nvim'
}
