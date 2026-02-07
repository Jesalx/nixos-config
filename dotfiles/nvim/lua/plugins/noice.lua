return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  opts = {
    lsp = {
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
        ['cmp.entry.get_documentation'] = true,
      },
    },
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
      lsp_doc_border = true,
    },
    views = {
      cmdline_popup = {
        border = {
          style = 'rounded',
        },
      },
      popupmenu = {
        border = {
          style = 'rounded',
        },
      },
      confirm = {
        border = {
          style = 'rounded',
        },
      },
    },
  },
  dependencies = {
    'MunifTanjim/nui.nvim',
  },
}
