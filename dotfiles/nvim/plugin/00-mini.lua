vim.pack.add({ 'https://github.com/echasnovski/mini.nvim' })

require('mini.icons').setup()
require('mini.diff').setup()
require('mini.ai').setup({ n_lines = 50 })
require('mini.pairs').setup()

-- Snacks loads after mini alphabetically (00-mini < 00-snacks),
-- so defer the toggle registration until all plugin/ files are sourced
vim.schedule(function()
  Snacks.toggle({
    name = 'Auto Pairs',
    get = function()
      return not vim.g.minipairs_disable
    end,
    set = function(state)
      vim.g.minipairs_disable = not state
    end,
  }):map('<leader>tp')
end)
