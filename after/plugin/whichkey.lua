local wk = require "which-key"

wk.register({
    ["<leader>"] = {
        w = { ":w<cr>", "save file" },
        c = {
            name = "[c]lose",
            b = { ":q<cr>", "[b]uffer" },
            a = { ":xa<cr>", "save [a]ll and close" },
            f = { ":q!<cr>", "[f]orce close editor" }
        },
        -- y = { '"+y', "copy to clipboard" },
        -- p = { '"+p', "paste from clipboard" },
        o = {
            e = { ':Ex<cr>', '[e]xplorer' }
        }
    }
})
wk.register({
    y = { '"+y', "copy to clipboard" },
    p = { '"+p', "paste from clipboard" }

}, { prefix = '<leader>', mode = 'v' })
