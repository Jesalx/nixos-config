-- File: ~/.config/nvim/lua/plugins/nix.lua
return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.nil_ls = {
        mason = false, -- Disable Mason for this server
        cmd = { "nil" },
        filetypes = { "nix" },
        root_dir = require("lspconfig.util").root_pattern("flake.nix", ".git"),
      }
      return opts
    end,
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        nix = { "nixfmt" },
      },
    },
  },
}
