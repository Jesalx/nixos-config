return {
  {
    "swaits/lazyjj.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("lazyjj").setup()
      vim.keymap.set("n", "<leader>jj", "<cmd>LazyJJ<cr>", { desc = "Open LazyJJ" })
    end,
  },
}
