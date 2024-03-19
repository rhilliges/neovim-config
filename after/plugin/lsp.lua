local lsp_zero = require('lsp-zero')
local tc = require('telescope.builtin')

lsp_zero.set_sign_icons({
	error = '✘',
	warn = '▲',
	hint = '⚑',
	info = '»'
})

lsp_zero.on_attach(function(client, bufnr)
	-- see :help lsp-zero-keybindings
	-- to learn the available actions
	lsp_zero.default_keymaps({ buffer = bufnr })
	vim.keymap.set('n', '<leader>lr', '<cmd>Telescope lsp_references<cr>', { buffer = bufnr })
	vim.keymap.set("n", "<leader>ls",
	function() tc.lsp_document_symbols({ layout_strategy = 'vertical', layout_config = { width = 0.5 } }) end)
	vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action)
end)

require('mason').setup({})
require('mason-lspconfig').setup({
	ensure_installed = { 'lua_ls', 'html', 'cssls' },
	handlers = {
		lsp_zero.default_setup,
		jdtls = lsp_zero.noop,
		lua_ls = require('lspconfig').lua_ls.setup({
			settings = {
				Lua = {
					runtime = {
						version = 'LuaJIT'
					},
					diagnostics = {
						globals = { 'vim' },
					},
					workspace = {
						library = {
							vim.env.VIMRUNTIME,
						}
					}
				}
			}
		})
	},
})

require("luasnip.loaders.from_vscode").lazy_load()
local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()

cmp.setup({
	mapping = cmp.mapping.preset.insert({
		-- `Enter` key to confirm completion
		['<CR>'] = cmp.mapping.confirm({ select = false }),

		-- Ctrl+Space to trigger completion menu
		['<C-Space>'] = cmp.mapping.complete(),

		-- Navigate between snippet placeholder
		['<C-f>'] = cmp_action.luasnip_jump_forward(),
		['<C-b>'] = cmp_action.luasnip_jump_backward(),

		-- Scroll up and down in the completion documentation
		['<C-u>'] = cmp.mapping.scroll_docs(-4),
		['<C-d>'] = cmp.mapping.scroll_docs(4),
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
		{ name = 'buffer' },
	}),
})


-- vim.keymap.set("n", "<leader>lr", vim.lsp.buf.code_action)
