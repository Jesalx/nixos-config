return {
  {
    "github/copilot.vim",
    event = "InsertEnter",
    config = function()
      vim.g.copilot_no_tab_map = true
      vim.api.nvim_set_keymap("i", "<C-y>", 'copilot#Accept("<CR>")', { silent = true, expr = true, desc = "Accept Copilot suggestion" })

      vim.api.nvim_create_user_command("CopilotToggle", function()
        local copilot_status = vim.g.copilot_enabled
        if copilot_status == nil or copilot_status == 1 then
          vim.cmd("Copilot disable")
          vim.g.copilot_enabled = 0
          print("Copilot disabled")
        else
          vim.cmd("Copilot enable")
          vim.g.copilot_enabled = 1
          print("Copilot enabled")
        end
      end, { desc = "Toggle Copilot on/off" })

      vim.keymap.set("n", "<leader>cc", "<cmd>CopilotToggle<cr>", { desc = "[C]opilot toggle" })
    end,
  },
}
