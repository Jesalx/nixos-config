return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-neotest/nvim-nio",
    "nvim-neotest/neotest-go",
    "nvim-neotest/neotest-python",
  },
  keys = {
    { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run tests in current file" },
    { "<leader>ta", function() require("neotest").run.run(vim.fn.getcwd()) require("neotest").summary.open() end, desc = "Run all tests and show results" },
    { "<leader>tt", function() require("neotest").summary.toggle() end, desc = "Toggle test results" },
  },
  cmd = { "Neotest" },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-python"),
        require("neotest-go")({
          experimental = {
            test_table = true,
          },
          args = { "-count=1", "-timeout=60s", "-race" },
          recursive_run = true,
        }),
      },
    })
  end,
}
