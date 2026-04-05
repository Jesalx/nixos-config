vim.pack.add({ 'https://github.com/echasnovski/mini.nvim' })

require('mini.icons').setup()
require('mini.diff').setup()
require('mini.ai').setup({ n_lines = 50, silent = true })
require('mini.pairs').setup()
require('mini.pick').setup()
require('mini.extra').setup()
require('mini.files').setup({
  mappings = {
    go_in_plus = '<CR>',
  },
  options = {
    use_as_default_explorer = true,
  },
})

vim.keymap.set('n', '<leader>e', function()
  if not MiniFiles.close() then
    MiniFiles.open(vim.api.nvim_buf_get_name(0))
  end
end, { desc = '[E]xplorer' })

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

vim.keymap.set('n', '<leader>s.', function()
  MiniExtra.pickers.oldfiles()
end, { desc = '[S]earch Recent Files (["."] for repeat)' })

vim.keymap.set('n', '<leader>sd', function()
  MiniExtra.pickers.diagnostic()
end, { desc = '[S]earch [D]iagnostics' })

vim.keymap.set('n', '<leader>sc', function()
  local files = vim.fn.systemlist('git diff --relative --name-only HEAD 2>/dev/null; git ls-files --relative --others --exclude-standard 2>/dev/null')
  if #files == 0 then
    vim.notify('No changed files', vim.log.levels.INFO)
    return
  end
  MiniPick.start({ source = { items = files, name = 'Changed Files' } })
end, { desc = '[S]earch [C]hanged Files' })

vim.keymap.set('n', '<leader>tp', function()
  vim.g.minipairs_disable = not vim.g.minipairs_disable
  vim.notify(string.format('Auto pairs %s', vim.g.minipairs_disable and 'disabled' or 'enabled'), vim.log.levels.INFO)
end, { desc = '[T]oggle Auto [P]airs' })
