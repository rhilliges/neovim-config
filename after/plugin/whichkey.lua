local wk = require "which-key"

wk.register({
    ["<leader>"] = {
        w = { ":w<cr>", "Save File" },
        c = {
            name = "Close",
            c = { ":q<cr>", "Close Editor" },
            s = { ":xa<cr>", "Save all and close" },
            f = { ":q!<cr>", "Force Close Editor" }
        },
        y = { '"+y', "Copy to clipboard"},
        p = { '"+p', "Paste from clipboard"}
    }
})
wk.register({
    y = { '"+y', "Copy to clipboard"},
    p = { '"+p', "Paste from clipboard"}

}, { prefix = '<leader>', mode = 'v'})
