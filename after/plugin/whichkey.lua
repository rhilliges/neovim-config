local wk = require "which-key"

wk.register({
    ["<leader>"] = {
        w = { ":w<cr>", "save file" },
        c = {
            name = "[c]lose",
            b = { ":q<cr>", "[b]uffer" },
            f = { ":q!<cr>", "[f]orce close editor" }
        },
        -- y = { '"+y', "copy to clipboard" },
        -- p = { '"+p', "paste from clipboard" },
    }
})
-- wk.register({
--     y = { '"+y', "copy to clipboard" },
--     p = { '"+p', "paste from clipboard" }
--
-- }, { prefix = '<leader>', mode = 'v' })
