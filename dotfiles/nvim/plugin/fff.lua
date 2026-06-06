vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == 'fff.nvim' and (kind == 'install' or kind == 'update') then
      if not ev.data.active then
        vim.cmd.packadd('fff.nvim')
      end
      require('fff.download').download_or_build_binary()
    end
  end,
  desc = 'Download or build fff.nvim binary after install/update',
})

vim.pack.add({ 'https://github.com/dmtrKovalenko/fff.nvim' })

require('fff').setup({
  prompt = '  ',
  title = 'Files',
  layout = {
    prompt_position = 'top',
  },
})
