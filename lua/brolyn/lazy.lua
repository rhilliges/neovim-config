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

require("lazy").setup({
	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.2',
		-- or                              , branch = '0.1.x',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},
	{ 'nvim-telescope/telescope-ui-select.nvim' },
	{
		"nvim-telescope/telescope-file-browser.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
	},
	{ 'akinsho/toggleterm.nvim',                version = "*", config = true },
	{ 'f-person/git-blame.nvim' },
	----------------------------------------------------------------------- code parsing
	{
		'nvim-treesitter/nvim-treesitter',
		dependencies = {
			{
				'numToStr/Comment.nvim',
				config = function()
					require "Comment".setup()
				end
			}
		}
	},
	{ 'nvim-treesitter/nvim-treesitter-context' },
	----------------------------------------------------------------------- lsp
	{ 'williamboman/mason.nvim' },
	{ 'williamboman/mason-lspconfig.nvim' },
	{
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v3.x',
		lazy = true,
		config = false,
	},
	-- LSP Support
	{
		'neovim/nvim-lspconfig',
		dependencies = {
			{ 'hrsh7th/cmp-nvim-lsp' },
		}
	},
	-- Autocompletion
	{
		'hrsh7th/nvim-cmp',
		dependencies = {
			{ 'L3MON4D3/LuaSnip' }
		},
	},
	{ 'dnlhc/glance.nvim' },
	{
		'folke/trouble.nvim',
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			position = 'right',
			signs = {
				error = '✘',
				warning = '▲',
				hint = '⚑',
				information = '»'
			}
		},
	},
	{ 'SmiteshP/nvim-navic' },
	{ "mfussenegger/nvim-jdtls" },
	----------------------------------------------------------------------- debugging
	{ "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap" } },
	----------------------------------------------------------------------- file handling
	{
		'rhilliges/harpoon',
		branch = "feature/auto-shift-indices"
	},
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
	},
	----------------------------------------------------------------------- user interface
	{
		'windwp/nvim-autopairs',
		event = "InsertEnter",
		opts = {} -- this is equalent to setup({}) function
	},
	{ 'windwp/nvim-ts-autotag' },
	{ 'RRethy/vim-illuminate' },
	{ 'petertriho/nvim-scrollbar' },
	{ 'nvim-lualine/lualine.nvim' },
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {}
	},
	----------------------------------------------------------------------- color theme
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
	},
})
require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})
