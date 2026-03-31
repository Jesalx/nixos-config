vim.cmd.packadd('nvim.undotree')

vim.keymap.set('n', '<leader>u', function()
  require('undotree').open({ command = '40vnew' })
end, { desc = '[U]ndo tree' })
