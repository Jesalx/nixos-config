return {
  "m4xshen/hardtime.nvim",
  lazy = false,
  dependencies = { "MunifTanjim/nui.nvim" },
  opts = {
    disabled_keys = {
      ["<Up>"] = false,
      ["<Down>"] = false,
      ["<Left>"] = false,
      ["<Right>"] = false,
      ["h"] = false,
      ["j"] = false,
      ["k"] = false,
      ["l"] = false,
    },
    disable_mouse = false,
  },
}
