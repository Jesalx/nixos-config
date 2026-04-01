---@type vim.lsp.Config
return {
  cmd = { 'pyright-langserver', '--stdio' },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'setup.py', 'requirements.txt', 'Pipfile', '.git' },
  settings = {
    pyright = { disableOrganizeImports = true },
  },
}
