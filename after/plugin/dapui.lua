local dap = require("dap")
local dapui = require("dapui")
local wk = require "which-key"

dapui.setup({
	layouts = {
		{
			elements = {
				-- "repl"
				{ id = "console", size = 0.35 },
				{ id = "repl",   size = 0.65 },
			},
			size = 0.3,
			position = "bottom", -- Can be "bottom" or "top"
		},
		{
			elements = {
				{ id = "scopes",  size = 0.25 },
				{ id = "stacks",  size = 0.25 },
				{ id = "watches", size = 0.25 },
			},
			size = 40,
			position = "right", -- Can be "left" or "right"
		},
	}
})
-- dap.listeners.after.event_initialized["dapui_config"] = function()
--     dapui.open()
-- end
-- dap.listeners.after.event_exited["dapui_config"] = function()
--     dapui.close()
-- end
-- dap.listeners.after.event_terminated["dapui_config"] = function()
--     dapui.close()
-- end
local dap_opt = { position = 'center', width = 120 }
wk.register({
	['<leader>'] = {
		d = {
			name = '[d]ebug',
			b = {
				function()
					dap.toggle_breakpoint()
				end,
				"toggle [b]reakpoint"
			},
			w = {
				function()
					require("dapui").float_element('watches', dap_opt)
				end,
				"show [w]atches"
			},
			s = {
				function()
					require("dapui").float_element('stacks', dap_opt)
				end,
				"show [s]tacks"
			},
			r = {
				function()
					require("dapui").float_element('repl', dap_opt)
				end,
				"show [r]epl"
			},
			c = {
				function()
					require("dapui").float_element('console', dap_opt)
				end,
				"show [c]onsole"
			},
			u = {
				function()
					dapui.toggle()
				end,
				"toggle [u]i"
			}
		}
	},
	['<F5>'] = {
		function()
			dap.continue()
		end,
		"start/continue debugging"
	},
	['<F6>'] = {
		function()
			dap.step_over()
		end,
		"step over"
	},
	['<F7>'] = {
		function()
			dap.step_into()
		end,
		"step into"
	},
	['<F8>'] = {
		function()
			dap.step_out()
		end,
		"step out"
	}
})
