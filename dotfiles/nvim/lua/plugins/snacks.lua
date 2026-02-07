return {
  'folke/snacks.nvim',

  priority = 1000,
  lazy = false,
  opts = {
    toggle = {
      which_key = true,
    },
    input = {},
    notifier = {},
    lazygit = {},
    indent = {},
    dashboard = {
      preset = {
        keys = {
          { icon = ' ', key = 'f', desc = 'Find File', action = ':lua Snacks.picker.files()' },
          { icon = ' ', key = '/', desc = 'Find Text', action = ':lua Snacks.picker.grep()' },
          { icon = ' ', key = 'n', desc = 'New File', action = ':ene | startinsert' },
          { icon = ' ', key = 'c', desc = 'Config', action = ":lua Snacks.picker.files({ cwd = vim.fn.expand('~/.config') })" },
          { icon = '󰒲 ', key = 'l', desc = 'Lazy', action = ':Lazy' },
          { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
        },
      },
    },
    explorer = {
      replace_netrw = true,
      win = {
        border = 'rounded',
      },
    },
    picker = {
      sources = {
        explorer = {
          layout = { preset = 'sidebar', preview = false },
          hidden = true,
        },
      },
    },
    terminal = {
      win = {
        style = 'terminal',
        position = 'float',
        width = 0.8,
        height = 0.8,
        border = 'rounded',
        relative = 'editor',
      },
      persistent = true,
      autoinsert = true,
    },
    bigfile = {},
    quickfile = {},
    gh = {},
  },
  keys = {
    -- Smart file search (buffers, project files)
    {
      '<leader><leader>',
      function()
        Snacks.picker.smart({
          multi = {
            'buffers',
            {
              source = 'files',
              cwd = vim.fn.getcwd(),
              hidden = true,
              ignore = { '**/.jj/**' },
            },
          },
        })
      end,
      desc = '[ ] Search Files',
    },
    -- Grep (live grep)
    {
      '<leader>/',
      function()
        Snacks.picker.grep({ hidden = true })
      end,
      desc = '[/] Search by Grep',
    },

    -- Help and keymaps
    {
      '<leader>sh',
      function()
        Snacks.picker.help()
      end,
      desc = '[S]earch [H]elp',
    },
    {
      '<leader>sk',
      function()
        Snacks.picker.keymaps()
      end,
      desc = '[S]earch [K]eymaps',
    },

    -- File pickers
    {
      '<leader>sf',
      function()
        Snacks.picker.files()
      end,
      desc = '[S]earch [F]iles',
    },
    {
      '<leader>s.',
      function()
        Snacks.picker.recent()
      end,
      desc = '[S]earch Recent Files (["."] for repeat)',
    },

    -- Word + Grep
    {
      '<leader>sw',
      function()
        Snacks.picker.grep_word()
      end,
      desc = '[S]earch current [W]ord',
    },
    {
      '<leader>sg',
      function()
        Snacks.picker.grep()
      end,
      desc = '[S]earch by [G]rep',
    },

    -- LSP + diagnostics
    {
      '<leader>sd',
      function()
        Snacks.picker.diagnostics()
      end,
      desc = '[S]earch [D]iagnostics',
    },

    -- Resume last picker
    {
      '<leader>sr',
      function()
        Snacks.picker.resume()
      end,
      desc = '[S]earch [R]esume',
    },

    -- Picker picker
    {
      '<leader>ss',
      function()
        Snacks.picker()
      end,
      desc = '[S]earch [S]elect Picker',
    },

    -- open Snacks explorer (like NeoTree)
    {
      '<leader>e',
      function()
        Snacks.explorer.open()
      end,
      desc = '[E]xplorer',
    },

    {
      '<leader>n',
      function()
        Snacks.picker.notifications()
      end,
      desc = '[N]otification History',
    },

    {
      '<leader>gi',
      function()
        Snacks.picker.gh_issue()
      end,
      desc = 'GitHub Issues (open)',
    },
    {
      '<leader>gI',
      function()
        Snacks.picker.gh_issue({ state = 'all' })
      end,
      desc = 'GitHub Issues (all)',
    },
    {
      '<leader>gp',
      function()
        Snacks.picker.gh_pr()
      end,
      desc = 'GitHub Pull Requests (open)',
    },
    {
      '<leader>gP',
      function()
        Snacks.picker.gh_pr({ state = 'all' })
      end,
      desc = 'GitHub Pull Requests (all)',
    },

    {
      '<leader>.',
      function()
        Snacks.terminal.toggle()
      end,
      desc = 'Toggle floating terminal',
    },
    {
      '<esc><esc>',
      '<C-\\><C-n>',
      mode = 't',
      desc = 'Exit terminal mode',
    },
  },
}
