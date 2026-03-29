local t = require('helpers')

--- Check whether a table looks like a single lazy.nvim plugin spec
--- (has a string at [1] — the plugin name or short URL).
--- @param tbl table
--- @return boolean
local function is_spec(tbl)
  return type(tbl) == 'table' and type(tbl[1]) == 'string'
end

t.describe('plugin specs', function()
  local root = vim.fn.fnamemodify(vim.fn.getcwd(), ':p')
  local plugin_dir = root .. 'lua/plugins'
  local files = vim.fn.glob(plugin_dir .. '/*.lua', false, true)

  t.it('finds plugin files', function()
    t.ok(#files > 0, 'no files found in lua/plugins/')
  end)

  for _, file in ipairs(files) do
    local name = vim.fn.fnamemodify(file, ':t')

    t.it(name .. ' returns valid spec(s)', function()
      local ok, result = pcall(dofile, file)
      t.ok(ok, 'failed to load: ' .. tostring(result))
      t.ok(type(result) == 'table', 'expected table, got ' .. type(result))

      local specs = is_spec(result) and { result } or result
      for i, spec in ipairs(specs) do
        t.ok(type(spec[1]) == 'string', string.format('spec #%d missing plugin name (got %s)', i, type(spec[1])))
      end
    end)
  end
end)
