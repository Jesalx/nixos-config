vim.pack.add({ 'https://github.com/echasnovski/mini.nvim' })

require('mini.icons').setup()
require('mini.diff').setup()
require('mini.ai').setup({ n_lines = 50 })
require('mini.pairs').setup()
require('mini.pick').setup()
require('mini.extra').setup()

-- Picker keymaps

vim.keymap.set('n', '<leader><leader>', function()
  MiniPick.builtin.files()
end, { desc = '[ ] Search Files' })

vim.keymap.set('n', '<leader>/', function()
  MiniPick.builtin.grep_live()
end, { desc = '[/] Search by Grep' })

vim.keymap.set('n', '<leader>sh', function()
  MiniPick.builtin.help()
end, { desc = '[S]earch [H]elp' })

vim.keymap.set('n', '<leader>sk', function()
  MiniExtra.pickers.keymaps()
end, { desc = '[S]earch [K]eymaps' })

vim.keymap.set('n', '<leader>sf', function()
  MiniPick.builtin.files()
end, { desc = '[S]earch [F]iles' })

vim.keymap.set('n', '<leader>s.', function()
  MiniExtra.pickers.oldfiles()
end, { desc = '[S]earch Recent Files (["."] for repeat)' })

vim.keymap.set('n', '<leader>sd', function()
  MiniExtra.pickers.diagnostic()
end, { desc = '[S]earch [D]iagnostics' })

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
