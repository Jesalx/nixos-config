return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    branch = 'main', -- Use the rewritten version with new API
    config = function()
      -- Define the languages you want treesitter to support
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

      -- Install parsers using the new API (matches kickstart exactly)
      require('nvim-treesitter').install(filetypes)

      -- Enable treesitter highlighting for these filetypes
      vim.api.nvim_create_autocmd('FileType', {
        pattern = filetypes,
        callback = function()
          vim.treesitter.start()
        end,
      })
    end,
  },
}
