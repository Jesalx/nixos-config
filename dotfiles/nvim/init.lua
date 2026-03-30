-- NOTE: Order matters. Setting options early is important so that the proper
-- leader key is set before plugins are loaded.

vim.loader.enable()
_G._init_start = vim.uv.hrtime()

require('options')
require('autocmds')
require('keymaps')
