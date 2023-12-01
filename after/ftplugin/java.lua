local jdtls = require "jdtls"

local home = os.getenv "HOME"
local workspace_path = home .. "/.local/share/nvim/jdtls-workspace/"
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = workspace_path .. project_name

-- Setup Capabilities
-- local capabilities = vim.lsp.common_capabilities()
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

-- Setup Testing and Debugging
local bundles = {}
local mason_path = vim.fn.glob(vim.fn.stdpath "data" .. "/mason/")
vim.list_extend(bundles, vim.split(vim.fn.glob(mason_path .. "packages/java-test/extension/server/*.jar"), "\n"))
vim.list_extend(
	bundles,
	vim.split(
		vim.fn.glob(mason_path .. "packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"),
		"\n"
	)
)

-- vim.list_extend(
--     bundles,
-- 	'com.microsoft.java.test.runner-jar-with-dependencies.jar'
-- )

-- vim.builtin.dap.active = true
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
		"--add-opens", "java.base/java.util=ALL-UNNAMED",
		"--add-opens", "java.base/java.lang=ALL-UNNAMED",
		"-javaagent:" .. home .. "/.local/share/nvim/mason/packages/jdtls/lombok.jar",
		"-jar", vim.fn.glob(home .. "/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
		"-configuration", home .. "/.local/share/nvim/mason/packages/jdtls/config_" .. "linux",
		"-data", workspace_dir,
	},
	root_dir = require("jdtls.setup").find_root { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" },
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
	require("jdtls").setup_dap({ hotcodereplace = "auto" })
	require("vim.lsp").on_attach(client, bufnr)


	local status_ok, jdtls_dap = pcall(require, "jdtls.dap")
	if status_ok then
		jdtls_dap.setup_dap_main_class_configs()
	end
end

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	pattern = { "*.java" },
	callback = function()
		local _, _ = pcall(vim.lsp.codelens.refresh)
	end,
})
jdtls.start_or_attach(config)

local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
	return
end

local opts = {
	mode = "n",  -- NORMAL mode
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

local vopts = {
	mode = "v",  -- VISUAL mode
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

local mappings = {
	r = {
		v = { "<Cmd>lua require('jdtls').extract_variable()<CR>", "extract [v]ariable" },
		c = { "<Cmd>lua require('jdtls').extract_constant()<CR>", "extract [c]onstant" },
		-- u = { "<Cmd>JdtUpdateConfig<CR>", "[u]pdate config" },
	},
	g = {
		t = { "<Cmd>lua require'jdtls.tests'.goto_subjects()<CR>", "[t]est" },
	},
	d = {
		t = { function()
			-- vim.notify('Started debugging session')
			require 'jdtls'.test_nearest_method()
		end,
			"[t]est method" },
		T = { "<Cmd>lua require'jdtls'.test_class()<CR>", "[T]est class" },

	},
	f = {
		o = { "<Cmd>lua require'jdtls'.organize_imports()<CR>", "[o]rganize imports" },
	}
}

local vmappings = {
	r = {
		v = { "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", "extract [v]ariable" },
		c = { "<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>", "extract [c]onstant" },
		m = { "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", "extract [m]ethod" },
	},
}

which_key.register(mappings, opts)
which_key.register(vmappings, vopts)
which_key.register(vmappings, vopts)
