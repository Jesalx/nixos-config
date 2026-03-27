-- Custom 2-character motion plugin.
--   s + 2 chars: jump forward to match
--   S + 2 chars: jump backward to match
--   ; / , : repeat seek or native f/F/t/T (whichever was most recent)
-- Case insensitive. All matches highlighted via matchadd,
-- cleared on the next cursor movement.

local last_pattern = nil
local active = false
local match_id = nil
local seeking = false

local function find_matches(bufnr, pattern)
  local matches = {}
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local pat_lower = pattern:lower()

  for i, line in ipairs(lines) do
    local line_lower = line:lower()
    local col = 1
    while true do
      local s = line_lower:find(pat_lower, col, true)
      if not s then break end
      table.insert(matches, { i - 1, s - 1 })
      col = s + 1
    end
  end

  return matches
end

--- @param matches table[] {row, col} pairs (0-indexed)
--- @param row number 0-indexed cursor row
--- @param col number 0-indexed cursor column
--- @param direction number 1 for forward, -1 for backward
--- @return number|nil
local function find_nearest(matches, row, col, direction)
  if direction == 1 then
    for i, m in ipairs(matches) do
      if m[1] > row or (m[1] == row and m[2] > col) then
        return i
      end
    end
  else
    for i = #matches, 1, -1 do
      local m = matches[i]
      if m[1] < row or (m[1] == row and m[2] < col) then
        return i
      end
    end
  end
  return nil
end

local function set_highlights(pattern)
  if match_id then
    pcall(vim.fn.matchdelete, match_id)
  end
  match_id = vim.fn.matchadd('Search', '\\c\\V' .. vim.fn.escape(pattern, '\\'))
end

local function clear_highlights()
  if match_id then
    pcall(vim.fn.matchdelete, match_id)
    match_id = nil
  end
end

local function jump_to_match(pattern, direction)
  local matches = find_matches(vim.api.nvim_get_current_buf(), pattern)
  if #matches == 0 then return end

  local cursor = vim.api.nvim_win_get_cursor(0)
  local idx = find_nearest(matches, cursor[1] - 1, cursor[2], direction)

  set_highlights(pattern)

  if idx then
    local m = matches[idx]
    seeking = true
    vim.api.nvim_win_set_cursor(0, { m[1] + 1, m[2] })
    vim.schedule(function() seeking = false end)
  end
end

local esc = vim.api.nvim_replace_termcodes('<Esc>', true, false, true)

local function seek(direction)
  local ok1, c1 = pcall(vim.fn.getcharstr)
  if not ok1 or c1 == esc then return end

  local ok2, c2 = pcall(vim.fn.getcharstr)
  if not ok2 or c2 == esc then return end

  last_pattern = c1 .. c2
  active = true
  jump_to_match(last_pattern, direction)
end

local function repeat_seek(direction)
  if last_pattern then
    jump_to_match(last_pattern, direction)
  end
end

return {
  'seek',
  virtual = true,
  keys = {
    { 's', function() seek(1) end, mode = { 'n', 'x', 'o' } },
    { 'S', function() seek(-1) end, mode = { 'n', 'x', 'o' } },
  },
  config = function()
    for _, key in ipairs({ 'f', 'F', 't', 'T' }) do
      vim.keymap.set({ 'n', 'x', 'o' }, key, function()
        active = false
        return key
      end, { expr = true })
    end

    vim.keymap.set({ 'n', 'x', 'o' }, ';', function()
      if active then repeat_seek(1) else vim.api.nvim_feedkeys(';', 'n', false) end
    end)
    vim.keymap.set({ 'n', 'x', 'o' }, ',', function()
      if active then repeat_seek(-1) else vim.api.nvim_feedkeys(',', 'n', false) end
    end)

    vim.keymap.set('n', '<Esc>', function()
      clear_highlights()
      vim.cmd.nohlsearch()
    end)

    vim.api.nvim_create_autocmd('CursorMoved', {
      group = vim.api.nvim_create_augroup('seek', { clear = true }),
      callback = function()
        if seeking then return end
        clear_highlights()
      end,
    })
  end,
}
