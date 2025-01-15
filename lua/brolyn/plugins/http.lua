return {
    'mistweaverco/kulala.nvim',
	config = function ()
		vim.filetype.add({
		  extension = {
			['http'] = 'http',
		  },
		})
		local kulala = require"kulala"
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

	end

  -- "rest-nvim/rest.nvim"
}
