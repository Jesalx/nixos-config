return {
  {
    "justinmk/vim-sneak",
    config = function()
      vim.g["sneak#use_ic_scs"] = 1
      vim.g["sneak#absolute_dir"] = 1
    end,
  },
}
