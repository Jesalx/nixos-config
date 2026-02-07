return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1000,
    opts = {
      flavour = 'mocha',
      transparent_background = true,
      float = {
        transparent = true,
      },
      color_overrides = {
        mocha = {
          -- Base colors (backgrounds) - darkest to main
          crust = '#121212', -- srcery hard_black (darkest)
          mantle = '#1C1B19', -- srcery black (main background)
          base = '#1C1B19', -- srcery black (keep same as mantle for consistency)

          -- Surface colors (UI elements) - progressive grays
          surface0 = '#262626', -- srcery xgray1
          surface1 = '#303030', -- srcery xgray2
          surface2 = '#3A3A3A', -- srcery xgray3

          -- Overlay colors (floating elements, borders)
          overlay0 = '#444444', -- srcery xgray4
          overlay1 = '#4E4E4E', -- srcery xgray5
          overlay2 = '#7c7c7c', -- srcery xgray6

          -- Text colors
          subtext0 = '#918175', -- srcery white (dimmed text)
          subtext1 = '#BAA67F', -- between white and bright_white
          text = '#FCE8C3', -- srcery bright_white (main text)

          -- Accent colors mapped to Srcery palette
          red = '#EF2F27', -- srcery red
          maroon = '#F75341', -- srcery bright_red
          peach = '#FF8700', -- srcery orange
          yellow = '#FBB829', -- srcery yellow
          -- green = "#519F50", -- srcery green
          green = '#6ec16c',
          teal = '#0AAEB3', -- srcery cyan
          sky = '#53FDE9', -- srcery bright_cyan
          sapphire = '#2C78BF', -- srcery blue
          blue = '#68A8E4', -- srcery bright_blue
          lavender = '#68A8E4', -- srcery bright_blue (duplicate for compatibility)
          mauve = '#d63e3c', -- srcery magenta
          pink = '#FF5C8F', -- srcery bright_magenta
          flamingo = '#FED06E', -- srcery bright_yellow
          rosewater = '#98BC37', -- srcery bright_green
        },
      },
      custom_highlights = function(colors)
        return {
          -- make it so that relative line numbers are the same color as comments
          LineNr = { fg = colors.overlay2 },

          -- Sneak highlights
          Sneak = { link = 'Search' },
          SneakCurrent = { link = 'CurSearch' },
          SneakScope = { link = 'Visual' },
          SneakLabel = { link = 'IncSearch' },
        }
      end,
    },
    config = function(_, opts)
      require('catppuccin').setup(opts)
      vim.cmd.colorscheme('catppuccin')
    end,
  },
}
