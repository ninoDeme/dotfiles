return {
  'ThePrimeagen/harpoon',
  init = function()
    local create_drawer = function(term)
      term = term or tonumber(vim.fn.input("Terminal: ", "1"));
      vim.cmd[[botright split]]
      require("harpoon.term").gotoTerminal(term)
      vim.cmd.resize("10")
    end
    vim.keymap.set("n", "<leader>tp", create_drawer, {desc = "Create terminal drawer"})
  end,
  keys = {
    {'<leader>t1', function() require("harpoon.term").gotoTerminal(1) end, desc = 'Open Terminal 1 (harpoon)'},
    {'<leader>t2', function() require("harpoon.term").gotoTerminal(2) end, desc = 'Open Terminal 2 (harpoon)'},
    {'<leader>t3', function() require("harpoon.term").gotoTerminal(3) end, desc = 'Open Terminal 3 (harpoon)'},
    {'<leader>t4', function() require("harpoon.term").gotoTerminal(4) end, desc = 'Open Terminal 4 (harpoon)'},
    {'<leader>t5', function() require("harpoon.term").gotoTerminal(5) end, desc = 'Open Terminal 5 (harpoon)'},
    {'<leader>t6', function() require("harpoon.term").gotoTerminal(6) end, desc = 'Open Terminal 6 (harpoon)'},
    {'<leader>t7', function() require("harpoon.term").gotoTerminal(7) end, desc = 'Open Terminal 7 (harpoon)'},
    {'<leader>t8', function() require("harpoon.term").gotoTerminal(8) end, desc = 'Open Terminal 8 (harpoon)'},
    {'<leader>t9', function() require("harpoon.term").gotoTerminal(9) end, desc = 'Open Terminal 9 (harpoon)'},
    {'<leader>tc', function() require("harpoon.cmd-ui").toggle_quick_menu() end, desc = 'Open CMDs dialog'},
    {'<leader>mm', function() require("harpoon.mark").add_file() end, desc = 'Add File (harpoon)'},
    {'<leader>mo', function() require("harpoon.ui").toggle_quick_menu() end, desc = 'Open Menu (harpoon)'},
    {'<leader>m1', function() require("harpoon.ui").nav_file(1) end, desc = 'Open File 1 (harpoon)'},
    {'<leader>m2', function() require("harpoon.ui").nav_file(2) end, desc = 'Open File 2 (harpoon)'},
    {'<leader>m3', function() require("harpoon.ui").nav_file(3) end, desc = 'Open File 3 (harpoon)'},
    {'<leader>m4', function() require("harpoon.ui").nav_file(4) end, desc = 'Open File 4 (harpoon)'},
    {'<leader>m5', function() require("harpoon.ui").nav_file(5) end, desc = 'Open File 5 (harpoon)'},
    {'<leader>m6', function() require("harpoon.ui").nav_file(6) end, desc = 'Open File 6 (harpoon)'},
    {'<leader>m7', function() require("harpoon.ui").nav_file(7) end, desc = 'Open File 7 (harpoon)'},
  },
  dependencies = {
    'nvim-lua/plenary.nvim'
  }
}

