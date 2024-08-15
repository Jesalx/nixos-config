return {
  {
    "supermaven-inc/supermaven-nvim",
    config = function()
      require("supermaven-nvim").setup({
        keymaps = {
          accept_suggestions = "<C-y>",
          clear_suggestions = "<C-j>",
        },
        log_level = "off",
        disable_inline_completion = true,
        disable_keymaps = true,
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      table.insert(opts.sources, { name = "supermaven", group_index = 1, priority = 100 })
    end,
  },
}
