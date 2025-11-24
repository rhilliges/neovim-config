vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

vim.o.number = true
vim.o.relativenumber = true

vim.o.winborder = "rounded"

-- Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = "a"

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

--  See `:help 'clipboard'`
-- vim.schedule(function()
--   vim.o.clipboard = 'unnamedplus'
-- end)

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = "yes"

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4

vim.o.list = true
vim.opt.listchars = {
	-- tab = "» ",
	tab = "  ",
	trail = "·",
	nbsp = "␣",
}

-- Preview substitutions live, as you type!
vim.o.inccommand = "split"

-- Show which line your cursor is on
vim.o.cursorline = true

-- animate the cursor
vim.opt.guicursor = {
	"n-v-c:block-Cursor/lCursor-blinkwait1000-blinkon100-blinkoff100",
	"i-ci:ver25-Cursor/lCursor-blinkwait1000-blinkon100-blinkoff100",
	"r:hor50-Cursor/lCursor-blinkwait100-blinkon100-blinkoff100",
}

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

--  Use CTRL+<hjkl> to switch between windows
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.keymap.set("n", "<leader>w", ":wa<CR>:lua print 'Saved all files'<CR>")
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==")
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==")
vim.keymap.set("n", "p", '"0p')
vim.keymap.set("n", "P", '"0P')
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv")

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
-- See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = { "Jenkinsfile.*" },
	callback = function()
		local buf = vim.api.nvim_get_current_buf()
		vim.api.nvim_set_option_value("filetype", "groovy", { buf = buf })
	end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

