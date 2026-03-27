-- Toggle relative line numbers based on mode and focus
local line_numbers_group = vim.api.nvim_create_augroup('jesal/toggle_line_numbers', {})
vim.api.nvim_create_autocmd({ 'BufEnter', 'FocusGained', 'CmdlineLeave', 'WinEnter' }, {
  group = line_numbers_group,
  desc = 'Toggle relative line numbers on',
  callback = function()
    if vim.wo.nu and not vim.startswith(vim.api.nvim_get_mode().mode, 'i') then
      vim.wo.relativenumber = true
    end
  end,
})
vim.api.nvim_create_autocmd({ 'BufLeave', 'FocusLost', 'CmdlineEnter', 'WinLeave' }, {
  group = line_numbers_group,
  desc = 'Toggle relative line numbers off',
  callback = function(args)
    if vim.wo.nu then
      vim.wo.relativenumber = false
    end

    -- Redraw here to avoid having to first write something for the line numbers to update.
    if args.event == 'CmdlineEnter' then
      if not vim.tbl_contains({ '@', '-' }, vim.v.event.cmdtype) then
        vim.cmd.redraw()
      end
    end
  end,
})

-- Auto-reload files changed outside of Neovim
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
  group = vim.api.nvim_create_augroup('jesal/checktime', {}),
  desc = 'Reload files changed outside of Neovim',
  callback = function()
    if vim.fn.getcmdwintype() == '' then
      vim.cmd.checktime()
    end
  end,
})

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('jesal/highlight_yank', {}),
  callback = function()
    vim.highlight.on_yank()
  end,
})


-- Close certain filetypes with 'q'
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('jesal/close_with_q', {}),
  desc = 'Close with <q>',
  pattern = {
    'git',
    'godoc',
    'help',
    'man',
    'qf',
    'scratch',
  },
  callback = function(args)
    if args.match ~= 'help' or not vim.bo[args.buf].modifiable then
      vim.keymap.set('n', 'q', '<cmd>quit<cr>', { buffer = args.buf })
    end
  end,
})
