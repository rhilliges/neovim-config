local map = vim.keymap.set

map('n', '<Esc>', '<cmd>nohlsearch<CR>')

map("n", "<leader>w", ":wa<CR>:lua vim.notify 'Saved all files'<CR>")
map("n", "<A-k>", ":m .-2<CR>==")
map("n", "<A-j>", ":m .+1<CR>==")
map("n", "p", '"0p')
map("n", "P", '"0P')
map("n", "Q", "<nop>")
map("v", "<leader>y", '"+y')
map("v", "<A-j>", ":m '>+1<CR>gv=gv")
map("v", "<A-k>", ":m '<-2<CR>gv=gv")

map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })



-- See `:help telescope.builtin`
local telescope = require("telescope.builtin")
map("n", "<leader>sh", telescope.help_tags, { desc = "[S]earch [H]elp" })
map("n", "<leader>sk", telescope.keymaps, { desc = "[S]earch [K]eymaps" })
map("n", "<leader>sf", telescope.find_files, { desc = "[S]earch [F]iles" })
map("n", "<leader>ss", telescope.builtin, { desc = "[S]earch [S]elect Telescope" })
map("n", "<leader>sw", telescope.grep_string, { desc = "[S]earch current [W]ord" })
map("n", "<leader>st", telescope.live_grep, { desc = "[S]earch by [G]rep" })
map("n", "<leader>sd", telescope.diagnostics, { desc = "[S]earch [D]iagnostics" })
map("n", "<leader>sr", telescope.resume, { desc = "[S]earch [R]esume" })
map("n", "<leader>s.", telescope.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
map("n", "<leader><leader>", telescope.buffers, { desc = "[ ] Find existing buffers" })
map("n", "<leader>sb", telescope.git_branches)
map("n", "<leader>sc", telescope.git_commits)
map("n","<F2>", vim.lsp.buf.rename)
map("n","<leader>lr", "<CMD>Glance references<CR>")
map("n","gd", telescope.lsp_definitions)
map("n","gD", vim.lsp.buf.declaration)
map("n","gI", telescope.lsp_implementations)
map("n","<leader>la", vim.lsp.buf.code_action)
map("n","<leader>ls", telescope.lsp_document_symbols)
map("n","<leader>lS", telescope.lsp_dynamic_workspace_symbols)
map("n","<leader>lt", telescope.lsp_type_definitions)



map("n", "<leader>n", "<cmd>Oil<CR>")


local harpoon = require("harpoon")

map("n", "<leader>p", function()
	harpoon:list():add()
end)

map("n", "<leader>e", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end)

map("n", "<leader>1", function()
	harpoon:list():select(1)
end)

map("n", "<leader>2", function()
	harpoon:list():select(2)
end)

map("n", "<leader>3", function()
	harpoon:list():select(3)
end)

map("n", "<leader>4", function()
	harpoon:list():select(4)
end)

map("n", "<leader>5", function()
	harpoon:list():select(5)
end)

map("n", "<leader>6", function()
	harpoon:list():select(6)
end)

map("n", "<leader>7", function()
	harpoon:list():select(7)
end)

map("n", "<leader>8", function()
	harpoon:list():select(8)
end)

map("n", "<leader>9", function()
	harpoon:list():select(9)
end)

map("n", "<leader>0", function()
	harpoon:list():select(0)
end)

map("n", "<leader>f", function()
	require("conform").format({ async = true, lsp_format = "fallback" })
end)

map("n", "<leader>gs", function()
	vim.cmd.Git()
	vim.cmd("wincmd o")
end)

local dap = require("dap")
map("n", "<leader>dp", function()
	vim.notify("Debugging with previous config")
	dap.run_last()
end)
map("n", "<leader>db", dap.toggle_breakpoint)
map("n", "<F5>", dap.continue)
map("n", "<F6>", dap.step_over)
map("n", "<F7>", dap.step_into)
map("n", "<F8>", dap.step_out)
map("n", "<leader>du", "<CMD>DapViewToggle<CR>")
map("n", "<leader>dc", function()
	dapui.float_element("console", {
		width = 150,
		height = 80,
		position = "center",
	})
end)

local kulala = require("kulala")
map("n", "<leader>rr", kulala.run)
map("n", "<leader>rs", kulala.search)
map("n", "<leader>rS", kulala.show_stats)
map("n", "<leader>rt", kulala.toggle_view)
map("n", "<leader>rn", kulala.jump_next)
map("n", "<leader>rp", kulala.jump_prev)
map("n", "<leader>re", kulala.set_selected_env)
map("n", "<leader>ri", kulala.inspect)

