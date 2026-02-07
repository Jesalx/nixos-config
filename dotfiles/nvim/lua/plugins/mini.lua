return {
  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup({ n_lines = 50 })
      require('mini.pairs').setup()
    end,
  },
}