require("lazy").setup({
	"NMAC427/guess-indent.nvim", -- Detect tabstop and shiftwidth automatically
	-- navigation
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		config = function()
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

			vim.cmd("highlight! HarpoonInactive guibg=NONE guifg=#63698c")
			vim.cmd("highlight! HarpoonActive guibg=NONE guifg=white")
			vim.cmd("highlight! HarpoonNumberActive guibg=NONE guifg=#7aa2f7")
			vim.cmd("highlight! HarpoonNumberInactive guibg=NONE guifg=#7aa2f7")
			vim.cmd("highlight! TabLineFill guibg=NONE guifg=white")

			vim.opt.showtabline = 2

			vim.o.tabline = "%!v:lua.tabline()"

			vim.api.nvim_create_autocmd("ColorScheme", {
				group = vim.api.nvim_create_augroup("harpoon", { clear = true }),
				pattern = { "*" },
				callback = function()
					local color = get_color("HarpoonActive", "bg#")

					if color == "" or color == nil then
						vim.api.nvim_set_hl(0, "HarpoonInactive", { link = "Tabline" })
						vim.api.nvim_set_hl(0, "HarpoonActive", { link = "TablineSel" })
						vim.api.nvim_set_hl(0, "HarpoonNumberActive", { link = "TablineSel" })
						vim.api.nvim_set_hl(0, "HarpoonNumberInactive", { link = "Tabline" })
					end
				end,
			})

			vim.keymap.set("n", "<leader>p", function()
				harpoon:list():add()
			end)
			vim.keymap.set("n", "<leader>e", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end)

			vim.keymap.set("n", "<leader>1", function()
				harpoon:list():select(1)
			end)
			vim.keymap.set("n", "<leader>2", function()
				harpoon:list():select(2)
			end)
			vim.keymap.set("n", "<leader>3", function()
				harpoon:list():select(3)
			end)
			vim.keymap.set("n", "<leader>4", function()
				harpoon:list():select(4)
			end)
			vim.keymap.set("n", "<leader>5", function()
				harpoon:list():select(5)
			end)
			vim.keymap.set("n", "<leader>6", function()
				harpoon:list():select(6)
			end)
			vim.keymap.set("n", "<leader>7", function()
				harpoon:list():select(7)
			end)
			vim.keymap.set("n", "<leader>8", function()
				harpoon:list():select(8)
			end)
			vim.keymap.set("n", "<leader>9", function()
				harpoon:list():select(9)
			end)
			vim.keymap.set("n", "<leader>0", function()
				harpoon:list():select(0)
			end)
		end,
	},
  {
  "folke/snacks.nvim",
  ---@type snacks.Config
    opts = {
      input = {
        win = {
          style = "input",
          relative = "cursor",
          row = -3,
          col = 0,
        }
      }
    }
  },
	{ -- Fuzzy Finder (files, lsp, etc)
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		dependencies = {
			{
				"dnlhc/glance.nvim",
				opts = {
					border = {
						enable = true,
					},
				},
			},
			"nvim-lua/plenary.nvim",
			{ -- If encountering errors, see telescope-fzf-native README for installation instructions
				"nvim-telescope/telescope-fzf-native.nvim",

				-- `build` is used to run some command when the plugin is installed/updated.
				-- This is only run then, not every time Neovim starts up.
				build = "make",

				-- `cond` is a condition used to determine whether this plugin should be
				-- installed and loaded.
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },
			{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
		},
		config = function()
			-- Two important keymaps to use while in Telescope are:
			--  - Insert mode: <c-/>
			--  - Normal mode: ?
			-- This opens a window that shows you all of the keymaps for the current
			-- Telescope picker. This is really useful to discover what Telescope can
			-- do as well as how to actually do it!
			-- [[ Configure Telescope ]]
			-- See `:help telescope` and `:help telescope.setup()`

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

			-- See `:help telescope.builtin`
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
			vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
			vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
			vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
			vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
			vim.keymap.set("n", "<leader>st", builtin.live_grep, { desc = "[S]earch by [G]rep" })
			vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
			vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
			vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
			vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
			vim.keymap.set("n", "<leader>sb", builtin.git_branches)
			vim.keymap.set("n", "<leader>sc", builtin.git_commits)

			-- Slightly advanced example of overriding default behavior and theme
			vim.keymap.set("n", "<leader>/", function()
				-- You can pass additional configuration to Telescope to change the theme, layout, etc.
				builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end, { desc = "[/] Fuzzily search in current buffer" })

			-- It's also possible to pass additional configuration options.
			--  See `:help telescope.builtin.live_grep()` for information about particular keys
			vim.keymap.set("n", "<leader>s/", function()
				builtin.live_grep({
					grep_open_files = true,
					prompt_title = "Live Grep in Open Files",
				})
			end, { desc = "[S]earch [/] in Open Files" })

			-- Shortcut for searching your Neovim configuration files
			vim.keymap.set("n", "<leader>sn", function()
				builtin.find_files({ cwd = vim.fn.stdpath("config") })
			end, { desc = "[S]earch [N]eovim files" })
		end,
	},
	{
		-- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
		-- used for completion, annotations and signatures of Neovim apis
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		-- Main LSP Configuration
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{
				"mfussenegger/nvim-jdtls",
			},

			-- Useful status updates for LSP.
			{
				"j-hui/fidget.nvim",
				opts = {
					notification = {
						window = {
							winblend = 0,
							align = "top",
						},
					},
				},
			},

			-- Allows extra capabilities provided by blink.cmp
			"saghen/blink.cmp",
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					local telescope = require("telescope.builtin")
					map("<F2>", vim.lsp.buf.rename, "[R]e[n]ame")
					map("<leader>lr", "<CMD>Glance references<CR>", "[G]oto [R]eferences")
					map("gd", telescope.lsp_definitions, "[G]oto [D]efinition")
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
					map("gI", telescope.lsp_implementations, "[G]oto [I]mplementation")
					map("<leader>la", vim.lsp.buf.code_action, "[L]ist Code [A]ction")
					map("<leader>ls", telescope.lsp_document_symbols, "[D]ocument [S]ymbols")
					map("<leader>lS", telescope.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
					map("<leader>lt", telescope.lsp_type_definitions, "Type [D]efinition")

					local function client_supports_method(client, method, bufnr)
						if vim.fn.has("nvim-0.11") == 1 then
							return client:supports_method(method, bufnr)
						else
							return client.supports_method(method, { bufnr = bufnr })
						end
					end

					-- The following two autocommands are used to highlight references of the
					-- word under your cursor when your cursor rests there for a little while.
					--    See `:help CursorHold` for information about when this is executed
					--
					-- When you move your cursor, the highlights will be cleared (the second autocommand).
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if
						client
						and client_supports_method(
							client,
							vim.lsp.protocol.Methods.textDocument_documentHighlight,
							event.buf
						)
					then
						local highlight_augroup =
							vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
							end,
						})
					end

					-- The following code creates a keymap to toggle inlay hints in your
					-- code, if the language server you are using supports them
					--
					-- This may be unwanted, since they displace some of your code
					if
						client
						and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
					then
						map("<leader>lh", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})

			-- Diagnostic Config
			-- See :help vim.diagnostic.Opts
			vim.diagnostic.config({
				-- Use the default configuration
				-- virtual_lines = true
				-- Alternatively, customize specific options
				virtual_lines = {
					-- Only show virtual line diagnostics for the current cursor line
					current_line = true,
				},
				severity_sort = true,
				float = { border = "rounded", source = "if_many" },
				underline = { severity = vim.diagnostic.severity.ERROR },
				signs = vim.g.have_nerd_font and {
					text = {
						[vim.diagnostic.severity.ERROR] = "󰅚 ",
						[vim.diagnostic.severity.WARN] = "󰀪 ",
						[vim.diagnostic.severity.INFO] = "󰋽 ",
						[vim.diagnostic.severity.HINT] = "󰌶 ",
					},
				} or {},
				virtual_text = {
					source = "if_many",
					spacing = 2,
					format = function(diagnostic)
						local diagnostic_message = {
							[vim.diagnostic.severity.ERROR] = diagnostic.message,
							[vim.diagnostic.severity.WARN] = diagnostic.message,
							[vim.diagnostic.severity.INFO] = diagnostic.message,
							[vim.diagnostic.severity.HINT] = diagnostic.message,
						}
						return diagnostic_message[diagnostic.severity]
					end,
				},
			})

			local capabilities = require("blink.cmp").get_lsp_capabilities()

			-- Enable the following language servers
			--  Add any additional override configuration in the following tables. Available keys are:
			--  - cmd (table): Override the default command used to start the server
			--  - filetypes (table): Override the default list of associated filetypes for the server
			--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
			--  - settings (table): Override the default settings passed when initializing the server.
			--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
			local servers = {
				lua_ls = {
					-- cmd = { ... },
					-- filetypes = { ... },
					-- capabilities = {},
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
							-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
							-- diagnostics = { disable = { 'missing-fields' } },
						},
					},
				},
			}

			-- Ensure the servers and tools above are installed
			--
			-- To check the current status of installed tools and/or manually install
			-- other tools, you can run
			--    :Mason
			--
			-- You can press `g?` for help in this menu.
			--
			-- `mason` had to be setup earlier: to configure its options see the
			-- `dependencies` table for `nvim-lspconfig` above.
			--
			-- You can add other tools here that you want Mason to install
			-- for you, so that they are available from within Neovim.
			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua", -- Used to format Lua code
				"ts_ls",
				"html-lsp",
				"tailwindcss",
				"cssls",
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			require("mason-lspconfig").setup({
				ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
				automatic_installation = false,
				automatic_enable = ensure_installed,
				handlers = {
					function(server_name)
						local server = servers or {}
						-- This handles overriding only values explicitly passed
						-- by the server configuration above. Useful when disabling
						-- certain features of an LSP (for example, turning off formatting for ts_ls)
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						vim.lsp.enable(server)
					end,
				},
			})
		end,
	},

	{ -- Autoformat
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = false,
			-- format_on_save = function(bufnr)
			-- 	-- Disable "format_on_save lsp_fallback" for languages that don't
			-- 	-- have a well standardized coding style. You can add additional
			-- 	-- languages here or re-enable it for the disabled ones.
			-- 	local disable_filetypes = { c = true, cpp = true }
			-- 	if disable_filetypes[vim.bo[bufnr].filetype] then
			-- 		return nil
			-- 	else
			-- 		return {
			-- 			timeout_ms = 500,
			-- 			lsp_format = "fallback",
			-- 		}
			-- 	end
			-- end,
			formatters_by_ft = {
				lua = { "stylua" },
				-- Conform can also run multiple formatters sequentially
				-- python = { "isort", "black" },
				--
				-- You can use 'stop_after_first' to run the first available formatter from the list
				-- javascript = { "prettierd", "prettier", stop_after_first = true },
			},
		},
	},

	{ -- Autocompletion
		"saghen/blink.cmp",
		event = "VimEnter",
		version = "1.*",
		dependencies = {
			-- Snippet Engine
			{
				"L3MON4D3/LuaSnip",
				version = "2.*",
				build = (function()
					-- Build Step is needed for regex support in snippets.
					-- This step is not supported in many windows environments.
					-- Remove the below condition to re-enable on windows.
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
				dependencies = {
					-- `friendly-snippets` contains a variety of premade snippets.
					--    See the README about individual language/framework/plugin snippets:
					--    https://github.com/rafamadriz/friendly-snippets
					{
						"rafamadriz/friendly-snippets",
						config = function()
							require("luasnip.loaders.from_vscode").lazy_load()
						end,
					},
				},
				opts = {},
			},
			"folke/lazydev.nvim",
		},
		--- @module 'blink.cmp'
		--- @type blink.cmp.Config
		opts = {
			keymap = {
				-- 'default' (recommended) for mappings similar to built-in completions
				--   <c-y> to accept ([y]es) the completion.
				--    This will auto-import if your LSP supports it.
				--    This will expand snippets if the LSP sent a snippet.
				-- 'super-tab' for tab to accept
				-- 'enter' for enter to accept
				-- 'none' for no mappings
				--
				-- For an understanding of why the 'default' preset is recommended,
				-- you will need to read `:help ins-completion`
				--
				-- No, but seriously. Please read `:help ins-completion`, it is really good!
				--
				-- All presets have the following mappings:
				-- <tab>/<s-tab>: move to right/left of your snippet expansion
				-- <c-space>: Open menu or open docs if already open
				-- <c-n>/<c-p> or <up>/<down>: Select next/previous item
				-- <c-e>: Hide menu
				-- <c-k>: Toggle signature help
				--
				-- See :h blink-cmp-config-keymap for defining your own keymap
				preset = "default",

				-- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
				--    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
			},

			appearance = {
				-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},

			completion = {
				-- By default, you may press `<c-space>` to show the documentation.
				-- Optionally, set `auto_show = true` to show the documentation after a delay.
				documentation = { auto_show = false, auto_show_delay_ms = 500 },
			},

			sources = {
				default = { "lsp", "path", "snippets", "buffer", "lazydev" },
				per_filetype = {
					sql = { "snippets", "dadbod", "buffer" },
				},
				providers = {
					-- add vim-dadbod-completion to your completion providers
					dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
					lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
				},
			},

			snippets = { preset = "luasnip" },

			-- Blink.cmp includes an optional, recommended rust fuzzy matcher,
			-- which automatically downloads a prebuilt binary when enabled.
			--
			-- By default, we use the Lua implementation instead, but you may enable
			-- the rust implementation via `'prefer_rust_with_warning'`
			--
			-- See :h blink-cmp-config-fuzzy for more information
			fuzzy = { implementation = "lua" },

			-- Shows a signature help window while you type arguments for a function
			signature = { enabled = true },
		},
	},
	-- Highlight todo, notes, etc in comments
	{
		"rose-pine/neovim",
		name = "rose-pine",
		priority = 1000,
		config = function()
			require("rose-pine").setup({
				-- dim_inactive_windows = true,
				extend_background_behind_borders = true,
				styles = {
					transparency = true,
				},
			})
			vim.cmd.colorscheme("rose-pine-dawn")
		end,
	},
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
	{ -- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		main = "nvim-treesitter.configs", -- Sets main module to use for opts
		-- [[ Configure Treesitter ]] See `:help nvim-treesitter`
		opts = {
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
				"vim",
				"vimdoc",
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
		},
		-- There are additional nvim-treesitter modules that you can use to interact
		-- with nvim-treesitter. You should go explore a few and see what interests you:
		--
		--    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
		--    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
		--    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
	},
	-- debugging
	{
		"mfussenegger/nvim-dap",
		opts = {},
		dependencies = {
			-- {
			-- 	"igorlfs/nvim-dap-view",
			-- 	---@module 'dap-view'
			-- 	---@type dapview.Config
			-- 	opts = {
			--        windows = {
			--          position = "right",
			--        }
			--      },
			-- },
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")
			vim.fn.sign_define("DapBreakpoint", {
				text = "",
				texthl = "DiagnosticSignError",
				linehl = "",
				numhl = "",
			})

			dapui.setup({
				layouts = {
					{
						elements = {
							-- "repl"
							{ id = "console", size = 0.65 },
							{ id = "repl", size = 0.35 },
						},
						size = 0.25,
						position = "bottom", -- Can be "bottom" or "top"
					},
					{
						elements = {
							{ id = "scopes", size = 0.25 },
							{ id = "stacks", size = 0.25 },
							{ id = "watches", size = 0.25 },
						},
						size = 30,
						position = "left", -- Can be "left" or "right"
					},
				},
			})

			vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint)
			vim.keymap.set("n", "<F5>", dap.continue)
			vim.keymap.set("n", "<F6>", dap.step_over)
			vim.keymap.set("n", "<F7>", dap.step_into)
			vim.keymap.set("n", "<F8>", dap.step_out)
			vim.keymap.set("n", "<leader>du", dapui.toggle)
			-- vim.keymap.set("n", "<leader>do", "<CMD>DapViewOpen<CR>")
			-- vim.keymap.set("n", "<leader>dc", "<CMD>DapViewClose<CR>")
			vim.keymap.set("n", "<leader>dc", function()
				dapui.float_element("console", {
					width = 150,
					height = 80,
					position = "center",
				})
			end)
		end,
	},
	-- database
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = {
			{ "tpope/vim-dadbod", lazy = true },
			{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
			{ "tpope/vim-dotenv" },
		},
		cmd = {
			"DBUI",
			"DBUIToggle",
			"DBUIAddConnection",
			"DBUIFindBuffer",
		},
		init = function()
			-- Your DBUI configuration
			vim.g.db_ui_use_nerd_fonts = 1
		end,
	},
	-- git
	{
		"tpope/vim-fugitive",
		config = function()
			vim.keymap.set("n", "<leader>gs", function()
				-- local ok, dapui = pcall(require, "dapui")
				-- if ok then
				-- 	dapui.close()
				-- end
				-- local ok, ai = pcall(require, "avante")
				-- if ok then
				--   ai.close()
				-- end
				vim.cmd.Git()
				vim.cmd("wincmd o")
			end)
		end,
	},
	"f-person/git-blame.nvim",
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},
	-- http
	{
		"mistweaverco/kulala.nvim",
		config = function()
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
			vim.keymap.set("n", "<leader>rr", kulala.run)
			vim.keymap.set("n", "<leader>rs", kulala.search)
			vim.keymap.set("n", "<leader>rS", kulala.show_stats)
			vim.keymap.set("n", "<leader>rt", kulala.toggle_view)
			vim.keymap.set("n", "<leader>rn", kulala.jump_next)
			vim.keymap.set("n", "<leader>rp", kulala.jump_prev)
			vim.keymap.set("n", "<leader>re", kulala.set_selected_env)
			vim.keymap.set("n", "<leader>ri", kulala.inspect)
		end,
	},
	--utilities
	{ "RRethy/vim-illuminate" },
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
		-- use opts = {} for passing setup options
		-- this is equivalent to setup({}) function
	},
	{ "windwp/nvim-ts-autotag", opts = {} },
	{ "petertriho/nvim-scrollbar", opts = {} },
	{
		"laytan/cloak.nvim",
		opts = {
			enabled = true,
			cloak_character = "*",
			-- The applied highlight group (colors) on the cloaking, see `:h highlight`.
			highlight_group = "Comment",
			patterns = {
				{
					-- Match any file starting with ".env".
					-- This can be a table to match multiple file patterns.
					file_pattern = {
						".env*",
						"wrangler.toml",
						".dev.vars",
					},
					-- Match an equals sign and any character after it.
					-- This can also be a table of patterns to cloak,
					-- example: cloak_pattern = { ":.+", "-.+" } for yaml files.
					cloak_pattern = "=.+",
				},
			},
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local function debugging()
				local status = require("dap").status()
				if string.find(status, "Running") then
					return ""
				end
				return ""
			end
			require("lualine").setup({
				options = {
					globalstatus = true,
				},
				extensions = { "nvim-dap-ui" },
				sections = {
					lualine_c = {
						{
							"filename",
							file_status = true, -- displays file status (readonly status, modified status)
							path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
						},
						{ debugging },
					},
					lualine_x = { cwd },
				},
			})
		end,
	},
	{
		"stevearc/oil.nvim",
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {},
		keys = {
			{ "<leader>n", "<cmd>Oil<cr>", desc = "NeoTree" },
		},
		-- Optional dependencies
		dependencies = {
			{
				"echasnovski/mini.icons",
				opts = {},
			},
		},
		-- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
		-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
		lazy = false,
	},
	{ -- Collection of various small independent plugins/modules
		"echasnovski/mini.nvim",
		dependencies = {
			"JoosepAlviste/nvim-ts-context-commentstring",
			opts = {
				enable_autocmd = false,
			},
		},
		config = function()
			-- Better Around/Inside textobjects
			--
			-- Examples:
			--  - va)  - [V]isually select [A]round [)]paren
			--  - yinq - [Y]ank [I]nside [N]ext [Q]uote
			--  - ci'  - [C]hange [I]nside [']quote
			require("mini.ai").setup({ n_lines = 500 })

			-- Add/delete/replace surroundings (brackets, quotes, etc.)
			--
			-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
			-- - sd'   - [S]urround [D]elete [']quotes
			-- - sr)'  - [S]urround [R]eplace [)] [']
			require("mini.surround").setup()
		end,
	},
	require("brolyn.plugins.ai"),

	-- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
	--    This is the easiest way to modularize your config.
	--
	--  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
	-- { import = 'custom.plugins' },
	--
	-- For additional information with loading, sourcing and examples see `:help lazy.nvim-🔌-plugin-spec`
}, {
	ui = {
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})

pcall(require, "brolyn.priv")

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
