local t = require('helpers')

--- Create a scratch buffer, set its content, and fire StdinReadPost.
--- @param lines string[]
--- @return integer buf
local function stdin_buf(lines)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_exec_autocmds('StdinReadPost', { buffer = buf })
  return buf
end

t.describe('autocmds', function()
  t.describe('stdin filetype detection', function()
    t.it('detects JSON object', function()
      local buf = stdin_buf({ '{"key": "value"}' })
      t.eq(vim.bo[buf].filetype, 'json')
      vim.api.nvim_buf_delete(buf, { force = true })
    end)

    t.it('detects JSON array', function()
      local buf = stdin_buf({ '[{"id": 1}, {"id": 2}]' })
      t.eq(vim.bo[buf].filetype, 'json')
      vim.api.nvim_buf_delete(buf, { force = true })
    end)

    t.it('does not set filetype for non-JSON content', function()
      local buf = stdin_buf({ 'hello world' })
      t.eq(vim.bo[buf].filetype, '')
      vim.api.nvim_buf_delete(buf, { force = true })
    end)

    t.it('skips detection when filetype is already set', function()
      local buf = vim.api.nvim_create_buf(false, true)
      vim.bo[buf].filetype = 'markdown'
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, { '{"key": "value"}' })
      vim.api.nvim_exec_autocmds('StdinReadPost', { buffer = buf })
      t.eq(vim.bo[buf].filetype, 'markdown')
      vim.api.nvim_buf_delete(buf, { force = true })
    end)

    t.it('clears modified flag', function()
      local buf = stdin_buf({ 'plain text' })
      t.eq(vim.bo[buf].modified, false)
      vim.api.nvim_buf_delete(buf, { force = true })
    end)
  end)
end)
