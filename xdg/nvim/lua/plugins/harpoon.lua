return {
  "ThePrimeagen/harpoon",
  keys = function()
    return {
      {
        "<leader>hH",
        function()
          require("harpoon"):list():append()
        end,
        desc = "Harpoon file",
      },
      {
        "<leader>hh",
        function()
          local harpoon = require("harpoon")
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = "Harpoon quick menu",
      },
      {
        "<leader>h1",
        function()
          require("harpoon"):list():select(1)
        end,
        desc = "Harpoon to file 1",
      },
      {
        "<leader>h2",
        function()
          require("harpoon"):list():select(2)
        end,
        desc = "Harpoon to file 2",
      },
      {
        "<leader>h3",
        function()
          require("harpoon"):list():select(3)
        end,
        desc = "Harpoon to file 3",
      },
      {
        "<leader>h4",
        function()
          require("harpoon"):list():select(4)
        end,
        desc = "Harpoon to file 4",
      },
      {
        "<leader>h5",
        function()
          require("harpoon"):list():select(5)
        end,
        desc = "Harpoon to file 5",
      },
    }
  end,
}
