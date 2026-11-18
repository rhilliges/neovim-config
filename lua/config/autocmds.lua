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
        vim.treesitter.start(args.buf, "http")
    end,
})

autocmd("User", {
    group = augroup("RestDefaultHeaders", { clear = true }),
    pattern = "RestRequestPre",
    callback = function()
        local script_path = vim.fs.joinpath(vim.fn.expand("%:p:h"), "before-request.lua")
        if vim.fn.filereadable(script_path) == 0 then
            return
        end

        local env = {}
        local env_file = vim.b._rest_nvim_env_file
        if env_file then
            local ok, variables = require("rest-nvim.parser.dotenv").parse(env_file)
            assert(ok, "Could not load the selected rest.nvim environment")
            env = variables
        end

        local headers = assert(loadfile(script_path))(env)
        assert(type(headers) == "table", "before-request.lua must return a header table")
        local normalized_headers = {}
        for name, values in pairs(headers) do
            local valid_header = type(name) == "string" and type(values) == "table" and vim.islist(values)
            assert(valid_header, "Headers must have string names and lists of string values")
            for _, value in ipairs(values) do
                assert(type(value) == "string", "Header values must be strings")
            end
            normalized_headers[name:lower()] = values
        end
        _G.rest_request.headers = vim.tbl_extend("force", _G.rest_request.headers, normalized_headers)
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
