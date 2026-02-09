return {
  'lewis6991/gitsigns.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  opts = {
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
  },
  keys = {
    { '<leader>tb', '<cmd>Gitsigns toggle_current_line_blame<cr>', desc = '[T]oggle Git [B]lame' },
  },
}
