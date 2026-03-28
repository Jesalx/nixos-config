return {
  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format({ async = true, lsp_format = 'fallback' })
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        if not vim.g.autoformat then
          return nil
        end
        return { timeout_ms = 500, lsp_format = 'fallback' }
      end,

      formatters = {
        gofumpt = {
          prepend_args = { '-extra' },
        },
      },
      formatters_by_ft = {
        lua = { 'stylua' },
        go = { 'goimports', 'gofumpt' },
        python = { 'ruff_fix', 'ruff_format' },
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        typescript = { 'prettierd', 'prettier', stop_after_first = true },
        yaml = { 'yamlfmt' },
        json = { 'prettier' },
        markdown = { 'prettier' },
        html = { 'prettier' },
        sh = { 'shfmt' },
        rust = { 'rustfmt' },
        terraform = { 'terraform_fmt' },
        ['terraform-vars'] = { 'terraform_fmt' },
      },
    },
    init = function()
      vim.g.autoformat = true

      require('snacks.toggle')({
        name = 'Format on Save',
        get = function()
          return vim.g.autoformat
        end,
        set = function(state)
          vim.g.autoformat = state
        end,
      }):map('<leader>tf')
    end,
  },
}
