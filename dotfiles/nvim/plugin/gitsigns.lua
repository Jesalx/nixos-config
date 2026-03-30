vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
  once = true,
  callback = function()
    vim.pack.add({ 'https://github.com/lewis6991/gitsigns.nvim' })

    require('gitsigns').setup({
      signcolumn = false,
      numhl = false,
      linehl = false,
      signs = {},
      signs_staged_enable = false,
      word_diff = false,
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 0,
        virt_text_pos = 'eol',
      },
    })
  end,
})

vim.keymap.set('n', '<leader>tb', '<cmd>Gitsigns toggle_current_line_blame<cr>', { desc = '[T]oggle Git [B]lame' })
