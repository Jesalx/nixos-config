local M = {}

local passed = 0
local failed = 0

--- Group related tests under a label.
--- @param name string
--- @param fn function
function M.describe(name, fn)
  print('\n' .. name)
  fn()
end

--- Run a single test case.
--- @param name string
--- @param fn function
function M.it(name, fn)
  local ok, err = pcall(fn)
  if ok then
    passed = passed + 1
    print('  ✓ ' .. name)
  else
    failed = failed + 1
    print('  ✗ ' .. name)
    print('    ' .. tostring(err))
  end
end

--- Assert two values are equal.
--- @param actual any
--- @param expected any
--- @param msg? string
function M.eq(actual, expected, msg)
  if actual ~= expected then
    error(string.format('%s\n      expected: %s\n      got:      %s', msg or 'values not equal', vim.inspect(expected), vim.inspect(actual)), 2)
  end
end

--- Assert a value is truthy.
--- @param val any
--- @param msg? string
function M.ok(val, msg)
  if not val then
    error(msg or 'expected truthy value', 2)
  end
end

--- Print summary and exit with the appropriate code.
function M.finish()
  print(string.format('\n%d passed, %d failed', passed, failed))
  if failed > 0 then
    print('FAILED')
    vim.cmd('cq 1')
  else
    print('OK')
    vim.cmd('qa!')
  end
end

return M
