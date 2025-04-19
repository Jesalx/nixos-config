return {
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = {
        char = "┃", -- ← thicker line
        tab_char = "┃",
      },
      whitespace = {
        remove_blankline_trail = false,
      },
      scope = {
        enabled = true,
        char = "┃",
        show_start = false,
        show_end = false,
      },
    },
  },
}
