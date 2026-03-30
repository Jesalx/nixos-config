vim.schedule(function()
  vim.pack.add({ 'https://github.com/folke/which-key.nvim' })

  require('which-key').setup({
    delay = 0,
    preset = 'helix',
    icons = {
      mappings = true,
      keys = {},
    },

    spec = {
      { '<leader>s', group = '[S]earch' },
      { '<leader>t', group = '[T]oggle' },
    },
  })
end)
