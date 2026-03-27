local uname = vim.uv.os_uname()
local is_darwin = uname.sysname == 'Darwin'

local dashboard_icons = {
  neovim = '',
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
    return string.format('%s %s %s', dashboard_icons.apple, name, version)
  end

  local f = io.open('/etc/os-release', 'r')
  if f then
    local content = f:read('*a')
    f:close()

    local id = content:match('^ID=(%S+)') or content:match('\nID=(%S+)') or 'linux'
    local pretty = content:match('PRETTY_NAME="([^"]+)"') or id
    pretty = pretty:gsub('%s*%b()', '')

    local icon = dashboard_icons[id:lower()] or ''

    return string.format('%s %s', icon, pretty)
  end

  return uname.sysname
end

local function nvim_version()
  local v = vim.version()
  return string.format('%s %d.%d.%d', dashboard_icons.neovim, v.major, v.minor, v.patch)
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
  local min_val_w = 16
  local pkgs, startup = lazy_info()
  local rows = {
    { 'USER', vim.uv.os_get_passwd().username },
    { 'KERNEL', uname.release },
    { 'SHELL', vim.env.SHELL and vim.fn.fnamemodify(vim.env.SHELL, ':t') or '??' },
    { 'IP', ip_info() },
    { 'PKGS', pkgs },
    { 'START', startup },
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

local function dashboard_header()
  local header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]]

  return header .. '\n\n' .. os_info() .. '  |  ' .. nvim_version() .. '\n\n' .. system_box()
end

return {
  'folke/snacks.nvim',

  priority = 1000,
  lazy = false,
  opts = {
    toggle = {
      which_key = true,
    },
    input = {},
    notifier = {},
    indent = {},
    dashboard = {
      preset = {
        keys = {
          { icon = ' ', key = 'f', desc = 'Find File', action = function() Snacks.picker.files() end },
          { icon = ' ', key = '/', desc = 'Find Text', action = function() Snacks.picker.grep() end },
          { icon = ' ', key = 'n', desc = 'New File', action = function() vim.cmd('ene | startinsert') end },
          { icon = ' ', key = 'c', desc = 'Config', action = function() Snacks.picker.files({ cwd = vim.fn.expand('~/.config') }) end },
          { icon = '󰒲 ', key = 'l', desc = 'Lazy', action = function() vim.cmd('Lazy') end },
          { icon = ' ', key = 'q', desc = 'Quit', action = function() vim.cmd('qa') end },
        },
      },
      sections = {
        function()
          return { header = dashboard_header(), padding = 1 }
        end,
        { section = 'keys', gap = 1, padding = 1 },
      },
    },
    explorer = {
      replace_netrw = true,
      win = {
        border = 'rounded',
      },
    },
    picker = {
      sources = {
        explorer = {
          layout = { preset = 'sidebar', preview = false },
          hidden = true,
        },
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
      },
      persistent = true,
      autoinsert = true,
    },
    bigfile = {},
    quickfile = {},
  },
  keys = {
    -- Smart file search (buffers, project files)
    {
      '<leader><leader>',
      function()
        Snacks.picker.smart({
          multi = {
            'buffers',
            {
              source = 'files',
              cwd = vim.fn.getcwd(),
              hidden = true,
              ignore = { '**/.jj/**' },
            },
          },
        })
      end,
      desc = '[ ] Search Files',
    },
    -- Grep (live grep)
    {
      '<leader>/',
      function()
        Snacks.picker.grep({ hidden = true })
      end,
      desc = '[/] Search by Grep',
    },

    -- Help and keymaps
    {
      '<leader>sh',
      function()
        Snacks.picker.help()
      end,
      desc = '[S]earch [H]elp',
    },
    {
      '<leader>sk',
      function()
        Snacks.picker.keymaps()
      end,
      desc = '[S]earch [K]eymaps',
    },

    -- File pickers
    {
      '<leader>sf',
      function()
        Snacks.picker.files()
      end,
      desc = '[S]earch [F]iles',
    },
    {
      '<leader>s.',
      function()
        Snacks.picker.recent()
      end,
      desc = '[S]earch Recent Files (["."] for repeat)',
    },

    -- Word + Grep
    {
      '<leader>sw',
      function()
        Snacks.picker.grep_word()
      end,
      desc = '[S]earch current [W]ord',
    },
    {
      '<leader>sg',
      function()
        Snacks.picker.grep()
      end,
      desc = '[S]earch by [G]rep',
    },

    -- LSP + diagnostics
    {
      '<leader>sd',
      function()
        Snacks.picker.diagnostics()
      end,
      desc = '[S]earch [D]iagnostics',
    },

    -- Resume last picker
    {
      '<leader>sr',
      function()
        Snacks.picker.resume()
      end,
      desc = '[S]earch [R]esume',
    },

    -- Picker picker
    {
      '<leader>ss',
      function()
        Snacks.picker()
      end,
      desc = '[S]earch [S]elect Picker',
    },

    -- open Snacks explorer (like NeoTree)
    {
      '<leader>e',
      function()
        Snacks.explorer.open()
      end,
      desc = '[E]xplorer',
    },

    {
      '<leader>n',
      function()
        Snacks.picker.notifications()
      end,
      desc = '[N]otification History',
    },

    {
      '<leader>.',
      function()
        Snacks.terminal.toggle()
      end,
      desc = 'Toggle floating terminal',
    },
  },
}
