local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Highlight on yank
autocmd('TextYankPost', {
  group = augroup('highlight_yank', { clear = true }),
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

vim.api.nvim_create_autocmd("FileType", {
    pattern = "http",
    callback = function(args)
        vim.treesitter.start(args.buf, "kulala_http")
    end,
})

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


