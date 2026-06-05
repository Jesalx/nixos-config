local icons = require('icons')
local uname = vim.uv.os_uname()

local function pad(s, width)
  s = tostring(s or '')
  local display_w = vim.api.nvim_strwidth(s)
  local padding = width - display_w
  if padding > 0 then
    return s .. string.rep(' ', padding)
  end
  return s
end

-- Pre-compute static values (these don't change within a session)

local os_info = (function()
  local f = io.open('/etc/os-release', 'r')
  if f then
    local content = f:read('*a')
    f:close()

    local id = content:match('^ID=(%S+)') or content:match('\nID=(%S+)') or 'linux'
    local pretty = content:match('PRETTY_NAME="([^"]+)"') or id
    pretty = pretty:gsub('%s*%b()', '')

    local icon = icons.distros[id:lower()] or ''

    return string.format('%s %s', icon, pretty)
  end

  if uname.sysname == 'Darwin' then
    return string.format('%s macOS', icons.distros.apple)
  end

  return uname.sysname
end)()

local nvim_version = (function()
  local v = vim.version()
  return string.format('%s %d.%d.%d', icons.nvim, v.major, v.minor, v.patch)
end)()

local _startup_ms
local function startup_time()
  return _startup_ms or '00.00ms'
end

local function system_box(pkgs)
  local min_val_w = 16
  local rows = {
    { 'USER', vim.uv.os_get_passwd().username },
    { 'PKGS', pkgs },
    { 'START', startup_time() },
  }

  local label_w, val_w = 0, min_val_w
  for _, r in ipairs(rows) do
    label_w = math.max(label_w, vim.api.nvim_strwidth(r[1]))
    val_w = math.max(val_w, vim.api.nvim_strwidth(r[2]))
  end

  local function row(label, value)
    return '│ ' .. pad(label, label_w) .. ' │ ' .. pad(value, val_w) .. ' │'
  end

  local border_label = string.rep('─', label_w + 2)
  local border_val = string.rep('─', val_w + 2)
  local lines = { '╭' .. border_label .. '┬' .. border_val .. '╮' }
  for _, r in ipairs(rows) do
    lines[#lines + 1] = row(r[1], r[2])
  end
  lines[#lines + 1] = '╰' .. border_label .. '┴' .. border_val .. '╯'
  return table.concat(lines, '\n')
end

local neovim_header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]]

local function build_header(pkgs)
  return neovim_header .. '\n\n' .. os_info .. '  |  ' .. nvim_version .. '\n\n' .. system_box(pkgs)
end

local _dashboard_header = build_header('00/00 plugins')

vim.api.nvim_create_autocmd('UIEnter', {
  once = true,
  callback = function()
    if _G._init_start then
      _startup_ms = string.format('%.2fms', (vim.uv.hrtime() - _G._init_start) / 1e6)
      _G._init_start = nil
    end
    vim.schedule(function()
      local plugins = vim.pack.get()
      local active = 0
      for _, p in ipairs(plugins) do
        if p.active then
          active = active + 1
        end
      end
      _dashboard_header = build_header(string.format('%02d/%02d plugins', active, #plugins))
      Snacks.dashboard.update()
    end)
  end,
})

vim.pack.add({ 'https://github.com/folke/snacks.nvim' })

require('snacks').setup({
  indent = {},
  dashboard = {
    preset = {
      keys = {
        {
          icon = icons.dashboard.find_file,
          key = 'f',
          desc = 'Find File',
          action = function()
            MiniPick.builtin.files()
          end,
        },
        {
          icon = icons.dashboard.find_text,
          key = '/',
          desc = 'Find Text',
          action = function()
            MiniPick.builtin.grep_live()
          end,
        },
        {
          icon = icons.dashboard.new_file,
          key = 'n',
          desc = 'New File',
          action = function()
            vim.cmd('ene | startinsert')
          end,
        },
        {
          icon = icons.dashboard.config,
          key = 'c',
          desc = 'Config',
          action = function()
            MiniPick.builtin.files(nil, { source = { cwd = vim.fn.expand('~/.config/nvim') } })
          end,
        },
        {
          icon = icons.dashboard.packages,
          key = 'p',
          desc = 'Packages',
          action = function()
            vim.pack.update()
          end,
        },
        {
          icon = icons.dashboard.quit,
          key = 'q',
          desc = 'Quit',
          action = function()
            vim.cmd('qa')
          end,
        },
      },
    },
    sections = {
      function()
        return { header = _dashboard_header, padding = 1 }
      end,
      { section = 'keys', gap = 1, padding = 1 },
    },
  },
  terminal = {
    win = {
      style = 'terminal',
      position = 'float',
      width = 0.8,
      height = 0.8,
      border = 'rounded',
      relative = 'editor',
      keys = {
        term_normal = false,
      },
    },
    persistent = true,
    autoinsert = true,
  },
})

-- Keymaps

vim.keymap.set('n', '<leader>.', function()
  Snacks.terminal.toggle()
end, { desc = 'Toggle floating terminal' })

vim.api.nvim_create_user_command('Run', function(opts)
  Snacks.terminal.open(opts.args, {
    interactive = false,
    persistent = false,
    win = {
      position = opts.bang and 'bottom' or nil,
      keys = {
        q = 'close',
      },
    },
  })
end, { nargs = '+', bang = true, complete = 'shellcmdline', desc = 'Run shell command in terminal (! for split)' })

local function cabbrev(lhs, rhs)
  vim.keymap.set('ca', lhs, function()
    return vim.fn.getcmdtype() == ':' and vim.fn.getcmdline() == lhs and rhs or lhs
  end, { expr = true })
end

cabbrev('!!', 'Run')
cabbrev('!s', 'Run!')
