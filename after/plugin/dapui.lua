local dap = require("dap")
local dapui = require("dapui")
local wk = require "which-key"

dapui.setup()
dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end
-- dap.listeners.after.event_exited["dapui_config"] = function()
--     dapui.close()
-- end
-- dap.listeners.after.event_terminated["dapui_config"] = function()
--     dapui.close()
-- end
wk.register({
    ['<leader>'] = {
        d = {
            name = '[d]ebug',
            b = {
                function()
                    dap.toggle_breakpoint()
                end,
                "toggle [b]reakpoint"
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
        "step over"
    },
    ['<F8>'] = {
        function()
            dap.step_out()
        end,
        "step over"
    }
})
