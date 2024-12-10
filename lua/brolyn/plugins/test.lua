return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    -- "jfpedroza/neotest-elixir",
    "atm1020/neotest-jdtls"
  },
  config = function()
    require("neotest").setup({
      adapters = {
        -- require("neotest-elixir"),
        require("neotest-jdtls")
      }
    })

    vim.keymap.set('n', '<leader>to', function() require("neotest").summary.open() end)
    vim.keymap.set('n', '<leader>tr', function () require("neotest").run.run({ strategy = 'dap' }) end)
  end
}
