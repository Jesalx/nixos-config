return {
  'f-person/git-blame.nvim',
  event = 'VeryLazy',
  opts = {
    message_template = '  <author> • <date> • <summary>',
    date_format = '%r', -- Relative time (e.g., "3 days ago")
    delay = 0,
    highlight_group = 'GitBlame',
    set_extmark_options = {
      priority = 10000, -- High priority to appear as last virtual text
    },
  },
  keys = {
    { '<leader>tb', '<cmd>GitBlameToggle<CR>', desc = '[T]oggle Git [B]lame' },
  },
}
