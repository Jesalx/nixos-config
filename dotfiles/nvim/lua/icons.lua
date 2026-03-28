local M = {}

local severity = vim.diagnostic.severity

M.diagnostics = {
  [severity.ERROR] = { icon = '󰅚', hl = 'DiagnosticError' },
  [severity.WARN] = { icon = '󰀪', hl = 'DiagnosticWarn' },
  [severity.INFO] = { icon = '󰋽', hl = 'DiagnosticInfo' },
  [severity.HINT] = { icon = '󰌶', hl = 'DiagnosticHint' },
}

M.diagnostic_signs = {}
M.diagnostic_status = {}
for sev, cfg in pairs(M.diagnostics) do
  M.diagnostic_signs[sev] = cfg.icon .. ' '
  M.diagnostic_status[sev] = cfg.icon
end

M.dashboard = {
  find_file = ' ',
  find_text = ' ',
  new_file = ' ',
  config = ' ',
  lazy = '󰒲 ',
  quit = ' ',
}

M.distros = {
  nixos = '󱄅',
  arch = '󰣇',
}

M.nvim = ''

return M
