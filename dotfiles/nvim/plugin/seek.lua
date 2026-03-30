-- Custom 2-character motion plugin.
--   s + 2 chars: jump forward to match
--   S + 2 chars: jump backward to match
--   ; / , : repeat seek or native f/F/t/T (whichever was most recent)
-- Case insensitive. All matches highlighted via extmarks,
-- cleared on the next cursor movement.

local last_pattern = nil
local active = false
local seeking = false
local ns = vim.api.nvim_create_namespace('jesal/seek')
local highlighted_buf = nil

--- @type { search_range: number|nil }
local config = {
  -- Max lines above/below cursor to search. nil searches the entire buffer.
  search_range = nil,
}

--- @param bufnr number
--- @param pattern string
--- @return table[] matches {row, col} pairs (0-indexed)
local function find_matches(bufnr, pattern)
  local matches = {}
  local total = vim.api.nvim_buf_line_count(bufnr)
  local start_line, end_line = 0, total

  if config.search_range then
    local cursor_row = vim.api.nvim_win_get_cursor(0)[1] - 1
    start_line = math.max(0, cursor_row - config.search_range)
    end_line = math.min(total, cursor_row + config.search_range)
  end

  local lines = vim.api.nvim_buf_get_lines(bufnr, start_line, end_line, false)
  local pat_lower = pattern:lower()

  for i, line in ipairs(lines) do
    local line_lower = line:lower()
    local col = 1
    while true do
      local s = line_lower:find(pat_lower, col, true)
      if not s then
        break
      end
      table.insert(matches, { start_line + i - 1, s - 1 })
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

local function clear_highlights()
  if highlighted_buf and vim.api.nvim_buf_is_valid(highlighted_buf) then
    vim.api.nvim_buf_clear_namespace(highlighted_buf, ns, 0, -1)
    highlighted_buf = nil
  end
end

local function set_highlights(bufnr, matches, pattern_len)
  clear_highlights()
  for _, m in ipairs(matches) do
    vim.api.nvim_buf_set_extmark(bufnr, ns, m[1], m[2], {
      end_col = m[2] + pattern_len,
      hl_group = 'Search',
    })
  end
  highlighted_buf = bufnr
end

local function jump_to_match(pattern, direction)
  local bufnr = vim.api.nvim_get_current_buf()
  local matches = find_matches(bufnr, pattern)
  if #matches == 0 then
    return
  end

  local cursor = vim.api.nvim_win_get_cursor(0)
  local idx = find_nearest(matches, cursor[1] - 1, cursor[2], direction)

  set_highlights(bufnr, matches, #pattern)

  if idx then
    local m = matches[idx]
    seeking = true
    vim.api.nvim_win_set_cursor(0, { m[1] + 1, m[2] })
    vim.schedule(function()
      seeking = false
    end)
  end
end

local esc = vim.api.nvim_replace_termcodes('<Esc>', true, false, true)

local function seek(direction)
  local ok1, c1 = pcall(vim.fn.getcharstr)
  if not ok1 or c1 == esc then
    return
  end

  local ok2, c2 = pcall(vim.fn.getcharstr)
  if not ok2 or c2 == esc then
    return
  end

  last_pattern = c1 .. c2
  active = true
  jump_to_match(last_pattern, direction)
end

local function repeat_seek(direction)
  if last_pattern then
    jump_to_match(last_pattern, direction)
  end
end

-- Keymaps
vim.keymap.set({ 'n', 'x', 'o' }, 's', function()
  seek(1)
end, { desc = 'Seek forward' })

vim.keymap.set({ 'n', 'x', 'o' }, 'S', function()
  seek(-1)
end, { desc = 'Seek backward' })

for _, key in ipairs({ 'f', 'F', 't', 'T' }) do
  vim.keymap.set({ 'n', 'x', 'o' }, key, function()
    active = false
    return key
  end, { expr = true })
end

vim.keymap.set({ 'n', 'x', 'o' }, ';', function()
  if active then
    repeat_seek(1)
  else
    vim.api.nvim_feedkeys(';', 'n', false)
  end
end, { desc = 'Next seek/f/t/F/T' })

vim.keymap.set({ 'n', 'x', 'o' }, ',', function()
  if active then
    repeat_seek(-1)
  else
    vim.api.nvim_feedkeys(',', 'n', false)
  end
end, { desc = 'Prev seek/f/t/F/T' })

vim.keymap.set('n', '<Esc>', function()
  clear_highlights()
  vim.cmd.nohlsearch()
end)

vim.api.nvim_create_autocmd('CursorMoved', {
  group = vim.api.nvim_create_augroup('jesal/seek', { clear = true }),
  callback = function()
    if seeking then
      return
    end
    clear_highlights()
  end,
})
