local M = {}
local state = { command = { "opencode" } }

local function session_cache_path(directory)
	directory = vim.uv.fs_realpath(directory) or directory
	return vim.fn.stdpath("state") .. "/opencode-sessions/" .. vim.fn.sha256(directory)
end

local function hide_agent()
	local tab = vim.api.nvim_get_current_tabpage()
	local agent_tab = state.mode == "tab"
	local focused = state.win == vim.api.nvim_get_current_win()
	if state.win and vim.api.nvim_win_is_valid(state.win) then
		local closed = pcall(vim.api.nvim_win_close, state.win, true)
		if not closed then
			vim.api.nvim_win_set_buf(state.win, vim.api.nvim_create_buf(true, false))
		end
	end
	state.win = nil
	state.mode = nil
	local return_valid = state.return_win and vim.api.nvim_win_is_valid(state.return_win)
	local same_tab = return_valid and vim.api.nvim_win_get_tabpage(state.return_win) == tab
	if focused and return_valid and (agent_tab or same_tab) then
		vim.api.nvim_set_current_win(state.return_win)
	end
end

local function window_config(mode)
	local tabs_visible = vim.o.showtabline == 2 or (vim.o.showtabline == 1 and #vim.api.nvim_list_tabpages() > 1)
	local top = tabs_visible and 1 or 0
	local height =
		math.max(1, vim.o.lines - vim.o.cmdheight - (vim.o.laststatus > 0 and 1 or 0) - top)
	if mode == "split" then
		return { split = "above", win = -1, height = math.max(1, math.floor(height * 0.4)) }
	end
	local width = math.max(1, math.floor(vim.o.columns * 0.9))
	local float_height = math.max(1, math.floor(height * 0.85))
	return {
		relative = "editor",
		row = top + math.floor((height - float_height) / 2),
		col = math.floor((vim.o.columns - width) / 2),
		width = width,
		height = float_height,
		border = "rounded",
		style = "minimal",
		zindex = 60,
	}
end

local function show_agent(mode, use_current_window)
	hide_agent()
	state.cwd = state.cwd or vim.fn.getcwd()
	if not state.buf or not vim.api.nvim_buf_is_valid(state.buf) or vim.fn.jobwait({ state.job }, 0)[1] ~= -1 then
		if vim.fn.executable(state.command[1]) == 0 then
			vim.notify("Workspace: executable not found: " .. state.command[1], vim.log.levels.WARN)
			return
		end
		local command = vim.deepcopy(state.command)
		local path = vim.fn.stdpath("config") .. "/agent-instructions.md"
		local instructions = table.concat(vim.fn.readfile(path), "\n")
		local directory = vim.uv.fs_realpath(state.cwd) or state.cwd
		local cache_path = session_cache_path(directory)
		local cached = vim.fn.filereadable(cache_path) == 1 and vim.fn.readfile(cache_path)[1] or nil
		local result = vim.system({
			"opencode", "api", "post", "/api/session", "--data",
			vim.json.encode({ id = cached, location = { directory = directory } }),
		}, { text = true, cwd = state.cwd, timeout = 10000 }):wait()
		local ok, response = pcall(vim.json.decode, result.stdout or "")
		local session = ok and type(response) == "table" and response.data and response.data.id
		if result.code ~= 0 or not session then
			vim.notify("Workspace: could not create or reattach OpenCode session", vim.log.levels.ERROR)
			return
		end
		vim.fn.mkdir(vim.fn.fnamemodify(cache_path, ":h"), "p", 448)
		vim.fn.writefile({ session }, cache_path)
		result = vim.system({
			"opencode", "api", "put",
			"/api/experimental/session/" .. session .. "/instructions/entries/nvim",
			"--data", vim.json.encode({ value = instructions }),
		}, { text = true, cwd = state.cwd, timeout = 10000 }):wait()
		if result.code ~= 0 then
			vim.notify("Workspace: could not load OpenCode instructions", vim.log.levels.ERROR)
			return
		end
		vim.list_extend(command, { "--session", session })
		state.buf = vim.api.nvim_create_buf(false, true)
		vim.bo[state.buf].bufhidden = "hide"
		vim.b[state.buf].opencode_terminal = true
		vim.api.nvim_buf_call(state.buf, function()
			state.job = vim.fn.jobstart(command, { term = true, cwd = state.cwd })
		end)
		if state.job <= 0 then
			vim.notify("Workspace: could not start OpenCode", vim.log.levels.ERROR)
			return
		end
	end
	state.return_win = vim.api.nvim_get_current_win()
	if mode == "tab" then
		if not use_current_window then
			vim.cmd.tabnew()
		end
		state.win = vim.api.nvim_get_current_win()
		vim.api.nvim_win_set_buf(state.win, state.buf)
	else
		state.win = vim.api.nvim_open_win(state.buf, true, window_config(mode))
	end
	state.mode = mode
	vim.wo[state.win].winbar = ""
	vim.wo[state.win].scrollbind = false
	vim.wo[state.win].list = false
	vim.wo[state.win].number = false
	vim.wo[state.win].relativenumber = false
	vim.wo[state.win].signcolumn = "no"
	vim.wo[state.win].statuscolumn = ""
	vim.cmd.startinsert()
end

function M.toggle_agent(mode)
	mode = mode or "overlay"
	local visible = state.win and vim.api.nvim_win_is_valid(state.win)
	local same_tab = visible and vim.api.nvim_win_get_tabpage(state.win) == vim.api.nvim_get_current_tabpage()
	if visible and state.mode == "tab" and mode == "tab" and not same_tab then
		vim.api.nvim_set_current_win(state.win)
		vim.cmd.startinsert()
		return
	end
	if same_tab and state.mode == mode then
		local restore_split = state.restore_split
		hide_agent()
		state.restore_split = false
		if restore_split and mode ~= "split" then
			show_agent("split")
		end
		return
	end
	state.restore_split = mode ~= "split" and same_tab and (state.mode == "split" or state.restore_split)
	show_agent(mode)
end

function M.reset_agent()
	local mode = state.mode or "overlay"
	local cache_path = session_cache_path(state.cwd or vim.fn.getcwd())
	if vim.fn.filereadable(cache_path) == 1 and vim.fn.delete(cache_path) ~= 0 then
		vim.notify("Workspace: could not clear OpenCode session cache", vim.log.levels.ERROR)
		return
	end
	hide_agent()
	if state.job and vim.fn.jobwait({ state.job }, 0)[1] == -1 then
		vim.fn.jobstop(state.job)
	end
	if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
		vim.api.nvim_buf_delete(state.buf, { force = true })
	end
	state.buf = nil
	state.job = nil
	show_agent(mode)
end

function M.setup(opts)
	state.command = (opts or {}).command or state.command
	for _, mapping in ipairs({
		{ "<leader>aa", "<M-a>", "toggle_agent", "Toggle agent overlay", "overlay" },
		{ "<leader>as", "<M-s>", "toggle_agent", "Toggle agent top split", "split" },
		{ "<leader>af", "<M-f>", "toggle_agent", "Toggle agent tab", "tab" },
		{ "<leader>ar", "<M-r>", "reset_agent", "Reset agent session" },
	}) do
		vim.keymap.set("n", mapping[1], function()
			M[mapping[3]](mapping[5])
		end, { desc = mapping[4] })
		local argument = mapping[5] and string.format("%q", mapping[5]) or ""
		local action = "<C-\\><C-n><Cmd>lua require('config.workspace')." .. mapping[3] .. "(" .. argument .. ")<CR>"
		vim.keymap.set("t", mapping[2], action, { desc = mapping[4] })
	end
	local group = vim.api.nvim_create_augroup("AgentWorkspace", { clear = true })
	vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter", "TermEnter" }, {
		group = group,
		callback = function()
			vim.cmd.redrawtabline()
		end,
	})
	vim.api.nvim_create_autocmd("VimResized", {
		group = group,
		callback = function()
			if state.mode ~= "tab" and state.win and vim.api.nvim_win_is_valid(state.win) then
				local config = window_config(state.mode)
				if state.mode == "split" then
					vim.api.nvim_win_set_height(state.win, config.height)
				else
					config.style = nil
					vim.api.nvim_win_set_config(state.win, config)
				end
			end
		end,
	})
	vim.api.nvim_create_autocmd("VimEnter", {
		group = group,
		once = true,
		callback = function()
			local bare = vim.fn.argc() == 0 and not vim.o.diff and vim.bo.buftype == ""
			local empty = vim.api.nvim_buf_get_name(0) == "" and not vim.bo.modified
			if not bare or not empty or #vim.api.nvim_list_uis() == 0 then
				return
			end
			vim.schedule(function()
				local untouched = vim.api.nvim_buf_get_name(0) == "" and not vim.bo.modified
				if not untouched or vim.bo.buftype ~= "" then
					return
				end
				show_agent("tab", true)
			end)
		end,
	})
end

return M
