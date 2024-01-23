local dap = require("dap")
local dapui = require("dapui")

dapui.setup({
	layouts = {
		{
			elements = {
				-- "repl"
				{ id = "console", size = 0.35 },
				{ id = "repl",    size = 0.65 },
			},
			size = 0.25,
			position = "bottom", -- Can be "bottom" or "top"
		},
		{
			elements = {
				{ id = "scopes",  size = 0.25 },
				{ id = "stacks",  size = 0.25 },
				{ id = "watches", size = 0.25 },
			},
			size = 30,
			position = "left", -- Can be "left" or "right"
		},
	}
})

local dap_opt = { position = 'center', width = 120 }
vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint)
vim.keymap.set("n", "<F5>", dap.continue)
vim.keymap.set("n", "<F6>", dap.step_over)
vim.keymap.set("n", "<F7>", dap.step_into)
vim.keymap.set("n", "<F8>", dap.step_out)
vim.keymap.set("n", "<leader>du", dapui.toggle)
vim.keymap.set("n", "<leader>dc", function()
	dapui.float('console')
end)