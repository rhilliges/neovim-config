vim.g.mapleader = " "

vim.keymap.set('n',"<leader>n", vim.cmd.Ex)
vim.keymap.set('n',"<A-j>", ":m .+1<CR>==")
vim.keymap.set('n',"<A-k>", ":m .-2<CR>==")
vim.keymap.set('v',"<leader>y", '"+y')
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv")

vim.keymap.set('n','<C-h>', '<C-w>h')
vim.keymap.set('n','<C-j>', '<C-w>j')
vim.keymap.set('n','<C-k>', '<C-w>k')
vim.keymap.set('n','<C-l>', '<C-w>l')

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "p", '"0p')
vim.keymap.set("n", "P", '"0P')
vim.keymap.set("n", "<leader>w", ':w<CR>')
