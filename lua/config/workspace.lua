local M = {}
local state = { command = { "opencode" } }

local function set_file_staged(staged)
	local explorer = require("codediff.ui.lifecycle").get_panel_view(vim.api.nvim_get_current_tabpage())
	if not explorer or not explorer.tree then
		return
	end
	local node = explorer.tree:get_node()
	local data = node and node.data
	if not data or not data.path or data.type == "directory" or data.type == "group" then
		return
	end
	local can_stage = data.group == "unstaged" or data.group == "conflicts"
	local can_unstage = data.group == "staged"
	if (staged and can_stage) or (not staged and can_unstage) then
		require("codediff.ui.explorer").toggle_stage_entry(explorer, explorer.tree)
	end
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

local function show_agent(mode)
	hide_agent()
	state.cwd = state.cwd or vim.fn.getcwd()
	if not state.buf or not vim.api.nvim_buf_is_valid(state.buf) or vim.fn.jobwait({ state.job }, 0)[1] ~= -1 then
		if vim.fn.executable(state.command[1]) == 0 then
			vim.notify("Workspace: executable not found: " .. state.command[1], vim.log.levels.WARN)
			return
		end
		state.buf = vim.api.nvim_create_buf(false, true)
		vim.bo[state.buf].bufhidden = "hide"
		vim.b[state.buf].opencode_terminal = true
		vim.api.nvim_buf_call(state.buf, function()
			state.job = vim.fn.jobstart(state.command, { term = true, cwd = state.cwd })
		end)
		if state.job <= 0 then
			vim.notify("Workspace: could not start OpenCode", vim.log.levels.ERROR)
			return
		end
	end
	state.return_win = vim.api.nvim_get_current_win()
	if mode == "tab" then
		vim.cmd.tabnew()
		state.win = vim.api.nvim_get_current_win()
		vim.api.nvim_win_set_buf(state.win, state.buf)
	else
		state.win = vim.api.nvim_open_win(state.buf, true, window_config(mode))
	end
	state.mode = mode
	vim.wo[state.win].winbar = " OpenCode "
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
	state.diff_split = false
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

function M.open_diff()
	local split = state.mode == "split" and state.win and vim.api.nvim_win_is_valid(state.win)
	hide_agent()
	vim.cmd.stopinsert()
	state.restore_split = false
	state.cwd = state.cwd or vim.fn.getcwd()
	if state.diff_tab and vim.api.nvim_tabpage_is_valid(state.diff_tab) then
		vim.api.nvim_set_current_tabpage(state.diff_tab)
		if split then
			show_agent("split")
			vim.cmd.stopinsert()
			vim.api.nvim_set_current_win(state.return_win)
		end
		return
	end
	state.diff_split = split
	local ok, err = pcall(vim.cmd, "CodeDiff --repo " .. vim.fn.fnameescape(state.cwd))
	if not ok then
		vim.notify("Workspace: " .. tostring(err), vim.log.levels.WARN)
	end
	if split then
		show_agent("split")
	end
end

function M.setup(opts)
	state.command = (opts or {}).command or state.command
	for _, mapping in ipairs({
		{ "<leader>gd", "<M-d>", "open_diff", "Open CodeDiff" },
		{ "<leader>aa", "<M-a>", "toggle_agent", "Toggle agent overlay", "overlay" },
		{ "<leader>as", "<M-s>", "toggle_agent", "Toggle agent top split", "split" },
		{ "<leader>af", "<M-f>", "toggle_agent", "Toggle agent tab", "tab" },
	}) do
		vim.keymap.set("n", mapping[1], function()
			M[mapping[3]](mapping[5])
		end, { desc = mapping[4] })
		local argument = mapping[5] and string.format("%q", mapping[5]) or ""
		local action = "<C-\\><C-n><Cmd>lua require('config.workspace')." .. mapping[3] .. "(" .. argument .. ")<CR>"
		vim.keymap.set("t", mapping[2], action, { desc = mapping[4] })
	end
	require("codediff").setup({ keymaps = { view = { focus_explorer = "<leader>ge", toggle_stage = false } } })
	local group = vim.api.nvim_create_augroup("AgentWorkspace", { clear = true })
	vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter", "TermEnter" }, {
		group = group,
		callback = function()
			vim.cmd.redrawtabline()
		end,
	})
	vim.api.nvim_create_autocmd("User", {
		group = group,
		pattern = "CodeDiffClose",
		callback = function(event)
			local tab = event.data.tabpage
			if vim.api.nvim_tabpage_is_valid(tab) then
				vim.t[tab].codediff_view = nil
			end
			if state.diff_tab == tab then
				state.diff_tab = nil
			end
			vim.cmd.redrawtabline()
		end,
	})
	vim.api.nvim_create_autocmd("FileType", {
		group = group,
		pattern = "codediff-explorer",
		callback = function(event)
			vim.keymap.set("n", "s", function()
				set_file_staged(true)
			end, { buffer = event.buf, desc = "Stage selected file" })
			vim.keymap.set("n", "u", function()
				set_file_staged(false)
			end, { buffer = event.buf, desc = "Unstage selected file" })
		end,
	})
	vim.api.nvim_create_autocmd("User", {
		group = group,
		pattern = "CodeDiffOpen",
		callback = function(event)
			vim.t[event.data.tabpage].codediff_view = true
			vim.cmd.redrawtabline()
			if event.data.mode ~= "explorer" then
				return
			end
			local tab = event.data.tabpage
			state.diff_tab = tab
			vim.schedule(function()
				if not vim.api.nvim_tabpage_is_valid(tab) then
					return
				end
				if state.diff_split then
					hide_agent()
					vim.api.nvim_set_current_tabpage(tab)
					show_agent("split")
					vim.cmd.stopinsert()
					vim.api.nvim_set_current_win(state.return_win)
				end
				state.diff_split = false
				if state.startup_tab and vim.api.nvim_tabpage_is_valid(state.startup_tab) then
					local windows = vim.api.nvim_tabpage_list_wins(state.startup_tab)
					local buf = #windows == 1 and vim.api.nvim_win_get_buf(windows[1])
					if buf == state.startup_buf and not vim.bo[buf].modified then
						pcall(vim.cmd, vim.api.nvim_tabpage_get_number(state.startup_tab) .. "tabclose")
					end
				end
				state.startup_tab = nil
			end)
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
				state.startup_tab = vim.api.nvim_get_current_tabpage()
				state.startup_buf = vim.api.nvim_get_current_buf()
				vim.api.nvim_buf_set_lines(0, 0, -1, false, {
					"CodeDiff appears here when this repository has changes.",
					"Press <Space>gd to open it again after making changes.",
				})
				vim.bo.modified = false
				show_agent("split")
				M.open_diff()
			end)
		end,
	})
end

return M
