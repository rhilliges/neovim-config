local lsp = require'lsp-zero'
local cmp = require'cmp'

lsp.setup_servers({
	'tsserver',
	-- 'eslint',
	-- 'angularls',
	'lua_ls',
	'html'
})

lsp.set_sign_icons({
	error = '✘',
	warn = '▲',
	hint = '⚑',
	info = '»'
})

local glance = require('glance')
local actions = glance.actions
glance.setup({
	border = {
		enable = true, -- Show window borders. Only horizontal borders allowed
		top_char = '=',
		bottom_char = '=',
	},
	mappings = {
		list = {
			['<C-n>'] = actions.next, -- Bring the cursor to the next item in the list
			['<C-p>'] = actions.previous, -- Bring the cursor to the previous item in the list
		},
	},
	winbar = {
		enable = false, -- Available strating from nvim-0.8+
	},
})

local wk = require'which-key'
local tc = require'telescope.builtin'
lsp.on_attach(function(client, bufnr)

	if client.server_capabilities.documentSymbolProvider then
		require('nvim-navic').attach(client, bufnr)
	end

	local opts = { buffer = bufnr, remap = false }
	wk.register({
		[']'] = {
			d = { function() vim.diagnostic.goto_next() end, "Next [d]iagnostic" },
		},
		['['] = {
			d = { function() vim.diagnostic.goto_prev() end, "Previous [d]iagnostic" },
		},
		["<leader>"] = {
			g = {
				name = "[g]oto",
				d = { function() tc.lsp_definitions() end, "[d]efinition" },
				D = { function() tc.lsp_type_definitions() end, "[D]eclaration" },
				i = { '<CMD>Glance implementations<CR>', "[i]mplementations" },
			},
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
				},
				s = {
					function()
						tc.lsp_document_symbols({ layout_strategy = 'vertical', layout_config = { width = 0.5 } })
					end,
					"[s]ymbols"
				},
				r = {
					-- function()
					-- 	tc.lsp_references()
					-- end,
					'<CMD>Glance references<CR>',
					"[r]eferences"
				},
				i = {
					-- function()
					-- 	tc.lsp_references()
					-- end,
					'<CMD>Glance implementations<CR>',
					"[i]mplementations"
				},
			}
		}
	}, opts)
	--  vim.lsp.buf.hover()
	--  vim.lsp.buf.workspace_symbol()
	--  vim.diagnostic.open_float()
	--  vim.lsp.buf.code_action()
	--  vim.lsp.buf.references()
	--  vim.lsp.buf.signature_help()
end)

lsp.setup()

local cmp_action = lsp.cmp_action()
cmp.setup({
	-- max_item_count = 10,
	mapping = {
		-- `Enter` key to confirm completion
		['<C-u>'] = cmp.mapping.scroll_docs(-4),
		['<C-d>'] = cmp.mapping.scroll_docs(4),
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

