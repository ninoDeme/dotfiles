return {
  'ThePrimeagen/harpoon',
  lazy = true,
  keys = {
    {'<leader>mm', function() require("harpoon.mark").add_file() end, desc = 'Add File'},
    {'<leader>mo', function() require("harpoon.ui").toggle_quick_menu() end, desc = 'Open Menu'},
    {'<leader>m1', function() require("harpoon.ui").nav_file(1) end, desc = 'Open File 1'},
    {'<leader>m2', function() require("harpoon.ui").nav_file(2) end, desc = 'Open File 2'},
    {'<leader>m3', function() require("harpoon.ui").nav_file(3) end, desc = 'Open File 3'},
    {'<leader>m4', function() require("harpoon.ui").nav_file(4) end, desc = 'Open File 4'},
    {'<leader>m5', function() require("harpoon.ui").nav_file(5) end, desc = 'Open File 5'},
    {'<leader>m6', function() require("harpoon.ui").nav_file(6) end, desc = 'Open File 6'},
    {'<leader>m7', function() require("harpoon.ui").nav_file(7) end, desc = 'Open File 7'},
  },
  dependencies = {
    'nvim-lua/plenary.nvim'
  }
}

