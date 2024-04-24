return {
    "neovim/nvim-lspconfig",
    dependencies = {
        {
            "williamboman/mason.nvim",
            opts = {
                registries = {
                    'github:nvim-java/mason-registry',
                    'github:mason-org/mason-registry',
                }
            }
        },
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        {
            "dnlhc/glance.nvim", 
            opts = {
                border = {
                    enable = true
                }
            }
        },
        {
            "j-hui/fidget.nvim",
            opts = {
                notification = {
                    window = {
                        winblend = 0,
                        align = "top",
                    },
                }
            }
        }
    },

    config = function()
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "html",
                "cssls",
                "tailwindcss"
            },
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,

                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = { version = "Lua 5.1" },
                                diagnostics = {
                                    globals = { "vim", "it", "describe", "before_each", "after_each" },
                                }
                            }
                        }
                    }
                end,
            }
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }
        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                ['<C-d>'] = cmp.mapping.scroll_docs(4),
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ['<CR>'] = cmp.mapping.confirm({ select = false }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
            }, {
                { name = 'vim-dadbod-completion' },
                { name = 'buffer' },
            })
        })

        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })

        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('brolyn-lsp-attach', { clear = true }),
            callback = function(event)
                local map = function(keys, func, desc)
                    vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                end

                map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
                -- map('gD', '<CMD>Glance definitions<CR>')
                map('<leader>lr', '<CMD>Glance references<CR>', '[G]oto [R]eferences')
                -- map('gY', '<CMD>Glance type_definitions<CR>')
                -- map('gM', '<CMD>Glance implementations<CR>')
                -- map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
                map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
                map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
                map('<leader>ls', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
                map('<leader>lS', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
                map('<leader>la', vim.lsp.buf.code_action, '[L]ist Code [A]ction')
                map('<F2>', vim.lsp.buf.rename, '[R]e[n]ame')
                map('K', vim.lsp.buf.hover, 'Hover Documentation')
                map('gl', '<cmd>lua vim.diagnostic.open_float()<cr>', 'Show diagnostic')
                map('[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', 'Previous diagnostic')
                map(']d', '<cmd>lua vim.diagnostic.goto_next()<cr>', 'Next diagnostic')
                map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
                local client = vim.lsp.get_client_by_id(event.data.client_id)
                if client and client.server_capabilities.documentHighlightProvider then
                    local highlight_augroup = vim.api.nvim_create_augroup('brolyn-lsp-highlight', { clear = false })
                    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                        buffer = event.buf,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.document_highlight,
                    })

                    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                        buffer = event.buf,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.clear_references,
                    })
                end
                if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
                    map('<leader>th', function()
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
                    end, '[T]oggle Inlay [H]ints')
                end
            end
        })

        vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('brolyn-lsp-detach', { clear = true }),
            callback = function(event)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'brolyn-lsp-highlight', buffer = event.buf }
            end,
        })

        local opts = {
            error = '✘',
            warn = '▲',
            hint = '⚑',
            info = '»'
        }

        if vim.diagnostic.count then
            local ds = vim.diagnostic.severity
            local levels = {
                [ds.ERROR] = 'error',
                [ds.WARN] = 'warn',
                [ds.INFO] = 'info',
                [ds.HINT] = 'hint'
            }

            local text = {}

            for i, l in pairs(levels) do
                if type(opts[l]) == 'string' then
                    text[i] = opts[l]
                end
            end

            vim.diagnostic.config({ signs = { text = text } })
            return
        end

        local sign = function(args)
            if opts[args.name] == nil then
                return
            end

            vim.fn.sign_define(args.hl, {
                texthl = args.hl,
                text = opts[args.name],
                numhl = ''
            })
        end

        sign({ name = 'error', hl = 'DiagnosticSignError' })
        sign({ name = 'warn', hl = 'DiagnosticSignWarn' })
        sign({ name = 'hint', hl = 'DiagnosticSignHint' })
        sign({ name = 'info', hl = 'DiagnosticSignInfo' })
    end
}
