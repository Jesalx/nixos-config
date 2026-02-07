return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    options = {
      globalstatus = true,
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      disabled_filetypes = { statusline = { 'snacks_dashboard' } },
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'filename' },
      lualine_c = {
        'branch',
        {
          'diff',
          symbols = { added = '+', modified = '~', removed = '-' },
        },
        {
          'diagnostics',
          symbols = { error = '󰅚 ', warn = '󰀪 ', info = '󰋽 ', hint = '󰌶 ' },
        },
      },
      lualine_x = {
        'filetype',
      },
      lualine_y = { 'progress' },
      lualine_z = { 'location' },
    },
  },
}
