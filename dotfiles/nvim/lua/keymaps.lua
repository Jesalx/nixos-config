--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = '[Q]uickfix list' })

-- Exit terminal mode with double <Esc>
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keep cursor centered
vim.keymap.set({ 'n', 'x' }, '<C-d>', '<C-d>zz', { desc = 'Scroll downwards' })
vim.keymap.set({ 'n', 'x' }, '<C-u>', '<C-u>zz', { desc = 'Scroll upwards' })
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Next result' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Previous result' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('n', '<leader>D', function()
  vim.cmd('silent! normal! gg"_dG')
end, { desc = '[D]elete buffer content' })
vim.keymap.set('n', '<leader>y', ':%y<CR>', { desc = '[Y]ank buffer' })

-- Toggle autoformat on save
vim.keymap.set('n', '<leader>tf', '<cmd>ToggleFormat<CR>', { desc = '[T]oggle [F]ormat on save' })

-- Restart Neovim
vim.keymap.set('n', '<leader>R', '<cmd>restart<cr>', { desc = '[R]estart Neovim' })

-- Open package manager
vim.keymap.set('n', '<leader>L', '<cmd>Lazy<cr>', { desc = 'Lazy' })

-- TODO: move this out of keymaps.lua to a more appropriate place
vim.keymap.set('n', '<leader>dg', function()
  Snacks.picker.pick({
    title = 'Go Documentation',
    finder = function()
      local stdlib = vim.system({ 'go', 'list', 'std' }, { text = true }):wait()
      local project = vim.system({ 'go', 'list', './...' }, { text = true }):wait()

      local all_pkgs = {}

      if stdlib.code == 0 then
        vim.list_extend(all_pkgs, vim.split(stdlib.stdout, '\n', { trimempty = true }))
      end

      -- ./... silently skipped if not inside a Go module
      if project.code == 0 then
        vim.list_extend(all_pkgs, vim.split(project.stdout, '\n', { trimempty = true }))
      end

      if #all_pkgs == 0 then
        vim.notify('go list returned no packages', vim.log.levels.WARN)
        return {}
      end

      return vim.tbl_map(function(pkg)
        return { text = pkg }
      end, all_pkgs)
    end,
    format = 'text',

    -- ctx.buf is the preview buffer; ctx.item is the focused item
    preview = function(ctx)
      if not ctx or not ctx.item then
        return
      end
      local item_text = ctx.item.text
      vim.system({ 'go', 'doc', item_text }, { text = true }, function(result)
        vim.schedule(function()
          if not ctx.buf or not vim.api.nvim_buf_is_valid(ctx.buf) then
            return
          end
          vim.bo[ctx.buf].modifiable = true
          vim.api.nvim_buf_set_lines(ctx.buf, 0, -1, false, vim.split(result.stdout or '', '\n'))
          vim.bo[ctx.buf].modifiable = false
          vim.bo[ctx.buf].filetype = 'godoc'
          vim.treesitter.start(ctx.buf, 'go')
        end)
      end)
    end,

    -- Confirm: open full `-all` docs in a split, direction based on terminal dimensions
    confirm = function(picker, item)
      picker:close()
      if not item then
        return
      end
      local doc = vim.system({ 'go', 'doc', '-all', item.text }, { text = true }):wait()
      local buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(doc.stdout or '', '\n'))
      vim.bo[buf].filetype = 'godoc'
      vim.bo[buf].modifiable = false
      vim.bo[buf].buftype = 'nofile'
      vim.bo[buf].swapfile = false

      -- Split right in wide/landscape layouts, below in tall/portrait layouts
      local split_dir = vim.o.columns > vim.o.lines * 2 and 'right' or 'below'
      local win = vim.api.nvim_open_win(buf, true, { split = split_dir })

      vim.treesitter.start(buf, 'go')
      vim.wo[win].number = false
      vim.wo[win].relativenumber = false
    end,
  })
end, { desc = 'Go documentation' })
