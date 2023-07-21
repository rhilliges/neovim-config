local builtin = require('telescope.builtin')
local wk = require "which-key"
wk.register({
    ["<leader>"] = {
        s = {
            name = "[S]earch",
            f = { "<cmd>Telescope find_files<cr>", "Search File" },
            r = { "<cmd>Telescope oldfiles<cr>", "Search Recent File" },
            s = { "<cmd>Telescope lsp_document_symbols<cr>", "Search Symbols" },
            S = { "<cmd>Telescope lsp_workspace_symbols<cr>", "Search Workspace Symbols" },
            t = { "<cmd>Telescope live_grep<cr>", "Search Text" },
            c = { function()
                builtin.live_grep({ default_text = vim.fn.expand('<cword>') })
            end,
                "Search Text At Cursor" }
        },
        o = {
            name = "[o]pen",
            f = { function()
                builtin.find_files()
            end,
                "Open File"
            },
            r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
        },
    }
})
