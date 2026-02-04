require("lazy").setup({
  { import = "plugins" },
}, {
  ui = {
    border = "rounded",
  },

  -- Disable change detection notifications
  change_detection = {
    notify = false,
  },

  rocks = {
    enabled = false,
  },

  -- Unused stuff
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "rplugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
