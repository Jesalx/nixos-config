return {
  {
    url = 'https://codeberg.org/andyg/leap.nvim',
    config = function()
      local leap = require('leap')
      leap.opts.labels = ''
      leap.opts.safe_labels = ''

      local function silent_leap(opts)
        local orig_echo = vim.api.nvim_echo
        vim.api.nvim_echo = function() end ---@diagnostic disable-line: duplicate-set-field
        local ok, err = pcall(leap.leap, opts)
        vim.api.nvim_echo = orig_echo
        if not ok then
          error(err)
        end
      end

      vim.keymap.set({ 'n', 'x', 'o' }, 's', function()
        silent_leap({})
      end)
      vim.keymap.set({ 'n', 'x', 'o' }, 'S', function()
        silent_leap({ backward = true })
      end)

      vim.keymap.set({ 'n', 'x', 'o' }, ';', function()
        silent_leap({ ['repeat'] = true })
      end)
      vim.keymap.set({ 'n', 'x', 'o' }, ',', function()
        silent_leap({ ['repeat'] = true, backward = true })
      end)
    end,
  },
}
