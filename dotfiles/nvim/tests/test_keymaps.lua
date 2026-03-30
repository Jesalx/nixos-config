local t = require('helpers')

--- Build a lookup table from lhs -> keymap for a given mode.
--- @param mode string
--- @return table<string, table>
local function keymap_index(mode)
  local index = {}
  for _, map in ipairs(vim.api.nvim_get_keymap(mode)) do
    index[map.lhs] = map
  end
  return index
end

t.describe('keymaps', function()
  local n = keymap_index('n')
  local term = keymap_index('t')
  local leader = vim.g.mapleader

  t.it('clears search highlight on Esc', function()
    t.ok(n['<Esc>'], 'missing <Esc> mapping')
  end)

  t.it('maps C-hjkl for window navigation', function()
    for _, key in ipairs({ '<C-H>', '<C-J>', '<C-K>', '<C-L>' }) do
      t.ok(n[key], 'missing ' .. key .. ' mapping')
    end
  end)

  t.it('maps C-d/C-u for centered scrolling', function()
    for _, key in ipairs({ '<C-D>', '<C-U>' }) do
      t.ok(n[key], 'missing ' .. key .. ' mapping')
    end
  end)

  for _, mapping in ipairs({
    { key = 'D', desc = 'delete buffer content' },
    { key = 'y', desc = 'yank buffer' },
    { key = 'q', desc = 'quickfix list' },
    { key = 'R', desc = 'restart' },
    { key = 'L', desc = 'Packages' },
  }) do
    t.it('maps leader-' .. mapping.key .. ' to ' .. mapping.desc, function()
      t.ok(n[leader .. mapping.key], 'missing <leader>' .. mapping.key .. ' mapping')
    end)
  end

  t.it('maps double Esc for terminal exit', function()
    t.ok(term['<Esc><Esc>'], 'missing terminal <Esc><Esc> mapping')
  end)
end)
