local Terminal = require('toggleterm.terminal').Terminal
local lazygit  = Terminal:new({
	cmd = "lazygit",
	hidden = true,
	direction = 'float',
	float_opts = {
		border = 'curved',
	}
})
local wk       = require "which-key"
local function _lazygit_toggle()
	lazygit:toggle()
end


wk.register({
	['<leader>'] = {
		v = { _lazygit_toggle, "[v]cs" }
	}
})
