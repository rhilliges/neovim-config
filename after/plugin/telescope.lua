local builtin = require('telescope.builtin')
local wk = require "which-key"
wk.register({
    ["<leader>"] = {
        s = {
            name = "[S]earch",
            f = { "<cmd>Telescope find_files<cr>", "search file" },
            r = { "<cmd>Telescope oldfiles<cr>", "search recent file" },
            s = { "<cmd>Telescope lsp_document_symbols<cr>", "search symbols" },
            S = { "<cmd>Telescope lsp_workspace_symbols<cr>", "search workspace symbols" },
            t = { "<cmd>Telescope live_grep<cr>", "search text" },
            c = { function()
                builtin.live_grep({ default_text = vim.fn.expand('<cword>') })
            end,
                "search text at cursor" }
        },
        o = {
            name = "[o]pen",
            f = { function()
                builtin.find_files()
            end,
                "open file"
            },
            r = { "<cmd>Telescope oldfiles<cr>", "open recent file" },
        },
    }
})
