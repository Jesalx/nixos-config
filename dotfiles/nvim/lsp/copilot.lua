---@type vim.lsp.Config
return {
  cmd = { 'copilot-language-server', '--stdio' },
  root_markers = { '.git' },
}
