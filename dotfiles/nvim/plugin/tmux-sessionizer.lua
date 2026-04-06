--- Tmux session picker.
--- Lists existing tmux sessions and project directories, then
--- creates/switches to the selected session.

local search_paths = {
  { path = vim.env.HOME .. '/Developer', depth = 1 },
}

local icon_session = '● '
local icon_dir = '○ '

--- Find subdirectories up to a given depth, skipping .git dirs.
---@param root string
---@param max_depth integer
---@return string[]
local function find_dirs(root, max_depth)
  local dirs = {}

  local function walk(dir, depth)
    if depth > max_depth then
      return
    end
    local handle = vim.uv.fs_scandir(dir)
    if not handle then
      return
    end
    while true do
      local name, typ = vim.uv.fs_scandir_next(handle)
      if not name then
        break
      end
      if name ~= '.git' and typ == 'directory' then
        local full = dir .. '/' .. name
        table.insert(dirs, full)
        if depth < max_depth then
          walk(full, depth + 1)
        end
      end
    end
  end

  walk(root, 1)
  return dirs
end

--- Format a directory basename into a valid tmux session name.
---@param name string
---@return string
local function format_session_name(name)
  name = vim.trim(name)
  name = name:gsub('^[-_%.]+', ''):gsub('[-_%.]+$', '')
  name = name:gsub('%.', '_')
  return name
end

vim.keymap.set('n', '<leader>st', function()
  if vim.env.TMUX == nil then
    vim.notify('Not inside a tmux session', vim.log.levels.WARN)
    return
  end

  local items = {}

  local current_handle = vim.system({ 'tmux', 'display-message', '-p', '#S' }, { text = true })
  local sessions_handle = vim.system({ 'tmux', 'list-sessions', '-F', '#{session_name}' }, { text = true })
  local current = current_handle:wait()
  local sessions = sessions_handle:wait()

  local current_name = current.code == 0 and vim.trim(current.stdout) or ''

  local session_names = {}
  if sessions.code == 0 then
    for _, s in ipairs(vim.split(sessions.stdout, '\n', { trimempty = true })) do
      session_names[s] = true
      if s ~= current_name then
        table.insert(items, { session = s })
      end
    end
  end

  for _, sp in ipairs(search_paths) do
    local stat = vim.uv.fs_stat(sp.path)
    if stat and stat.type == 'directory' then
      for _, dir in ipairs(find_dirs(sp.path, sp.depth)) do
        local basename = vim.fn.fnamemodify(dir, ':t')
        local name = format_session_name(basename)
        if name ~= '' and not session_names[name] then
          table.insert(items, { session = name, dir = dir })
        end
      end
    end
  end

  if #items == 0 then
    vim.notify('No sessions or directories found', vim.log.levels.INFO)
    return
  end

  vim.ui.select(items, {
    prompt = 'Tmux Sessions',
    format_item = function(item)
      return (item.dir and icon_dir or icon_session) .. item.session
    end,
  }, function(item)
    if not item then
      return
    end
    if item.dir then
      vim.system({ 'tmux', 'new-session', '-ds', item.session, '-c', item.dir }):wait()
    end
    vim.system({ 'tmux', 'switch-client', '-t', item.session })
  end)
end, { desc = '[S]earch [T]mux Sessions' })
