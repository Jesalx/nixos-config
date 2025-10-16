local root = vim.fn.fnamemodify(vim.fn.getcwd(), ":p")

vim.opt.runtimepath:prepend(root)
vim.opt.runtimepath:append(root .. "/lua")

package.path = package.path .. ";" .. root .. "/lua/?.lua"
package.path = package.path .. ";" .. root .. "/lua/?/init.lua"

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.undofile = false

vim.g.loaded_gzip = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("options")
require("keymaps")

print("✅ Config loaded successfully")
