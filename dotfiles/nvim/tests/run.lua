require('options')
require('autocmds')
require('keymaps')

dofile('tests/test_options.lua')
dofile('tests/test_keymaps.lua')
dofile('tests/test_specs.lua')
dofile('tests/test_autocmds.lua')

require('helpers').finish()
