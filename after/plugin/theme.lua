
vim.cmd('highlight! HarpoonInactive guibg=NONE guifg=#7f849c')
vim.cmd('highlight! HarpoonActive guibg=NONE guifg=#cdd6f4')
vim.cmd('highlight! HarpoonNumberInactive guibg=NONE guifg=#b4befe')
vim.cmd('highlight! HarpoonNumberActive guibg=NONE guifg=#cba6f7')
vim.cmd('highlight! TabLineFill guibg=NONE guifg=white')

require("catppuccin").setup({
    integrations = {
        cmp = true,
        treesitter = true,
		harpoon = true
    }
})