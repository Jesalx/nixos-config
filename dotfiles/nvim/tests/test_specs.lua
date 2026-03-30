local t = require('helpers')

t.describe('plugin scripts', function()
  local root = vim.fn.fnamemodify(vim.fn.getcwd(), ':p')
  local plugin_dir = root .. 'plugin'
  local files = vim.fn.glob(plugin_dir .. '/*.lua', false, true)

  t.it('finds plugin files', function()
    t.ok(#files > 0, 'no files found in plugin/')
  end)

  for _, file in ipairs(files) do
    local name = vim.fn.fnamemodify(file, ':t')

    t.it(name .. ' is valid Lua', function()
      local chunk, err = loadfile(file)
      t.ok(chunk ~= nil, 'syntax error: ' .. tostring(err))
    end)
  end
end)
