local nvim_tree = require('nvim-tree')
local wk = require "which-key"
local gwidth = vim.api.nvim_list_uis()[1].width
local gheight = vim.api.nvim_list_uis()[1].height
local width = 100
local height = 40

nvim_tree.setup {
    disable_netrw = false,
    hijack_netrw = false,
    view = {
        width = width,
        -- height = height,
        float = {
            enable = true,
            open_win_config = {
                relative = "editor",
                width = width,
                height = height,
                row = (gheight - height) * 0.4,
                col = (gwidth - width) * 0.5,
            }
        }
    }
}

wk.register({
    ["<leader>"] = {
        o = {
            name = "[o]pen",
            e = {
                ":NvimTreeToggle<cr>",
                "[e]xplorer"
            }
        }
    }
})
