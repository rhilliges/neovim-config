local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup(
	{
		-- package manager
		{
			'williamboman/mason.nvim'
			,
			opts = {
				registries = {
					'github:nvim-java/mason-registry',
					'github:mason-org/mason-registry',
				}
			}
		},
		{ 'nvim-lua/plenary.nvim' },
		-- terminal and git
		{ 'akinsho/toggleterm.nvim',                version = "*", config = true },
		-- navigation
		{ 'ThePrimeagen/harpoon',             branch = 'harpoon2' },
		{ 'nvim-telescope/telescope.nvim',    tag = '0.1.5' },
		-- lsp
		{ 'williamboman/mason-lspconfig.nvim' },
		{ 'neovim/nvim-lspconfig' },
		-- autocompletion
		{ 'VonHeikemen/lsp-zero.nvim',        branch = 'v3.x' },
		{ 'hrsh7th/nvim-cmp' },
		{ 'hrsh7th/cmp-nvim-lsp' },
		{ 'hrsh7th/cmp-path' },
		{ 'hrsh7th/cmp-buffer' },
		{ 'hrsh7th/cmp-nvim-lua' },
		{ 'saadparwaiz1/cmp_luasnip' },
		{ 'L3MON4D3/LuaSnip',                 dependencies = { "rafamadriz/friendly-snippets" }, },


		-- java
		{ "mfussenegger/nvim-jdtls" },
		{ "rcarriga/nvim-dap-ui",             opts = {},                                         dependencies = { "mfussenegger/nvim-dap" } },
		-- code parsing
		'nvim-treesitter/nvim-treesitter',
		{
			'windwp/nvim-autopairs',
			event = "InsertEnter",
			opts = {}
		},
		{ 'windwp/nvim-ts-autotag',    opts = {} },
		{
			'numToStr/Comment.nvim',
			lazy = false,
			opts = {
				toggler = {
					---Line-comment toggle keymap
					line = '<leader>cc',
					---Block-comment toggle keymap
					block = '<leader>bc',
				},
				---LHS of operator-pending mappings in NORMAL and VISUAL mode
				opleader = {
					---Line-comment keymap
					line = '<leader>c',
					---Block-comment keymap
					block = '<leader>c',
				},
				---LHS of extra mappings
				extra = {
					---Add comment on the line above
					above = '<leader>cO',
					---Add comment on the line below
					below = '<leader>co',
					---Add comment at the end of line
					eol = '<leader>cA',
				},
			}
		},
		{ 'RRethy/vim-illuminate' },
		{ 'f-person/git-blame.nvim' },
		-- looks
		{ 'petertriho/nvim-scrollbar', opts = {} },
		{ 'nvim-lualine/lualine.nvim' },
		{
			"catppuccin/nvim",
			name = "catppuccin",
			-- "everblush/nvim",
			-- name = 'everblush',
			lazy = false, -- make sure we load this during startup if it is your main colorscheme
			priority = 1000, -- make sure to load this before all the other start plugins
			config = function()
				-- load the colorscheme here
				vim.cmd([[colorscheme catppuccin-mocha]])
			end,
		}
	}
)

local function cwd()
	return vim.loop.cwd()
end
require('lualine').setup({
	sections = {
		lualine_c = {
			{
				'filename',
				file_status = true, -- displays file status (readonly status, modified status)
				path = 1 -- 0 = just filename, 1 = relative path, 2 = absolute path
			}
		},
		lualine_x = {cwd}
	}
})
