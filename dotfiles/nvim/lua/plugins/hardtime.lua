return {
  "m4xshen/hardtime.nvim",
  event = "VeryLazy",
  dependencies = { "MunifTanjim/nui.nvim" },
  opts = {
    disabled_keys = {
      ["<Up>"] = false,
      ["<Down>"] = false,
      ["<Left>"] = false,
      ["<Right>"] = false,
    },
    restricted_keys = {
      ["h"] = {},
      ["j"] = {},
      ["k"] = {},
      ["l"] = {},
    },
    disable_mouse = false,
  },
}
