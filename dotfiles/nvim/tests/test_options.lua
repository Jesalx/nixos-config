local t = require('helpers')

t.describe('options', function()
  t.it('sets leader to space', function()
    t.eq(vim.g.mapleader, ' ')
    t.eq(vim.g.maplocalleader, ' ')
  end)

  t.it('enables line numbers', function()
    t.eq(vim.opt.number:get(), true)
    t.eq(vim.opt.relativenumber:get(), true)
  end)

  t.it('uses global statusline', function()
    t.eq(vim.opt.laststatus:get(), 3)
  end)

  t.it('hides native command line', function()
    t.eq(vim.opt.cmdheight:get(), 0)
  end)

  t.it('uses 4-space indentation', function()
    t.eq(vim.opt.expandtab:get(), true)
    t.eq(vim.opt.tabstop:get(), 4)
    t.eq(vim.opt.shiftwidth:get(), 4)
    t.eq(vim.opt.softtabstop:get(), 4)
  end)

  t.it('enables smart case search', function()
    t.eq(vim.opt.ignorecase:get(), true)
    t.eq(vim.opt.smartcase:get(), true)
  end)

  t.it('keeps signcolumn visible', function()
    t.eq(vim.opt.signcolumn:get(), 'yes')
  end)

  t.it('opens splits right and below', function()
    t.eq(vim.opt.splitright:get(), true)
    t.eq(vim.opt.splitbelow:get(), true)
  end)

  t.it('enables persistent undo', function()
    t.eq(vim.opt.undofile:get(), true)
  end)

  t.it('sets scrolloff to 10', function()
    t.eq(vim.opt.scrolloff:get(), 10)
  end)

  t.it('uses ripgrep for :grep', function()
    t.eq(vim.opt.grepprg:get(), 'rg --vimgrep')
  end)

  t.it('enables live substitution preview', function()
    t.eq(vim.opt.inccommand:get(), 'split')
  end)

  t.it('rounds indent to shiftwidth', function()
    t.eq(vim.opt.shiftround:get(), true)
  end)
end)
