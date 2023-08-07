local wk = require 'which-key'
local h = require("harpoon")
local hm = require 'harpoon.mark'
local hu = require 'harpoon.ui'
h.setup({
    tabline = true,
    tabline_prefix = "   ",
    tabline_suffix = "  |",
})

wk.register({
    ['<leader>'] = {
        p = {
            name = '[p]in',
            f = { function()
                hm.toggle_file()
            end,
                'toggle [f]ile'
            },
        },
        ['1'] = {
            function()
                hu.nav_file(1)
            end,
            'first buffer'
        },
        ['2'] = {
            function()
                hu.nav_file(2)
            end,
            'second buffer'
        },
        ['3'] = {
            function()
                hu.nav_file(3)
            end,
            'third buffer'
        },
        ['4'] = {
            function()
                hu.nav_file(4)
            end,
            'fourth buffer'
        },
        ['5'] = {
            function()
                hu.nav_file(5)
            end,
            'fifth buffer'
        },
    }
})

vim.cmd('highlight! HarpoonInactive guibg=NONE guifg=#63698c')
vim.cmd('highlight! HarpoonActive guibg=NONE guifg=white')
vim.cmd('highlight! HarpoonNumberActive guibg=NONE guifg=#7aa2f7')
vim.cmd('highlight! HarpoonNumberInactive guibg=NONE guifg=#7aa2f7')
vim.cmd('highlight! TabLineFill guibg=NONE guifg=white')
