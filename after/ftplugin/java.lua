-- TODO make sure to install jdtls and java-debug-adapter with mason!
local jdtls = require("jdtls")

local home = os.getenv("HOME")
local workspace_path = home .. "/.local/share/nvim/jdtls-workspace/"
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = workspace_path .. project_name

-- Setup Capabilities
local capabilities = require("blink.cmp").get_lsp_capabilities()
local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

-- Setup Testing and Debugging
local bundles = {}
local mason_path = vim.fn.glob(vim.fn.stdpath("data") .. "/mason/")
vim.list_extend(bundles, vim.split(vim.fn.glob(mason_path .. "packages/java-test/extension/server/*.jar"), "\n"))
vim.list_extend(
	bundles,
	vim.split(
		vim.fn.glob(mason_path .. "packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"),
		"\n"
	)
)

local config = {
	cmd = {
		"java",
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-Xms6000m",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",
		"-javaagent:" .. home .. "/.local/share/nvim/mason/packages/jdtls/lombok.jar",
		"-jar",
		vim.fn.glob(home .. "/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
		"-configuration",
		home .. "/.local/share/nvim/mason/packages/jdtls/config_" .. "linux",
		"-data",
		workspace_dir,
	},
	root_dir = require("jdtls.setup").find_root({ ".git", "pom.xml" }),
	capabilities = capabilities,

	settings = {
		java = {
			eclipse = {
				downloadSources = true,
			},
			configuration = {
				updateBuildConfiguration = "interactive",
				runtimes = {
					{
						name = "JavaSE-1.8",
						path = "~/.sdkman/candidates/java/8.0.392-librca",
					},
					{
						name = "JavaSE-11",
						path = "~/.sdkman/candidates/java/11.0.21-ms",
					},
					{
						name = "JavaSE-17",
						path = "~/.sdkman/candidates/java/17.0.8-ms",
					},
				},
			},
			maven = {
				downloadSources = true,
			},
			implementationsCodeLens = {
				enabled = true,
			},
			referencesCodeLens = {
				enabled = true,
			},
			references = {
				includeDecompiledSources = true,
			},
			inlayHints = {
				parameterNames = {
					enabled = "all", -- literals, all, none
				},
			},
			format = {
				enabled = true,
			},
			sources = {
				organizeImports = {
					starThreshold = 9999,
					staticStarThreshold = 9999,
				},
			},
		},
		signatureHelp = { enabled = true },
		extendedClientCapabilities = extendedClientCapabilities,
	},
	init_options = {
		bundles = bundles,
	},
}

config["on_attach"] = function(client, bufnr)
	local _, _ = pcall(vim.lsp.codelens.refresh)
	jdtls.setup_dap({
		hotcodereplace = "auto",
		verbose = true,
		config_overrides = {
			args = "--spring.profiles.active=local",
		},
	})

	-- vim.lsp.buf_on_attach(client, bufnr)

	local status_ok, jdtls_dap = pcall(require, "jdtls.dap")
	if status_ok then
		jdtls_dap.setup_dap_main_class_configs()
	end

	vim.keymap.set("n", "gt", require("jdtls.tests").goto_subjects)

	-- vim.keymap.set("n", "<leader>mu", jdtls.update_project_config)
	vim.keymap.set("n", "<leader>mU", jdtls.update_projects_config)
	vim.keymap.set("n", "<leader>mb", function()
		jdtls.build_projects()
	end)
	vim.keymap.set("n", "<leader>mc", function()
		jdtls.compile()
	end)

	vim.keymap.set("n", "<leader>dt", function()
		vim.notify("Started debugging test")
		jdtls.test_nearest_method()
	end)
	vim.keymap.set("n", "<leader>dT", function()
		vim.notify("Started debugging tests in current class")
		jdtls.test_class()
	end)
	vim.keymap.set("n", "<leader>ro", function()
		jdtls.organize_imports()
	end)
	vim.keymap.set("n", "<leader>rv", function()
		jdtls.extract_variable()
	end)
	vim.keymap.set("n", "<leader>rV", function()
		jdtls.extract_variable_all()
	end)
	vim.keymap.set("n", "<leader>rc", function()
		jdtls.extract_constant()
	end)
	vim.keymap.set("v", "<leader>rv", function()
		jdtls.extract_variable({ visual = true})
	end)
	vim.keymap.set("v", "<leader>rV", function()
		jdtls.extract_variable_all({ visual = true})
	end)
	vim.keymap.set("v", "<leader>rc", function()
		jdtls.extract_constant({ visual = true})
	end)
	vim.keymap.set("v", "<leader>rm", function()
		jdtls.extract_method({ visual = true })
	end)
end

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	pattern = { "*.java" },
	callback = function()
		local _, _ = pcall(vim.lsp.codelens.refresh)
	end,
})
jdtls.start_or_attach(config)
