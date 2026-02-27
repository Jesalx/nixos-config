return {
  name = 'go-doc',
  dir = vim.fn.stdpath('config'),
  lazy = false,
  keys = {
    {
      '<leader>dg',
      function()
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

          -- Confirm: open full `-all` docs in a split or full window
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

            local wide = vim.o.columns > vim.o.lines * 2
            local win
            if wide then
              win = vim.api.nvim_open_win(buf, true, { split = 'right' })
            else
              -- Take over the full window; q closes and returns to the previous buffer
              local prev_buf = vim.api.nvim_get_current_buf()
              win = vim.api.nvim_get_current_win()
              vim.api.nvim_win_set_buf(win, buf)
              vim.keymap.set('n', 'q', function()
                vim.api.nvim_win_set_buf(win, prev_buf)
                vim.api.nvim_buf_delete(buf, { force = true })
              end, { buffer = buf, desc = 'Close Go docs' })
            end

            vim.treesitter.start(buf, 'go')
            vim.wo[win].number = false
            vim.wo[win].relativenumber = false
          end,
        })
      end,
      desc = 'Go documentation',
    },
  },
}
