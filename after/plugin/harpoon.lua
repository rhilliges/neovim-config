local harpoon = require("harpoon")

harpoon.setup()

local function get_color(group, attr)
    return vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(group)), attr)
end


local function shorten_filenames(filenames)
    local shortened = {}

    local counts = {}
    for _, file in ipairs(filenames) do
        local name = vim.fn.fnamemodify(file.value, ":t")
        counts[name] = (counts[name] or 0) + 1
    end

    for _, file in ipairs(filenames) do
        local name = vim.fn.fnamemodify(file.value, ":t")

        if counts[name] == 1 then
            table.insert(shortened, { filename = vim.fn.fnamemodify(name, ":t") })
        else
            table.insert(shortened, { filename = file.value })
        end
    end

    return shortened
end

function _G.tabline()
    local tabline = '  '
    local tabs = shorten_filenames(harpoon:list().items)
    -- print(vim.inspect(tabs))
    for i, tab in ipairs(tabs) do

        tabline = tabline ..
            '%#HarpoonNumberInactive#' .. i .. ' %*' .. '%#HarpoonInactive#'

        tabline = tabline .. tab.filename .. ' | %*'

    end
    return tabline
end

vim.cmd('highlight! HarpoonInactive guibg=NONE guifg=#63698c')
vim.cmd('highlight! HarpoonActive guibg=NONE guifg=white')
vim.cmd('highlight! HarpoonNumberActive guibg=NONE guifg=#7aa2f7')
vim.cmd('highlight! HarpoonNumberInactive guibg=NONE guifg=#7aa2f7')
vim.cmd('highlight! TabLineFill guibg=NONE guifg=white')

vim.opt.showtabline = 2

vim.o.tabline = '%!v:lua.tabline()'

vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("harpoon", { clear = true }),
    pattern = { "*" },
    callback = function()
        local color = get_color('HarpoonActive', 'bg#')

        if (color == "" or color == nil) then
            vim.api.nvim_set_hl(0, "HarpoonInactive", { link = "Tabline" })
            vim.api.nvim_set_hl(0, "HarpoonActive", { link = "TablineSel" })
            vim.api.nvim_set_hl(0, "HarpoonNumberActive", { link = "TablineSel" })
            vim.api.nvim_set_hl(0, "HarpoonNumberInactive", { link = "Tabline" })
        end
    end,
})

vim.keymap.set("n", "<leader>p", function() harpoon:list():append() end)
vim.keymap.set("n", "<leader>e", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end)
vim.keymap.set("n", "<leader>5", function() harpoon:list():select(5) end)
vim.keymap.set("n", "<leader>6", function() harpoon:list():select(6) end)

