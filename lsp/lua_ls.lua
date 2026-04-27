local root_markers1 = {
	".emmyrc.json",
	".luarc.json",
	".luarc.jsonc",
}
local root_markers2 = {
	".luacheckrc",
	".stylua.toml",
	"stylua.toml",
	"selene.toml",
	"selene.yml",
}

return {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = vim.fn.has("nvim-0.11.3") == 1 and { root_markers1, root_markers2, { ".git" } }
		or vim.list_extend(vim.list_extend(root_markers1, root_markers2), { ".git" }),
	settings = {
		Lua = {
			-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
			-- diagnostics = { disable = { 'missing-fields' } },
			completion = {
				callSnippet = "Replace",
			},
			codeLens = { enable = true },
			hint = { enable = true, semicolon = "Disable" },
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = {
					"vim",
					"require",
				},
			},
		},
	},
}
