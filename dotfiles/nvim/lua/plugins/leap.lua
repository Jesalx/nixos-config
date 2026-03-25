return {
  {
    url = 'https://codeberg.org/andyg/leap.nvim',
    config = function()
      local leap = require('leap')
      leap.opts.labels = ''
      leap.opts.safe_labels = ''

      vim.keymap.set({ 'n', 'x', 'o' }, 's', function()
        leap.leap({})
      end)
      vim.keymap.set({ 'n', 'x', 'o' }, 'S', function()
        leap.leap({ backward = true })
      end)

      vim.keymap.set({ 'n', 'x', 'o' }, ';', function()
        leap.leap({ ['repeat'] = true })
      end)
      vim.keymap.set({ 'n', 'x', 'o' }, ',', function()
        leap.leap({ ['repeat'] = true, backward = true })
      end)
    end,
  },
}
