return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    config = function()
      local filetypes = {
        'bash',
        'c',
        'diff',
        'dockerfile',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
        'go',
        'gomod',
        'gowork',
        'gosum',
        'yaml',
        'terraform',
        'regex',
        'nix',
        'rust',
      }

      require('nvim-treesitter').install(filetypes)

      vim.api.nvim_create_autocmd('FileType', {
        pattern = filetypes,
        callback = function()
          vim.treesitter.start()
        end,
      })
    end,
  },
}
