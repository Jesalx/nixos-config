---@type vim.lsp.Config
return {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { { '.luarc.json', '.luarc.jsonc' }, { '.stylua.toml', 'selene.toml' }, '.git' },
  settings = {
    Lua = {
      diagnostics = {
        disable = { 'param-type-mismatch', 'missing-fields' },
      },
      workspace = {
        library = { vim.env.VIMRUNTIME .. '/lua' },
      },
      telemetry = {
        enable = false,
      },
    },
  },
}
