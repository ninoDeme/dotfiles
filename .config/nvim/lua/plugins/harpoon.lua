return {
  'ThePrimeagen/harpoon',
  init = function()
    local create_drawer = function(term, win)
      if not win then
        vim.cmd[[botright split]]
        vim.cmd.resize("10")
      else
        vim.api.nvim_set_current_win(win)
      end
      require("harpoon.term").gotoTerminal(term)
      return vim.api.nvim_get_current_win()
    end

    local currTerm = nil
    local currBuffr = nil

    local function create_terminal()
      if currTerm and not vim.api.nvim_win_is_valid(currTerm) then
        currTerm = nil
      end
      currTerm = create_drawer(0, currTerm)
      if not currBuffr or not vim.api.nvim_buf_is_loaded(currBuffr) then
        require("harpoon.term").sendCommand(0, "tmux new-session -A -s '" .. vim.uv.cwd() .. "'\n")
      end
      currBuffr = vim.api.nvim_win_get_buf(0)
    end
    vim.keymap.set("n", "<leader>tp", create_terminal, {desc = "Create terminal drawer"})
  end,
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

