-- Plugin hooks must be defined before the first vim.pack.add() call
-- (plugin/ files are sourced after init.lua, so this ordering is guaranteed)
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == 'nvim-treesitter' and (kind == 'install' or kind == 'update') then
      if not ev.data.active then
        vim.cmd.packadd('nvim-treesitter')
      end
      vim.cmd('TSUpdate')
    end

    -- Build blink.cmp's Rust fuzzy matcher from source after install/update
    if name == 'blink.cmp' and (kind == 'install' or kind == 'update') then
      vim.system({ 'cargo', 'build', '--release' }, { cwd = ev.data.path }):wait()
    end
  end,
  desc = 'Post-install/update hooks for plugins',
})

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

-- Enable spell checking for prose filetypes
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('jesal/spell', {}),
  desc = 'Enable spell checking for prose filetypes',
  pattern = { 'gitcommit', 'markdown', 'plaintex', 'tex', 'text' },
  callback = function()
    local spellfile = vim.fn.stdpath('config') .. '/spell/en.utf-8.add'
    vim.opt_local.spell = true
    vim.opt_local.spellfile = spellfile

    -- Recompile the custom word list when the .add file is newer than the .spl
    local add_stat = vim.uv.fs_stat(spellfile)
    local spl_stat = vim.uv.fs_stat(spellfile .. '.spl')
    if add_stat and (not spl_stat or add_stat.mtime.sec > spl_stat.mtime.sec) then
      vim.cmd.mkspell({ spellfile, bang = true, mods = { silent = true } })
    end
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
