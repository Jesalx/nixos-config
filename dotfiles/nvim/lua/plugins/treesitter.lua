return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    config = function()
      local filetypes = {
        'bash',
        'c',
        'comments',
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
        'nix',
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
    end,
  },
}
