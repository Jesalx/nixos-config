---@type vim.lsp.Config
return {
  cmd = { 'ruff', 'server' },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'ruff.toml', '.ruff.toml', '.git' },
  -- Disable hover; pyright provides richer type information.
  -- Ruff hover only shows lint rule docs for `# noqa` comments.
  on_attach = function(client)
    client.server_capabilities.hoverProvider = false
  end,
}
