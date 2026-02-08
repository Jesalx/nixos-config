local M = {}

local mini_icons

-- Mode mappings and colors
local modes = {
  ['n'] = { name = 'NORMAL', hl = 'StatusLineNormal' },
  ['no'] = { name = 'N-PENDING', hl = 'StatusLineNormal' },
  ['nov'] = { name = 'N-PENDING', hl = 'StatusLineNormal' },
  ['noV'] = { name = 'N-PENDING', hl = 'StatusLineNormal' },
  ['no\22'] = { name = 'N-PENDING', hl = 'StatusLineNormal' },
  ['niI'] = { name = 'NORMAL', hl = 'StatusLineNormal' },
  ['niR'] = { name = 'NORMAL', hl = 'StatusLineNormal' },
  ['niV'] = { name = 'NORMAL', hl = 'StatusLineNormal' },
  ['nt'] = { name = 'TERMINAL', hl = 'StatusLineTerminal' },
  ['ntT'] = { name = 'TERMINAL', hl = 'StatusLineTerminal' },
  ['i'] = { name = 'INSERT', hl = 'StatusLineInsert' },
  ['ic'] = { name = 'INSERT', hl = 'StatusLineInsert' },
  ['ix'] = { name = 'INSERT', hl = 'StatusLineInsert' },
  ['t'] = { name = 'TERMINAL', hl = 'StatusLineTerminal' },
  ['v'] = { name = 'VISUAL', hl = 'StatusLineVisual' },
  ['vs'] = { name = 'VISUAL', hl = 'StatusLineVisual' },
  ['V'] = { name = 'V-LINE', hl = 'StatusLineVisual' },
  ['Vs'] = { name = 'V-LINE', hl = 'StatusLineVisual' },
  ['\22'] = { name = 'V-BLOCK', hl = 'StatusLineVisual' },
  ['\22s'] = { name = 'V-BLOCK', hl = 'StatusLineVisual' },
  ['R'] = { name = 'REPLACE', hl = 'StatusLineReplace' },
  ['Rc'] = { name = 'REPLACE', hl = 'StatusLineReplace' },
  ['Rx'] = { name = 'REPLACE', hl = 'StatusLineReplace' },
  ['Rv'] = { name = 'V-REPLACE', hl = 'StatusLineReplace' },
  ['Rvc'] = { name = 'V-REPLACE', hl = 'StatusLineReplace' },
  ['Rvx'] = { name = 'V-REPLACE', hl = 'StatusLineReplace' },
  ['s'] = { name = 'SELECT', hl = 'StatusLineSelect' },
  ['S'] = { name = 'S-LINE', hl = 'StatusLineSelect' },
  ['\19'] = { name = 'S-BLOCK', hl = 'StatusLineSelect' },
  ['c'] = { name = 'COMMAND', hl = 'StatusLineCommand' },
  ['cv'] = { name = 'COMMAND', hl = 'StatusLineCommand' },
  ['ce'] = { name = 'COMMAND', hl = 'StatusLineCommand' },
  ['r'] = { name = 'PROMPT', hl = 'StatusLineCommand' },
  ['rm'] = { name = 'MORE', hl = 'StatusLineCommand' },
  ['r?'] = { name = 'CONFIRM', hl = 'StatusLineCommand' },
  ['!'] = { name = 'SHELL', hl = 'StatusLineCommand' },
}

-- Get current mode
function M.mode()
  local mode_code = vim.api.nvim_get_mode().mode
  local mode = modes[mode_code] or { name = 'UNKNOWN', hl = 'StatusLine' }
  return string.format('%%#%s# %s %%*', mode.hl, mode.name)
end

-- Get filename with modified indicator
function M.filename()
  local filename = vim.fn.expand('%:t')
  if filename == '' then
    filename = '[No Name]'
  end

  local modified = vim.bo.modified and ' [+]' or ''
  local readonly = vim.bo.readonly and ' [RO]' or ''

  return string.format('%%#StatusLineFilename# %s%s%s %%*', filename, modified, readonly)
end

-- Get git diff stats
function M.git_diff()
  local minidiff = vim.b.minidiff_summary
  if not minidiff then
    return ''
  end

  local parts = {}

  if minidiff.add and minidiff.add > 0 then
    table.insert(parts, string.format('%%#StatusLineGitAdd#+%d%%*', minidiff.add))
  end

  if minidiff.change and minidiff.change > 0 then
    table.insert(parts, string.format('%%#StatusLineGitChange#~%d%%*', minidiff.change))
  end

  if minidiff.delete and minidiff.delete > 0 then
    table.insert(parts, string.format('%%#StatusLineGitDelete#-%d%%*', minidiff.delete))
  end

  if #parts > 0 then
    return ' ' .. table.concat(parts, ' ') .. ' '
  end

  return ''
end

-- Get diagnostics
function M.diagnostics()
  local status = vim.diagnostic.status()
  if status and status ~= '' then
    return ' ' .. status .. ' '
  end
  return ''
end

-- Get filetype
function M.filetype()
  local ft = vim.bo.filetype
  if ft == '' then
    return ''
  end

  -- Lazy-load mini.icons on first use
  if not mini_icons then
    mini_icons = require('mini.icons')
  end

  -- Get icon and highlight from mini.icons
  local icon, hl, is_default = mini_icons.get('filetype', ft)

  if icon and icon ~= '' then
    return string.format('%%#%s# %s %%#StatusLineFiletype#%s %%*', hl, icon, ft)
  else
    return string.format('%%#StatusLineFiletype# %s %%*', ft)
  end
end

-- Get progress through file
function M.progress()
  local cur_line = vim.fn.line('.')
  local total_lines = vim.fn.line('$')

  if cur_line == 1 then
    return '%#StatusLineProgress# Top %*'
  elseif cur_line == total_lines then
    return '%#StatusLineProgress# Bot %*'
  else
    local percent = math.floor((cur_line / total_lines) * 100)
    -- Right-align to 2 digits for consistent 3-char width (e.g., " 6%" or "66%")
    return string.format('%%#StatusLineProgress# %2d%%%% %%*', percent)
  end
end

-- Get location (line:column)
function M.location()
  local line = vim.fn.line('.')
  local col = vim.fn.col('.')
  -- Right-align line to 3 digits, left-align column to 3 digits for consistent width
  return string.format('%%#StatusLineLocation# %3d:%-3d %%*', line, col)
end

function M.statusline()
  if vim.bo.filetype == 'snacks_dashboard' then
    return ''
  end

  local left = table.concat({
    M.mode(),
    M.filename(),
    M.git_diff(),
    M.diagnostics(),
  })

  local right = table.concat({
    M.filetype(),
    M.progress(),
    M.location(),
  })

  return left .. '%=' .. right
end

function M.setup()
  vim.opt.statusline = "%!v:lua.require('statusline').statusline()"
end

M.setup()

return M
