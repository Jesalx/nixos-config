-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "[Q]uickfix list" })

-- Exit terminal mode with double <Esc>
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Automatically center when using C-d or C-u
vim.keymap.set({ "n", "x" }, "<C-d>", "<C-d>zz", { noremap = true, silent = true })
vim.keymap.set({ "n", "x" }, "<C-u>", "<C-u>zz", { noremap = true, silent = true })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.keymap.set("n", "<leader>d", function()
  vim.cmd('silent! normal! gg"_dG')
end, { desc = "[D]elete buffer content" })
vim.keymap.set("n", "<leader>y", ":%y<CR>", { desc = "[Y]ank buffer" })

-- Toggle autoformat on save
vim.keymap.set("n", "<leader>tf", "<cmd>ToggleFormat<CR>", { desc = "[T]oggle [F]ormat on save" })

-- Restart Neovim
vim.keymap.set('n', '<leader>R', '<cmd>restart<cr>', { desc = '[R]estart Neovim' })

-- Open package manager
vim.keymap.set('n', '<leader>L', '<cmd>Lazy<cr>', { desc = 'Lazy' })
