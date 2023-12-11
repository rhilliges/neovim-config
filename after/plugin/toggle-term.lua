local Terminal = require('toggleterm.terminal').Terminal
local lazygit  = Terminal:new({
	cmd = "lazygit",
	hidden = true,
	direction = 'float',
})
local wk       = require "which-key"
local function _lazygit_toggle()
	lazygit:toggle()
end

local t        = Terminal:new({
	hidden = true,
	direction = 'horizontal',
})

wk.register({
	['<leader>'] = {
		v = { _lazygit_toggle, "[v]cs" },
		o = {
			t = {
				function()
					if not t:is_open() then
						t:open()
					end
				end,
				"[t]erminal"
			}
		},
		c = {
			t = {
				function ()
					if t:is_open() then
						t:close()
					end
				end,
				"[t]erminal"
			}
		}
	}
});
function _G.set_terminal_keymaps()
	local opts = { buffer = 0 }
	vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
	vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
	vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
	vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
	vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
	vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
	vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
