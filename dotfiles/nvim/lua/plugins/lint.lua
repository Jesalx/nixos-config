return {

  { -- Linting
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require('lint')
      lint.linters_by_ft = {
        markdown = { 'markdownlint' },
        go = { 'golangcilint' },
        terraform = { 'tflint' },
        yaml = { 'yamllint' },
      }

      -- Config resolution: project-level (.golangci.yml walking up from cwd) >
      -- user-level (~/.config/golangci-lint/config.yml) > omit flag entirely.
      -- Resolved at plugin-load time; consistent with how golangci-lint uses the
      -- working directory when invoked.
      local function build_golangci_args()
        local args = { 'run' }
        local project_cfg = vim.fn.findfile('.golangci.yml', vim.fn.getcwd() .. ';')
        if project_cfg ~= '' then
          vim.list_extend(args, { '--config', vim.fn.fnamemodify(project_cfg, ':p') })
        else
          local user_cfg = vim.fn.expand('~/.config/golangci-lint/config.yml')
          if vim.fn.filereadable(user_cfg) == 1 then
            vim.list_extend(args, { '--config', user_cfg })
          end
        end
        vim.list_extend(args, {
          '--output.json.path=stdout',
          '--output.text.path=',
          '--show-stats=false',
          '--issues-exit-code=0',
          '--path-mode=abs',
          function()
            return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':p')
          end,
        })
        return args
      end

      lint.linters.golangcilint = {
        cmd = 'golangci-lint',
        stdin = false,
        append_fname = false,
        args = build_golangci_args(),
        stream = 'stdout',
        ignore_exitcode = true,
        parser = require('lint.linters.golangcilint').parser,
      }

      -- Create autocommand which carries out the actual linting
      local lint_augroup = vim.api.nvim_create_augroup('jesal/lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
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
