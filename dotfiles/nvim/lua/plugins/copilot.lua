return {
  {
    "neovim/nvim-lspconfig",
    optional = true,
    config = function()
      local function get_copilot_client()
        local clients = vim.lsp.get_clients({ name = "copilot" })
        if #clients == 0 then
          vim.notify("Copilot LSP is not running. Start editing a file to activate it.", vim.log.levels.WARN)
          return nil
        end
        return clients[1]
      end

      -- Sign in to GitHub Copilot
      vim.api.nvim_create_user_command("LspCopilotSignIn", function()
        local client = get_copilot_client()
        if not client then
          return
        end

        client.request("signInInitiate", nil, function(err, result)
          if err then
            vim.notify("Copilot sign in error: " .. vim.inspect(err), vim.log.levels.ERROR)
            return
          end

          if result then
            local message = string.format(
              "GitHub Copilot Sign In\n\n" .. "1. Go to: %s\n" .. "2. Enter code: %s\n\n" .. "Waiting for authentication...",
              result.verificationUri or "https://github.com/login/device",
              result.userCode or "N/A"
            )
            vim.notify(message, vim.log.levels.INFO)

            client.request("signInConfirm", { userCode = result.userCode }, function(confirm_err, confirm_result)
              if confirm_err then
                vim.notify("Copilot sign in confirmation error: " .. vim.inspect(confirm_err), vim.log.levels.ERROR)
                return
              end

              if confirm_result and confirm_result.status == "OK" then
                vim.notify("Successfully signed in to GitHub Copilot!", vim.log.levels.INFO)
              else
                vim.notify("Copilot sign in status: " .. vim.inspect(confirm_result), vim.log.levels.WARN)
              end
            end)
          end
        end)
      end, { desc = "Sign in to GitHub Copilot" })

      -- Sign out from GitHub Copilot
      vim.api.nvim_create_user_command("LspCopilotSignOut", function()
        local client = get_copilot_client()
        if not client then
          return
        end

        client.request("signOut", nil, function(err, result)
          if err then
            vim.notify("Copilot sign out error: " .. vim.inspect(err), vim.log.levels.ERROR)
            return
          end
          vim.notify("Signed out from GitHub Copilot", vim.log.levels.INFO)
        end)
      end, { desc = "Sign out from GitHub Copilot" })

      -- Toggle inline completion on/off with <leader>cc
      vim.keymap.set("n", "<leader>cc", function()
        local bufnr = vim.api.nvim_get_current_buf()
        local is_enabled = vim.lsp.inline_completion.is_enabled({ bufnr = bufnr })
        vim.lsp.inline_completion.enable(not is_enabled, { bufnr = bufnr })
        vim.notify(string.format("Copilot inline completion %s", is_enabled and "disabled" or "enabled"), vim.log.levels.INFO)
      end, { desc = "[C]opilot toggle" })
    end,
  },
}
