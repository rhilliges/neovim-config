--local wk = require"which-key"
vim.g.mapleader = " "
vim.keymap.set('n',"<A-j>", ":m .+1<CR>==")
vim.keymap.set('n',"<A-k>", ":m .-2<CR>==")
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "p", '"0p')
vim.keymap.set("n", "P", '"0P')
-- vim.keymap.set("x", "<leader>p", [["_dP]])
-- vim.keymap.set("n", "<leader>w", ":w<cr>")

