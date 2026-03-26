local M = {}

local uname = vim.uv.os_uname()
local is_darwin = uname.sysname == 'Darwin'

local icons = {
  neovim = '',
  apple = '󰀵',
  nixos = '󱄅',
  arch = '󰣇',
}

local function cmd(s)
  return (vim.fn.system(s):gsub('%s+$', ''))
end

local function pad(s, width)
  s = tostring(s or '')
  local display_w = vim.api.nvim_strwidth(s)
  local padding = width - display_w
  if padding > 0 then
    return s .. string.rep(' ', padding)
  end
  return s
end

local function os_info()
  if is_darwin then
    local out = cmd('sw_vers')
    local name = out:match('ProductName:%s*(.-)%s*\n') or 'macOS'
    local version = out:match('ProductVersion:%s*(.-)%s*\n') or ''
    return string.format('%s %s %s', icons.apple, name, version)
  end

  local f = io.open('/etc/os-release', 'r')
  if f then
    local content = f:read('*a')
    f:close()

    local id = content:match('^ID=(%S+)') or content:match('\nID=(%S+)') or 'linux'
    local pretty = content:match('PRETTY_NAME="([^"]+)"') or id
    pretty = pretty:gsub('%s*%b()', '')

    local icon = icons[id:lower()] or ''

    return string.format('%s %s', icon, pretty)
  end

  return uname.sysname
end

local function nvim_version()
  local v = vim.version()
  return string.format('%s %d.%d.%d', icons.neovim, v.major, v.minor, v.patch)
end

local function ip_info()
  if is_darwin then
    local ip = cmd('ipconfig getifaddr en0 || ipconfig getifaddr en1')
    return ip ~= '' and ip or 'N/A'
  end
  local raw = cmd('hostname -I')
  local ip = raw:match('%S+') or 'N/A'
  return ip
end

local function lazy_info()
  local ok, lazy = pcall(require, 'lazy')
  if not ok or not lazy.stats then
    return '??', '??'
  end
  local stats = lazy.stats()
  local width = #tostring(stats.count)
  local loaded = string.format('%0' .. width .. 'd', stats.loaded)
  local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
  return loaded .. '/' .. stats.count .. ' plugins', ms .. 'ms'
end

local function system_box()
  local pkgs, startup = lazy_info()
  local rows = {
    { 'USER', vim.uv.os_get_passwd().username },
    { 'KERNEL', uname.release },
    { 'SHELL', vim.env.SHELL and vim.fn.fnamemodify(vim.env.SHELL, ':t') or '??' },
    { 'IP', ip_info() },
    { 'PKGS', pkgs },
    { 'START', startup },
  }

  local val_w = 24
  local label_w = 6

  local function row(label, value)
    return '│ ' .. pad(label, label_w) .. ' │ ' .. pad(value, val_w) .. ' │'
  end

  local border_inner = string.rep('─', val_w + 2)
  local lines = { '╭────────┬' .. border_inner .. '╮' }
  for _, r in ipairs(rows) do
    lines[#lines + 1] = row(r[1], r[2])
  end
  lines[#lines + 1] = '╰────────┴' .. border_inner .. '╯'
  return table.concat(lines, '\n')
end

local header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]]

function M.header()
  return header .. '\n\n' .. os_info() .. '  |  ' .. nvim_version() .. '\n\n' .. system_box()
end

return M
