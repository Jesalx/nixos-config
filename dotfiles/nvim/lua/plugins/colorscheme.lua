return {
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {
      style = "night",
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },
  {
    "srcery-colors/srcery-vim",
    lazy = true,
    config = function()
      -- set this to black so that popup windows are black/transparent
      vim.g.srcery_xgray2 = "#000000"
      vim.g.srcery_xgray2_cterm = 0
      vim.g.srcery_bg = { "#000000", "NONE" }
      vim.g.srcery_inverse = 0
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      flavour = "mocha",
      transparent_background = true,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
