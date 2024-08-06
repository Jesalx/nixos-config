return {
  "hrsh7th/nvim-cmp",
  opts = function(_, opts)
    local cmp = require("cmp")

    opts.mapping = vim.tbl_extend("force", opts.mapping or {}, {
      ["<CR>"] = cmp.config.disable,
      ["<C-y>"] = cmp.mapping.confirm({ select = true }),
    })
  end,
}
