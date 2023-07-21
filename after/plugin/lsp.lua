local lsp = require "lsp-zero"
local wk = require "which-key"
lsp.preset("minimal")

lsp.ensure_installed({
    'rust_analyzer',
})

-- Fix Undefined global 'vim'
lsp.nvim_workspace()
local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    --  ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = false })
})
-- cmp_mappings['<Tab>'] = nil
-- cmp_mappings['<S-Tab>'] = nil

lsp.setup_nvim_cmp({
    mapping = cmp_mappings
})

lsp.set_preferences({
    suggest_lsp_servers = false,
    sign_icons = {
        error = '✘',
        warn = '▲',
        hint = '⚑',
        info = '»'
    }
})

lsp.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }
    wk.register({
        ["<leader>"] = {
            g = {
                name = "[g]oto",
                d = { function() vim.lsp.buf.definition() end, "[d]efinition" },
                D = { function() vim.lsp.buf.declaration() end, "[D]eclaration" },
                i = { function() vim.lsp.buf.implementation() end, "[i]mplementation" },
            },
            f = {
                f = { "<cmd> LspZeroFormat<cr>", "[f]ile" },
            },
            r = {
                name = "[r]efactor",
                r = { function() vim.lsp.buf.rename() end, "[r]ename" }
            },
            a = {
                function()
                    vim.lsp.buf.code_action()
                end,
                "code [a]ction",
            },
            d = {
                function()
                    local float = vim.diagnostic.config().float

                    if float then
                        local config = type(float) == "table" and float or {}
                        config.scope = "line"

                        vim.diagnostic.open_float(config)
                    end
                end,
                "Show line [d]iagnostics",
            }
        }
    }, opts)
    --  vim.lsp.buf.hover()
    --  vim.lsp.buf.workspace_symbol() -> telescope
    --  vim.diagnostic.open_float()
    --  vim.diagnostic.goto_next()
    --  vim.diagnostic.goto_prev()
    --  vim.lsp.buf.code_action()
    --  vim.lsp.buf.references()
    --  vim.lsp.buf.signature_help()
end)

lsp.setup()

vim.diagnostic.config({
    virtual_text = true
})
