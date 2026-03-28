return {
  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.icons').setup()
      require('mini.diff').setup()
      require('mini.ai').setup({ n_lines = 50 })
      require('mini.pairs').setup()

      Snacks.toggle({
        name = 'Auto Pairs',
        get = function()
          return not vim.g.minipairs_disable
        end,
        set = function(state)
          vim.g.minipairs_disable = not state
        end,
      }):map('<leader>tp')
    end,
  },
}
