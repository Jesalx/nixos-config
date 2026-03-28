return {
  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format({ async = true })
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      default_format_opts = {
        lsp_format = 'fallback',
      },
      format_on_save = function(_bufnr)
        if not vim.g.autoformat then
          return nil
        end
        return { timeout_ms = 500 }
      end,

      formatters = {
        gofumpt = {
          prepend_args = { '-extra' },
        },
      },
      formatters_by_ft = {
        c = { lsp_format = 'prefer' },
        lua = { 'stylua' },
        go = { 'goimports', 'gofumpt', lsp_format = 'prefer' },
        python = { 'ruff_fix', 'ruff_format' },
        javascript = { 'biome', 'prettierd', 'prettier', stop_after_first = true },
        typescript = { 'biome', 'prettierd', 'prettier', stop_after_first = true },
        yaml = { 'yamlfmt' },
        json = { 'biome', 'prettierd', 'prettier', stop_after_first = true },
        jsonc = { 'biome', 'prettierd', 'prettier', stop_after_first = true },
        markdown = { 'prettierd', 'prettier', stop_after_first = true },
        html = { 'prettierd', 'prettier', stop_after_first = true },
        sh = { 'shfmt' },
        rust = { 'rustfmt', lsp_format = 'prefer' },
        terraform = { 'terraform_fmt' },
        ['terraform-vars'] = { 'terraform_fmt' },
        ['*'] = { 'codespell' },
        ['_'] = { 'trim_whitespace', 'trim_newlines' },
      },
    },
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
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
