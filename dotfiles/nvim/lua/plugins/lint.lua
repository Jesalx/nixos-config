return {

  { -- Linting
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        markdown = { "markdownlint" },
        python = { "ruff" },
        go = { "golangcilint" },
      }

      lint.linters.golangcilint = {
        cmd = "golangci-lint",
        stdin = false,
        append_fname = false,
        args = {
          "run",
          "--config",
          vim.fn.expand("~/.config/golangci-lint/config.yml"),
          "--output.json.path=stdout",
          "--output.text.path=",
          "--show-stats=false",
          "--issues-exit-code=0",
          "--path-mode=abs",
          function()
            return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p")
          end,
        },
        stream = "stdout",
        ignore_exitcode = true,
        parser = require("lint.linters.golangcilint").parser,
      }

      -- Create autocommand which carries out the actual linting
      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          -- Only run the linter in buffers that you can modify
          if vim.opt_local.modifiable:get() then
            lint.try_lint()
          end
        end,
      })
    end,
  },
}
