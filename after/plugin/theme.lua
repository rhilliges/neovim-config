require("catppuccin").setup({
	transparent_background = true,
	integrations = {
		cmp = true,
		treesitter = true,
		harpoon = true,
		nvimtree = true,
		which_key = true,
	}
})

vim.cmd.colorscheme "catppuccin-mocha"
vim.cmd('highlight! HarpoonActive guibg=NONE guifg=#cdd6f4')
vim.cmd('highlight! HarpoonNumberInactive guibg=NONE guifg=#b4befe')
vim.cmd('highlight! HarpoonNumberActive guibg=NONE guifg=#cba6f7')
vim.cmd('highlight! TabLineFill guibg=NONE guifg=white')
vim.cmd('highlight! HarpoonInactive guibg=NONE guifg=#7f849c')

