return {
    'echasnovski/mini.comment',
    dependencies = {
        'JoosepAlviste/nvim-ts-context-commentstring',
        opts = {
            enable_autocmd = false
        }
    },
    lazy = false,
    opts = {
        options = {
            custom_commentstring = function()
                return require('ts_context_commentstring').calculate_commentstring() or vim.bo.commentstring
            end,
        },
    }
}
