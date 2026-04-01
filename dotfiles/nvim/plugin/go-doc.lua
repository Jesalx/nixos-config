vim.keymap.set('n', '<leader>sg', function()
  local origin_buf = vim.api.nvim_get_current_buf()

  MiniPick.start({
    source = {
      name = 'Go Documentation',
      items = function()
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

        return all_pkgs
      end,

      preview = function(buf_id, item)
        vim.system({ 'go', 'doc', item }, { text = true }, function(result)
          vim.schedule(function()
            if not vim.api.nvim_buf_is_valid(buf_id) then
              return
            end
            vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, vim.split(result.stdout or '', '\n'))
            vim.bo[buf_id].filetype = 'godoc'
            vim.treesitter.start(buf_id, 'go')
          end)
        end)
      end,

      choose = function(item)
        if not item then
          return
        end
        local doc = vim.system({ 'go', 'doc', '-all', item }, { text = true }):wait()
        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(doc.stdout or '', '\n'))
        vim.bo[buf].filetype = 'godoc'
        vim.bo[buf].modifiable = false
        vim.bo[buf].buftype = 'nofile'
        vim.bo[buf].swapfile = false

        local wide = vim.o.columns > vim.o.lines * 2
        local win
        if wide then
          win = vim.api.nvim_open_win(buf, true, { split = 'right' })
        else
          -- Take over the full window; q closes and returns to the previous buffer
          win = vim.api.nvim_get_current_win()
          vim.api.nvim_win_set_buf(win, buf)
          vim.keymap.set('n', 'q', function()
            if vim.api.nvim_buf_is_valid(origin_buf) then
              vim.api.nvim_win_set_buf(win, origin_buf)
            end
            vim.api.nvim_buf_delete(buf, { force = true })
          end, { buffer = buf, desc = 'Close Go docs' })
        end

        vim.treesitter.start(buf, 'go')
        vim.wo[win].number = false
        vim.wo[win].relativenumber = false
      end,
    },
  })
end, { desc = '[S]earch [G]o documentation' })
