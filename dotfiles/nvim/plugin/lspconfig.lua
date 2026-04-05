vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
  once = true,
  callback = function()
    -- Load dependencies
    vim.pack.add({
      'https://github.com/folke/lazydev.nvim',
      'https://github.com/mason-org/mason.nvim',
      'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
      { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('1.x') },
    })

    require('lazydev').setup({
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        { path = 'snacks.nvim', words = { 'Snacks' } },
      },
    })

    require('mason').setup({})

    vim.filetype.add({
      pattern = {
        ['.*/templates/.*%.yaml'] = 'helm',
        ['.*/templates/.*%.tpl'] = 'helm',
        ['.*/%.github/workflows/.*%.ya?ml'] = 'yaml.ghaction',
      },
    })

    -- Delete default LSP keymaps that conflict with custom mappings
    for _, k in ipairs({ 'gra', 'grn', 'grr', 'gri', 'grt', 'grx' }) do
      pcall(vim.keymap.del, 'n', k)
    end

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('jesal/lsp-attach', { clear = true }),
      callback = function(event)
        -- Rename the variable under your cursor.
        --  Most Language Servers support renaming across files, etc.
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { buffer = event.buf, desc = '[R]e[n]ame' })

        -- Execute a code action, usually your cursor needs to be on top of an error
        -- or a suggestion from your LSP for this to activate.
        vim.keymap.set({ 'n', 'x' }, '<leader>ca', vim.lsp.buf.code_action, { buffer = event.buf, desc = '[C]ode [A]ction' })

        vim.keymap.set('n', 'gr', function()
          MiniExtra.pickers.lsp({ scope = 'references' })
        end, { buffer = event.buf, desc = '[G]oto [R]eferences' })

        vim.keymap.set('n', 'gi', function()
          MiniExtra.pickers.lsp({ scope = 'implementation' })
        end, { buffer = event.buf, desc = '[G]oto [I]mplementation' })

        vim.keymap.set('n', 'gd', function()
          MiniExtra.pickers.lsp({ scope = 'definition' })
        end, { buffer = event.buf, desc = '[G]oto [D]efinition' })

        vim.keymap.set('n', 'gD', function()
          MiniExtra.pickers.lsp({ scope = 'declaration' })
        end, { buffer = event.buf, desc = '[G]oto [D]eclaration' })

        vim.keymap.set('n', 'gO', function()
          MiniExtra.pickers.lsp({ scope = 'document_symbol' })
        end, { buffer = event.buf, desc = 'Open [D]ocument Symbols' })

        vim.keymap.set('n', 'gW', function()
          MiniExtra.pickers.lsp({ scope = 'workspace_symbol' })
        end, { buffer = event.buf, desc = 'Open [W]orkspace Symbols' })

        vim.keymap.set('n', 'gt', function()
          MiniExtra.pickers.lsp({ scope = 'type_definition' })
        end, { buffer = event.buf, desc = '[G]oto [T]ype Definition' })

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
          local highlight_augroup = vim.api.nvim_create_augroup('jesal/lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('jesal/lsp-detach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds({ group = 'jesal/lsp-highlight', buffer = event2.buf })
            end,
          })
        end

        -- The following code creates a keymap to toggle inlay hints in the code
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
          vim.lsp.inlay_hint.enable(true, { bufnr = event.buf }) -- enable inlay hints by default
          vim.keymap.set('n', '<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
          end, { buffer = event.buf, desc = '[T]oggle Inlay [H]ints' })
        end

        -- Enable inline completion for copilot
        if client and client.name == 'copilot' then
          vim.lsp.inline_completion.enable(true, { bufnr = event.buf })
        end
      end,
    })

    -- Diagnostic Config
    -- See :help vim.diagnostic.Opts
    vim.diagnostic.config({
      severity_sort = true,
      float = { source = 'if_many' },
      underline = { severity = vim.diagnostic.severity.ERROR },
      signs = { text = require('icons').diagnostic_signs },
      virtual_text = {
        source = 'if_many',
        spacing = 2,
      },
      status = { text = require('icons').diagnostic_status },
    })

    -- Broadcast blink.cmp capabilities to all LSP servers
    vim.lsp.config('*', {
      capabilities = require('blink.cmp').get_lsp_capabilities(),
    })

    -- Enable LSP servers (configs live in lsp/<server>.lua)
    vim.lsp.enable({
      'clangd',
      'copilot',
      'gopls',
      'helm_ls',
      'jsonls',
      'lua_ls',
      'pyright',
      'ruff',
      'rust_analyzer',
      'terraformls',
      'yamlls',
    })

    -- Ensure the servers and tools are installed via Mason
    -- Run :Mason to view status or :MasonToolsInstall to trigger installation
    local ensure_installed = {
      -- LSP Servers
      'gopls',
      'rust-analyzer',
      'terraform-ls',
      'helm-ls',
      'yaml-language-server',
      'json-lsp',
      'pyright',
      'clangd',
      'copilot-language-server',
      'lua-language-server',

      -- Formatters
      'stylua',
      'goimports',
      'gofumpt',
      'yamlfmt',
      'shfmt',
      'biome',
      'dprint',
      'ruff',

      -- Linters
      'actionlint',
      'golangci-lint',
      'selene',
      'yamllint',
      'tflint',
      'markdownlint',

      -- Tools
      'tree-sitter-cli',
    }
    require('mason-tool-installer').setup({ ensure_installed = ensure_installed })

    -- Copilot helper function
    local function get_copilot_client()
      local clients = vim.lsp.get_clients({ name = 'copilot' })
      if #clients == 0 then
        vim.notify('Copilot LSP is not running. Start editing a file to activate it.', vim.log.levels.WARN)
        return nil
      end
      return clients[1]
    end

    -- Sign in to GitHub Copilot
    vim.api.nvim_create_user_command('LspCopilotSignIn', function()
      local client = get_copilot_client()
      if not client then
        return
      end

      client:request('signInInitiate', nil, function(err, result)
        if err then
          vim.notify('Copilot sign in error: ' .. vim.inspect(err), vim.log.levels.ERROR)
          return
        end

        if result then
          local message = string.format(
            'GitHub Copilot Sign In\n\n' .. '1. Go to: %s\n' .. '2. Enter code: %s\n\n' .. 'Waiting for authentication...',
            result.verificationUri or 'https://github.com/login/device',
            result.userCode or 'N/A'
          )
          vim.notify(message, vim.log.levels.INFO)

          client:request('signInConfirm', { userCode = result.userCode }, function(confirm_err, confirm_result)
            if confirm_err then
              vim.notify('Copilot sign in confirmation error: ' .. vim.inspect(confirm_err), vim.log.levels.ERROR)
              return
            end

            if confirm_result and confirm_result.status == 'OK' then
              vim.notify('Successfully signed in to GitHub Copilot!', vim.log.levels.INFO)
            else
              vim.notify('Copilot sign in status: ' .. vim.inspect(confirm_result), vim.log.levels.WARN)
            end
          end)
        end
      end)
    end, { desc = 'Sign in to GitHub Copilot' })

    -- Sign out from GitHub Copilot
    vim.api.nvim_create_user_command('LspCopilotSignOut', function()
      local client = get_copilot_client()
      if not client then
        return
      end

      client:request('signOut', nil, function(err, _)
        if err then
          vim.notify('Copilot sign out error: ' .. vim.inspect(err), vim.log.levels.ERROR)
          return
        end
        vim.notify('Signed out from GitHub Copilot', vim.log.levels.INFO)
      end)
    end, { desc = 'Sign out from GitHub Copilot' })

    vim.keymap.set('n', '<leader>tc', function()
      local clients = vim.lsp.get_clients({ name = 'copilot' })
      if #clients > 0 then
        for _, client in ipairs(clients) do
          client:stop()
        end
        vim.notify('Copilot disabled', vim.log.levels.INFO)
      else
        vim.lsp.enable('copilot')
        vim.notify('Copilot enabled', vim.log.levels.INFO)
      end
    end, { desc = '[T]oggle [C]opilot' })
  end,
})
