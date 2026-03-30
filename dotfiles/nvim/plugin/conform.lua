-- These run immediately (equivalent to lazy.nvim's `init` function)
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
vim.g.autoformat = true

vim.schedule(function()
  require('snacks.toggle')({
    name = 'Format on Save',
    get = function()
      return vim.g.autoformat
    end,
    set = function(state)
      vim.g.autoformat = state
    end,
  }):map('<leader>tf')
end)

-- Lazy load conform on demand
local conform_loaded = false
local function ensure_conform()
  if conform_loaded then
    return
  end
  conform_loaded = true

  vim.pack.add({ 'https://github.com/stevearc/conform.nvim' })

  require('conform').setup({
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
  })
end

-- Load on first BufWritePre and manually format (conform's own autocmd
-- wasn't registered yet when this event started)
vim.api.nvim_create_autocmd('BufWritePre', {
  once = true,
  callback = function(args)
    ensure_conform()
    if vim.g.autoformat then
      require('conform').format({ timeout_ms = 500, lsp_format = 'fallback', buf = args.buf })
    end
  end,
})

-- Format keymap (loads conform on first use)
vim.keymap.set('', '<leader>f', function()
  ensure_conform()
  require('conform').format({ async = true })
end, { desc = '[F]ormat buffer' })
