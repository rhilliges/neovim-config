local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>of', builtin.find_files, {})
vim.keymap.set('n', '<leader>st', builtin.live_grep, {})
