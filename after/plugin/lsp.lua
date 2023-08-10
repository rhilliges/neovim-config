local lsp = require "lsp-zero"
local cmp = require('cmp')
local lspc = require 'lspconfig'
local wk = require "which-key"
local tc = require('telescope.builtin')

lsp.preset({})
lsp.setup_servers({
	'tsserver',
	'eslint',
	'angularls',
	'lua_ls',
	'html'
})
lsp.nvim_workspace()

lsp.set_sign_icons({
	error = '✘',
	warn = '▲',
	hint = '⚑',
	info = '»'
})
lsp.set_preferences({
	suggest_lsp_servers = false,
})

lsp.on_attach(function(client, bufnr)
	local opts = { buffer = bufnr, remap = false }
	wk.register({
		["<leader>"] = {
			g = {
				name = "[g]oto",
				d = { function() tc.lsp_definitions() end, "[d]efinition" },
				D = { function() tc.lsp_type_definitions() end, "[D]eclaration" },
				i = { function() tc.lsp_implementations() end, "[i]mplementations" },
			},
			-- g = {
			--     name = "[g]oto",
			--     d = { function() vim.lsp.buf.definition() end, "[d]efinition" },
			--     D = { function() vim.lsp.buf.declaration() end, "[D]eclaration" },
			--     i = { function() vim.lsp.buf.implementation() end, "[i]mplementation" },
			-- },
			f = {
				f = { function() vim.lsp.buf.format() end, "[f]ile" },
			},
			r = {
				name = "[r]efactor",
				r = { function() vim.lsp.buf.rename() end, "[r]ename" }
			},
			l = {
				name = "[l]ist",
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
					"line [d]iagnostics",
				}
			}
		}
	}, opts)
	--  vim.lsp.buf.hover()
	--  vim.lsp.buf.workspace_symbol() -> telescope
	--  vim.diagnostic.open_float()
	--  vim.diagnostic.goto_next()
	--  vim.diagnostic.goto_prev()
	--  vim.lsp.buf.code_action()
	--  vim.lsp.buf.references() --> telescope
	--  vim.lsp.buf.signature_help()
end)

lsp.setup()

local cmp_action = lsp.cmp_action()
cmp.setup({
	-- max_item_count = 10,
	mapping = {
		-- `Enter` key to confirm completion
		['<CR>'] = cmp.mapping.confirm({ select = false }),
		['<C-p>'] = cmp.mapping.select_prev_item(),
		['<C-n>'] = cmp.mapping.select_next_item(),
		['<C-y>'] = cmp.mapping.confirm({ select = true }),
		-- Ctrl+Space to trigger completion menu
		['<C-Space>'] = cmp.mapping.complete(),
		-- Navigate between snippet placeholder
		['<C-f>'] = cmp_action.luasnip_jump_forward(),
		['<C-b>'] = cmp_action.luasnip_jump_backward(),
	},
	snippet = {
		expand = function(args)
			require('luasnip').lsp_expand(args.body)
		end,
	},
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
	}, {
		{ name = 'buffer' },
	}),
	-- formatting = {
	-- 	format = lspkind.cmp_format {
	-- 		with_text = true,
	-- 		menu = {
	-- 			buffer = "[buf]",
	-- 			nvim_lsp = "[LSP]",
	-- 			nvim_lua = "[api]",
	-- 			path = "[path]",
	-- 			luasnip = "[snip]",
	-- 			gh_issues = "[issues]",
	-- 			tn = "[TabNine]",
	-- 			eruby = "[erb]",
	-- 		},
	-- 	},
	-- },

	experimental = {
		native_menu = false,
		ghost_text = true,
	},
})
vim.diagnostic.config({
	virtual_text = true
})
