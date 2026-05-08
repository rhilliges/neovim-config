vim.cmd("packadd nvim.undotree")
vim.pack.add({
	-- base
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/nvim-neotest/nvim-nio",
	-- dependency management
	"https://github.com/mason-org/mason.nvim",
	-- editor (navigation, highlighting, formatting)
	"https://github.com/nvim-telescope/telescope.nvim",
	"https://github.com/dnlhc/glance.nvim",
	"https://github.com/nvim-telescope/telescope-fzf-native.nvim",
	"https://github.com/nvim-telescope/telescope-ui-select.nvim",
	{ src = "https://github.com/theprimeagen/harpoon", version = "harpoon2" },
	"https://github.com/stevearc/oil.nvim",
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/stevearc/conform.nvim",
    "https://github.com/laytan/cloak.nvim",
	-- git
	"https://github.com/tpope/vim-fugitive",
	"https://github.com/f-person/git-blame.nvim",
	"https://github.com/lewis6991/gitsigns.nvim",
	-- database
	"https://github.com/tpope/vim-dotenv",
	"https://github.com/tpope/vim-dadbod",
	"https://github.com/kristijanhusak/vim-dadbod-ui",
	"https://github.com/kristijanhusak/vim-dadbod-completion",
	-- lsp
	"https://github.com/rafamadriz/friendly-snippets",
	"https://github.com/saghen/blink.cmp",
	"https://github.com/mfussenegger/nvim-jdtls",
	"https://github.com/RRethy/vim-illuminate",
	-- debugging
	"https://github.com/mfussenegger/nvim-dap",
	"https://github.com/igorlfs/nvim-dap-view",
	-- http
	"https://github.com/mistweaverco/kulala.nvim",
	-- ui
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/folke/snacks.nvim",
    -- writing
    "https://github.com/chomosuke/typst-preview.nvim",
    --golang
    "https://github.com/crispgm/nvim-go",
    "https://github.com/leoluz/nvim-dap-go"
})

require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = "auto",
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = { "filename" },
		lualine_x = { "encoding", "fileformat", "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
})

require("snacks").setup({
	input = {
		enabled = true,
		win = {
			style = "input",
			relative = "cursor",
			row = -3,
			col = 0,
		},
	},
})

require("mason").setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})

require("glance").setup({
	border = {
		enable = true,
	},
})

require("telescope").setup({
	defaults = vim.tbl_extend(
		"force",
		require("telescope.themes").get_ivy(), -- or get_cursor, get_ivy
		{}
	),
	extensions = {
		["ui-select"] = {
			require("telescope.themes").get_dropdown(),
		},
	},
})
-- Enable Telescope extensions if they are installed
pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension, "ui-select")

require("oil").setup()

local harpoon = require("harpoon")
harpoon:setup()

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
	local tabline = "  "
	local tabs = shorten_filenames(harpoon:list().items)
	-- print(vim.inspect(tabs))
	for i, tab in ipairs(tabs) do
		tabline = tabline .. "%#HarpoonNumberInactive#" .. i .. " %*" .. "%#HarpoonInactive#"

		tabline = tabline .. tab.filename .. " | %*"
	end
	return tabline
end

vim.o.tabline = "%!v:lua.tabline()"

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		-- Conform will run multiple formatters sequentially
		-- python = { "isort", "black" },
		-- You can customize some of the format options for the filetype (:help conform.format)
		-- rust = { "rustfmt", lsp_format = "fallback" },
		-- Conform will run the first available formatter
		-- javascript = { "prettierd", "prettier", stop_after_first = true },
	},
})

require("gitsigns").setup({
	signs = {
		add = { text = "+" },
		change = { text = "~" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
	},
})

require("nvim-treesitter").setup({
	ensure_installed = {
		"java",
		"javascript",
		"typescript",
		"css",
		"bash",
		"c",
		"diff",
		"html",
		"lua",
		"luadoc",
		"markdown",
		"markdown_inline",
		"query",
		"http",
		"kulala_http",
		"vim",
		"vimdoc",
		"php",
		"go",
	},
	-- Autoinstall languages that are not installed
	auto_install = true,
	highlight = {
		enable = true,
		-- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
		--  If you are experiencing weird indenting issues, add the language to
		--  the list of additional_vim_regex_highlighting and disabled languages for indent.
		additional_vim_regex_highlighting = { "ruby" },
	},
	indent = { enable = true, disable = { "ruby" } },
})

vim.g.db_ui_use_nerd_fonts = 1

require("blink.cmp").setup({
	keymap = { preset = "default" },
	appearance = {
		nerd_font_variant = "mono",
	},
	completion = {
		documentation = { auto_show = false },
	},
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},
	fuzzy = {
		implementation = "prefer_rust_with_warning",
	},
})
vim.lsp.enable({
	"lua_ls",
	"vtsls",
	"vue_ls",
	"tailwindcss",
	"intelephense",
	"html_ls",
	"gopls",
    "tinymist",
})

require("dap-view").setup({
    winbar = {
        sections = { "console", "watches", "scopes", "exceptions", "breakpoints", "threads", "repl" },
        default_section = "console",
    }
})

vim.fn.sign_define("DapBreakpoint", {
	text = "",
	texthl = "DiagnosticSignError",
	linehl = "",
	numhl = "",
})

vim.filetype.add({
	extension = {
		["http"] = "http",
	},
})

local kulala = require("kulala")
kulala.setup({
	debug = true,
	default_view = "headers_body",
	default_env = "local",
	winbar = true,
	default_win_bar_panes = { "body", "headers", "headers_body", "script_output", "stats" },
})

require 'typst-preview'.setup {}

require('go').setup({
    -- show test result with popup window
    test_popup = true,
})
require('dap-go').setup()
