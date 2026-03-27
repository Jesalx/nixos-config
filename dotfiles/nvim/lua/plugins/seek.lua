-- Custom 2-character motion plugin.
--   s + 2 chars: jump forward to match
--   S + 2 chars: jump backward to match
--   ; : repeat forward (always later in file)
--   , : repeat backward (always earlier in file)
-- Case insensitive. All matches highlighted via the search register,
-- so :nohlsearch (<Esc>) clears them naturally.

local last_pattern = nil

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

--- Find the index of the nearest match strictly in the given direction.
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

local function jump_to_match(pattern, direction)
  local matches = find_matches(vim.api.nvim_get_current_buf(), pattern)
  if #matches == 0 then return end

  local cursor = vim.api.nvim_win_get_cursor(0)
  local idx = find_nearest(matches, cursor[1] - 1, cursor[2], direction)

  vim.fn.setreg('/', '\\c\\V' .. vim.fn.escape(pattern, '\\'))
  vim.v.hlsearch = 1

  if idx then
    local m = matches[idx]
    vim.api.nvim_win_set_cursor(0, { m[1] + 1, m[2] })
  end
end

local esc = vim.api.nvim_replace_termcodes('<Esc>', true, false, true)

local function seek(direction)
  local ok1, c1 = pcall(vim.fn.getcharstr)
  if not ok1 or c1 == esc then return end

  local ok2, c2 = pcall(vim.fn.getcharstr)
  if not ok2 or c2 == esc then return end

  last_pattern = c1 .. c2
  jump_to_match(last_pattern, direction)
end

local function repeat_seek(direction)
  if last_pattern then
    jump_to_match(last_pattern, direction)
  end
end

return {
  name = 'seek',
  dir = vim.fn.stdpath('config'),
  keys = {
    { 's', function() seek(1) end, mode = { 'n', 'x', 'o' } },
    { 'S', function() seek(-1) end, mode = { 'n', 'x', 'o' } },
    { ';', function() repeat_seek(1) end, mode = { 'n', 'x', 'o' } },
    { ',', function() repeat_seek(-1) end, mode = { 'n', 'x', 'o' } },
  },
}
