vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    if ev.data.spec.name == 'nvim-treesitter' and (ev.data.kind == 'install' or ev.data.kind == 'update') then
      if not ev.data.active then
        vim.cmd.packadd('nvim-treesitter')
      end
      vim.cmd('TSUpdate')
    end
  end,
  desc = 'Run TSUpdate after install/update',
})

vim.pack.add({ { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' } })

local filetypes = {
  'bash',
  'c',
  'comment',
  'cpp',
  'diff',
  'dockerfile',
  'fish',
  'gitcommit',
  'go',
  'gomod',
  'gosum',
  'gowork',
  'graphql',
  'html',
  'javascript',
  'json',
  'json5',
  'lua',
  'luadoc',
  'markdown',
  'markdown_inline',
  'python',
  'query',
  'regex',
  'rust',
  'terraform',
  'toml',
  'tsx',
  'typescript',
  'vim',
  'vimdoc',
  'yaml',
}

require('nvim-treesitter').install(filetypes)

vim.api.nvim_create_autocmd('FileType', {
  pattern = filetypes,
  callback = function()
    vim.treesitter.start()
  end,
})
