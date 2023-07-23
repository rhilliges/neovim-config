local wk = require "which-key"

wk.register({
    ["<leader>"] = {
        w = { ":w<cr>", "save file" },
        c = {
            name = "[c]lose",
            c = { ":q<cr>", "close editor" },
            s = { ":xa<cr>", "save all and close" },
            f = { ":q!<cr>", "force close editor" }
        },
        -- y = { '"+y', "copy to clipboard" },
        -- p = { '"+p', "paste from clipboard" },
        o = {
            e = { ':Ex<cr>', 'open explorer' }
        }
    }
})
wk.register({
    y = { '"+y', "copy to clipboard" },
    p = { '"+p', "paste from clipboard" }

}, { prefix = '<leader>', mode = 'v' })
