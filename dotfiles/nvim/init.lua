-- NOTE: Order matters. Setting options early is important so that the proper leader key is set before plugins are loaded

-- [[ Setting options ]]
require("options")

-- [[ Autocommands ]]
require("autocmds")

-- [[ Basic Keymaps ]]
require("keymaps")

-- [[ User Commands ]]
require("commands")

-- [[ Install `lazy.nvim` plugin manager ]]
require("lazy-bootstrap")

-- [[ Configure and install plugins ]]
require("plugin-loader")
