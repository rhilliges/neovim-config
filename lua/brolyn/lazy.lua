local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = "brolyn.plugins",
    change_detection = { notify = false }
})
--[[ {
    'numToStr/Comment.nvim',
    lazy = false,
    opts = {
        toggler = {
            ---Line-comment toggle keymap
            line = '<leader>cc',
            ---Block-comment toggle keymap
            block = '<leader>bc',
        },
        ---LHS of operator-pending mappings in NORMAL and VISUAL mode
        opleader = {
            ---Line-comment keymap
            line = '<leader>c',
            ---Block-comment keymap
            block = '<leader>c',
        },
        ---LHS of extra mappings
        extra = {
            ---Add comment on the line above
            above = '<leader>cO',
            ---Add comment on the line below
            below = '<leader>co',
            ---Add comment at the end of line
            eol = '<leader>cA',
        },
    }
},
{
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {}
},
{ 'windwp/nvim-ts-autotag',    opts = {} },
{ 'RRethy/vim-illuminate' },
{ 'petertriho/nvim-scrollbar', opts = {} }, ]]
