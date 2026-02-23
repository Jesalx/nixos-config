-- LSP Plugins
return {
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      -- Mason must be loaded before its dependents so we need to set it up here.
      -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
      {
        'mason-org/mason.nvim',
        opts = {
          ui = {
            border = 'rounded',
          },
        },
      },
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', event = 'LspAttach', opts = {} },

      -- Allows extra capabilities provided by blink.cmp
      'saghen/blink.cmp',
    },
    config = function()
      vim.filetype.add({
        pattern = {
          ['.*/templates/.*%.yaml'] = 'helm',
          ['.*/templates/.*%.tpl'] = 'helm',
        },
      })

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
        callback = function(event)
          -- Delete default LSP keymaps that conflict with custom mappings
          for _, k in ipairs({ 'gra', 'grn', 'grr', 'gri', 'grt' }) do
            pcall(vim.keymap.del, 'n', k)
          end

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { buffer = event.buf, desc = '[R]e[n]ame' })

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          vim.keymap.set({ 'n', 'x' }, '<leader>ca', vim.lsp.buf.code_action, { buffer = event.buf, desc = '[C]ode [A]ction' })

          -- Find references for the word under your cursor.
          vim.keymap.set('n', 'gr', function()
            Snacks.picker.lsp_references()
          end, { buffer = event.buf, desc = '[G]oto [R]eferences' })

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          vim.keymap.set('n', 'gi', function()
            Snacks.picker.lsp_implementations()
          end, { buffer = event.buf, desc = '[G]oto [I]mplementation' })

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          vim.keymap.set('n', 'gd', function()
            Snacks.picker.lsp_definitions()
          end, { buffer = event.buf, desc = '[G]oto [D]efinition' })

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          vim.keymap.set('n', 'gD', function()
            Snacks.picker.lsp_declarations()
          end, { buffer = event.buf, desc = '[G]oto [D]eclaration' })

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          vim.keymap.set('n', 'gO', function()
            Snacks.picker.lsp_symbols()
          end, { buffer = event.buf, desc = 'Open [D]ocument Symbols' })

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          vim.keymap.set('n', 'gW', function()
            Snacks.picker.lsp_workspace_symbols()
          end, { buffer = event.buf, desc = 'Open [W]orkspace Symbols' })

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          vim.keymap.set('n', 'gt', function()
            Snacks.picker.lsp_type_definitions()
          end, { buffer = event.buf, desc = '[G]oto [T]ype Definition' })

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
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
              group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = 'lsp-highlight', buffer = event2.buf })
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
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        },
        virtual_text = {
          source = 'if_many',
          spacing = 2,
        },
        status = {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚',
            [vim.diagnostic.severity.WARN] = '󰀪',
            [vim.diagnostic.severity.INFO] = '󰋽',
            [vim.diagnostic.severity.HINT] = '󰌶',
          },
        },
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      local servers = {
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              staticcheck = true,
              vulncheck = 'Imports',
              analyses = {
                unreachable = true,
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
            },
          },
        },

        rust_analyzer = {
          settings = {
            ['rust-analyzer'] = {
              check = {
                command = 'clippy',
              },
              cargo = {
                allFeatures = true,
              },
            },
          },
        },

        yamlls = {},

        jsonls = {},

        pyright = {},

        helm_ls = {
          settings = {
            ['helm-ls'] = {
              yamlls = {
                path = 'yaml-language-server',
              },
            },
          },
        },

        lua_ls = {
          settings = {
            Lua = {
              runtime = {
                version = 'LuaJIT',
              },
              diagnostics = {
                globals = { 'vim', 'Snacks' },
              },
              workspace = {
                checkThirdParty = false,
                library = vim.api.nvim_get_runtime_file('', true),
              },
              telemetry = {
                enable = false,
              },
            },
          },
        },

        copilot = {},
      }

      -- Ensure the servers and tools are installed via Mason
      -- Run :Mason to view status or :MasonToolsInstall to trigger installation
      local ensure_installed = {
        -- LSP Servers
        'gopls',
        'rust-analyzer',
        'helm-ls',
        'yaml-language-server',
        'json-lsp',
        'pyright',
        'copilot-language-server',

        -- Formatters
        'stylua',
        'goimports',
        'gofumpt',
        'yamlfmt',
        'shfmt',
        'prettier',
        'prettierd',
        'black',
        'isort',

        -- Linters
        'golangci-lint',
        'yamllint',
        'tflint',
        'markdownlint',

        -- Tools
        'tree-sitter-cli',
      }
      require('mason-tool-installer').setup({ ensure_installed = ensure_installed })

      for name, server in pairs(servers) do
        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
        vim.lsp.config(name, server)
        vim.lsp.enable(name)
      end

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

        client.request('signInInitiate', nil, function(err, result)
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

            client.request('signInConfirm', { userCode = result.userCode }, function(confirm_err, confirm_result)
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

        client.request('signOut', nil, function(err, result)
          if err then
            vim.notify('Copilot sign out error: ' .. vim.inspect(err), vim.log.levels.ERROR)
            return
          end
          vim.notify('Signed out from GitHub Copilot', vim.log.levels.INFO)
        end)
      end, { desc = 'Sign out from GitHub Copilot' })

      -- Toggle inline completion on/off with <leader>tc
      vim.keymap.set('n', '<leader>tc', function()
        local bufnr = vim.api.nvim_get_current_buf()
        local is_enabled = vim.lsp.inline_completion.is_enabled({ bufnr = bufnr })
        vim.lsp.inline_completion.enable(not is_enabled, { bufnr = bufnr })
        vim.notify(string.format('Copilot inline completion %s', is_enabled and 'disabled' or 'enabled'), vim.log.levels.INFO)
      end, { desc = '[T]oggle [C]opilot' })
    end,
  },
}
