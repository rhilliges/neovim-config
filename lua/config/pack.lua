local rocks_path = vim.fn.expand("~/.luarocks/share/lua/5.1/")
package.path = package.path .. ";" .. rocks_path .. "?.lua;" .. rocks_path .. "?/init.lua"

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
	"https://github.com/esmuellert/codediff.nvim",
	-- database
	"https://github.com/tpope/vim-dotenv",
	"https://github.com/tpope/vim-dadbod",
	"https://github.com/kristijanhusak/vim-dadbod-ui",
	"https://github.com/kristijanhusak/vim-dadbod-completion",
	-- lsp
	"https://github.com/rafamadriz/friendly-snippets",
	"https://github.com/saghen/blink.lib",
	"https://github.com/saghen/blink.cmp",
	"https://github.com/mfussenegger/nvim-jdtls",
	"https://github.com/RRethy/vim-illuminate",
	-- debugging
	"https://github.com/mfussenegger/nvim-dap",
	"https://github.com/igorlfs/nvim-dap-view",
	-- http
	"https://github.com/j-hui/fidget.nvim",
	"https://github.com/rest-nvim/rest.nvim",
	-- ui
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/folke/snacks.nvim",
	-- writing
	"https://github.com/chomosuke/typst-preview.nvim",
	--golang
	"https://github.com/crispgm/nvim-go",
	"https://github.com/leoluz/nvim-dap-go",
})

require("cloak").setup()

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
local select_file = require("harpoon.config").get_default_config().default.select
harpoon:setup({
	default = {
		select = function(item, list, options)
			if item then
				local buf = vim.fn.bufnr(item.value)
				local win = buf ~= -1 and vim.fn.win_findbuf(buf)[1]
				if win then
					vim.api.nvim_set_current_win(win)
				elseif buf == -1 then
					options = vim.tbl_extend("keep", options or {}, { tabedit = true })
				end
			end
			select_file(item, list, options)
		end,
	},
})

local function get_color(group, attr)
	return vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(group)), attr)
end

function _G.tabline()
	local tabs = {}
	local current = vim.api.nvim_get_current_tabpage()
	for number, tab in ipairs(vim.api.nvim_list_tabpages()) do
		local buf = vim.api.nvim_win_get_buf(vim.api.nvim_tabpage_get_win(tab))
		local label
		if vim.b[buf].opencode_terminal then
			label = "opencode"
		elseif vim.t[tab].codediff_view then
			label = "CodeDiff"
		else
			label = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")
			label = label ~= "" and label or "[No Name]"
		end
		local highlight = tab == current and "%#TabLineSel#" or "%#TabLine#"
		tabs[#tabs + 1] = highlight .. "%" .. number .. "T " .. number .. " " .. label:gsub("%%", "%%%%") .. " %T"
	end
	local close = #tabs > 1 and "%999X X " or ""
	return table.concat(tabs) .. "%#TabLineFill#%T%=" .. close
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
	},
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

vim.g.rest_nvim = {
	request = {
		skip_ssl_verification = true,
	},
}

require("typst-preview").setup({})

require("go").setup({
	-- show test result with popup window
	test_popup = true,
})
require("dap-go").setup()
