return {
  'ThePrimeagen/harpoon',
  lazy = true,
  keys = {
    {'<leader>t1', function() require("harpoon.term").gotoTerminal(1) end, desc = 'Open Terminal 1'},
    {'<leader>t2', function() require("harpoon.term").gotoTerminal(2) end, desc = 'Open Terminal 2'},
    {'<leader>t3', function() require("harpoon.term").gotoTerminal(3) end, desc = 'Open Terminal 3'},
    {'<leader>t4', function() require("harpoon.term").gotoTerminal(4) end, desc = 'Open Terminal 4'},
    {'<leader>t5', function() require("harpoon.term").gotoTerminal(5) end, desc = 'Open Terminal 5'},
    {'<leader>t6', function() require("harpoon.term").gotoTerminal(6) end, desc = 'Open Terminal 6'},
    {'<leader>t7', function() require("harpoon.term").gotoTerminal(7) end, desc = 'Open Terminal 7'},
    {'<leader>t8', function() require("harpoon.term").gotoTerminal(8) end, desc = 'Open Terminal 8'},
    {'<leader>t9', function() require("harpoon.term").gotoTerminal(9) end, desc = 'Open Terminal 9'},
    {'<leader>tP', function() require("harpoon.term").gotoTerminal(0) end, desc = 'Open Drawer Terminal in Current Window'},
    {'<leader>tc', function() require("harpoon.cmd-ui").toggle_quick_menu() end, desc = 'Open CMDs dialog'},
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

