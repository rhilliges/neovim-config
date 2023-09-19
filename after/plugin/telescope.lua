local builtin = require('telescope.builtin')
local telescope = require('telescope')

local wk = require "which-key"
wk.register({
	["<leader>"] = {
		s = {
			name = "[s]earch",
			s = { "<cmd>Telescope lsp_workspace_symbols<cr>", "workspace symbols" },
			t = { "<cmd>Telescope live_grep<cr>", "[t]ext" },
			c = { function()
				builtin.live_grep({ default_text = vim.fn.expand('<cword>') })
			end,
				"text at [c]ursor"
			}
		},
		o = {
			name = "[o]pen",
			f = { function()
				builtin.find_files()
			end,
				"[f]ile"
			},
			r = { "<cmd>Telescope oldfiles<cr>", "[r]ecent file" },
		},
		l = {
			name = "[l]ist",
			r = { function()
				builtin.lsp_references()
			end,
				"[r]eferences"
			},
			b = { function()
				builtin.git_branches()
			end,
				"[b]ranches"
			},
		},
	}
})

telescope.setup(
-- {
--     extensions = {
--         file_browser = {
--             hijack_netrw = true
--         }
--     }
-- }
)

telescope.load_extension("ui-select")
-- telescope.load_extension("file_browser")
