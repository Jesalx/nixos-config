-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  "nvim-neo-tree/neo-tree.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
  },
  cmd = "Neotree",
  keys = {
    { "<leader>e", ":Neotree toggle<CR>", desc = "Toggle NeoTree", silent = true },
  },
  opts = {
    filesystem = {
      filtered_items = {
        visible = true, -- show hidden files
        hide_dotfiles = false,
        hide_gitignored = false,
      },
      window = {
        mappings = {
          ["e"] = "close_window", -- Optional: Close NeoTree with `e` when in the window
          ["H"] = "toggle_hidden",
        },
      },
    },
  },
}
