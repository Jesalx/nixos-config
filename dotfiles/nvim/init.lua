-- NOTE: Order matters. Setting options early is important so that the proper
-- leader key is set before plugins are loaded.

vim.loader.enable()
_G._init_start = vim.uv.hrtime()

require('options')
require('autocmds')
require('keymaps')

-- Disable unused built-in plugins
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_rplugin = 1
vim.g.loaded_tohtml = 1
vim.g.loaded_tutor = 1

-- Plugin hooks must be defined before the first vim.pack.add() call
-- (plugin/ files are sourced after init.lua, so this ordering is guaranteed)
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == 'nvim-treesitter' and (kind == 'install' or kind == 'update') then
      if not ev.data.active then
        vim.cmd.packadd('nvim-treesitter')
      end
      vim.cmd('TSUpdate')
    end

    -- Build blink.cmp's Rust fuzzy matcher from source after install/update
    if name == 'blink.cmp' and (kind == 'install' or kind == 'update') then
      vim.system({ 'cargo', 'build', '--release' }, { cwd = ev.data.path }):wait()
    end
  end,
  desc = 'Post-install/update hooks for plugins',
})
