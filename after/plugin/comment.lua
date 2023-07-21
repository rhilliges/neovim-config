local wk = require "which-key"

local opts = {
	mode = "n", -- NORMAL mode
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

local vopts = {
	mode = "v", -- VISUAL mode
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

wk.register({
	f = {
		name = "[f]ormat",

		["/"] = { "<Plug>(comment_toggle_linewise_current)", "Comment toggle current line" }
	},
}, opts)

wk.register({
	f = {
		["/"] = { "<Plug>(comment_toggle_linewise_visual)", "Comment toggle current line" }
	}
}, vopts)
