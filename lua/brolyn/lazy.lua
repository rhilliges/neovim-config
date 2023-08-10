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
	{ 'tpope/vim-fugitive' },
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
	----------------------------------------------------------------------- lsp
	{
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v2.x',
		dependencies = {
			{ 'neovim/nvim-lspconfig' },
			{
				'williamboman/mason.nvim',
				build = function()
					pcall(vim.cmd, 'MasonUpdate')
				end,
			},
			{ 'williamboman/mason-lspconfig.nvim' },
		},
	},
	{ 'hrsh7th/nvim-cmp' },
	{ 'hrsh7th/cmp-nvim-lsp' },
	{ 'L3MON4D3/LuaSnip' },
	{ "saadparwaiz1/cmp_luasnip" },
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
	----------------------------------------------------------------------- debugging
	{ "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap" } },
	----------------------------------------------------------------------- file handling
	{ 'ThePrimeagen/harpoon' },
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
		config = function()
			vim.cmd.colorscheme 'catppuccin'
		end,
	},
})
