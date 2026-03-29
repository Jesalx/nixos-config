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
        timeout_ms = 500,
        lsp_format = 'fallback',
      },
      format_on_save = function(_)
        if not vim.g.autoformat then
          return nil
        end
        return {}
      end,

      formatters = {
        gofumpt = {
          prepend_args = { '-extra' },
        },
        dprint = {
          prepend_args = { '--config', vim.fn.stdpath('config') .. '/dprint.jsonc' },
        },
      },
      formatters_by_ft = {
        c = { lsp_format = 'prefer' },
        lua = { 'stylua' },
        go = { 'goimports', 'gofumpt', lsp_format = 'prefer' },
        python = { 'ruff_fix', 'ruff_format' },
        javascript = { 'biome', 'dprint', stop_after_first = true },
        typescript = { 'biome', 'dprint', stop_after_first = true },
        yaml = { 'yamlfmt' },
        json = { 'dprint' },
        jsonc = { 'dprint' },
        toml = { 'dprint' },
        markdown = { 'dprint' },
        sh = { 'shfmt' },
        rust = { 'rustfmt', lsp_format = 'prefer' },
        terraform = { 'terraform_fmt' },
        ['terraform-vars'] = { 'terraform_fmt' },
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
