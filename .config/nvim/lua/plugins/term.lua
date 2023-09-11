return {
  {
    'akinsho/toggleterm.nvim',
    config = function()
      require("toggleterm").setup({
        persist_size = false,
        shade_terminals = false,
        winbar = {
          enabled = true
        }
      })
      local tmuxTerm
      local function toggle_tmux()
        if not tmuxTerm then
          tmuxTerm = require("toggleterm.terminal").Terminal:new({
            cmd = "tmux new-session -A -s '" .. vim.uv.cwd() .. "'\n",
            hidden = false,
            display_name = "Tmux Session",
            id = 1
          })
        end
        tmuxTerm:toggle()
      end

      local terms = {}
      local function lim(opts)

        opts = opts or {}
        local pickers = require "telescope.pickers"
        local finders = require "telescope.finders"
        local conf = require("telescope.config").values
        local actions = require "telescope.actions"
        local action_state = require "telescope.actions.state"

        local scan = require("plenary.scandir")
        local Path = require("plenary.path")
        local folders = scan.scan_dir(vim.uv.cwd(), { hidden = false, only_dirs = true, depth = 1 })
        local Terminal = require("toggleterm.terminal").Terminal
        local picker = pickers.new(opts, {
          prompt_title = "Start",
          layout_strategy = "bottom_pane",
          finder = finders.new_table({
            results = folders
          }),
          sorter = conf.generic_sorter(opts),
          attach_mappings = function (prompt_bufnr, map)
            actions.select_default:replace(function()
              local picker = action_state.get_current_picker(prompt_bufnr)
              actions.close(prompt_bufnr)

              local selection = picker:get_multi_selection()

              if not selection or #selection == 0 then
                selection = {
                  action_state.get_selected_entry()
                }
              end

              vim.print(vim.inspect(selection))
              for _,v in ipairs(selection) do
                local path = Path.make_relative(Path.new(v[1]), vim.uv.cwd())

                if terms[path] then
                  -- terms[path]:send({"", "pnpm start"}, true)
                else
                  terms[path] = Terminal:new({
                    cmd = 'pnpm start',
                    dir = path,
                    -- id = (#terms + 1),
                    hidden = false,
                    display_name = path,
                    auto_scroll = true,
                    close_on_exit = true,
                    on_exit = function()
                      terms[path] = nil
                    end
                  })
                end
                terms[path]:toggle()

              end
            end)
            return true
          end,
        })
        picker:find()
      end
      vim.keymap.set('n', '<leader>tp', toggle_tmux, {desc = "Toggle Tmux Terminal"})

      vim.keymap.set('n', '<leader>th', lim, {desc = "Toggle asd Terminal"})
    end,
    cond = NOT_VSCODE,
    keys = {
      {'<leader>t1', "<cmd>ToggleTerm 1<CR>", desc = 'Toggle Terminal 1'},
      {'<leader>t2', "<cmd>ToggleTerm 2<CR>", desc = 'Toggle Terminal 2'},
      {'<leader>t3', "<cmd>ToggleTerm 3<CR>", desc = 'Toggle Terminal 3'},
      {'<leader>t4', "<cmd>ToggleTerm 4<CR>", desc = 'Toggle Terminal 4'},
      {'<leader>t5', "<cmd>ToggleTerm 5<CR>", desc = 'Toggle Terminal 5'},
      {'<leader>t6', "<cmd>ToggleTerm 6<CR>", desc = 'Toggle Terminal 6'},
      {'<leader>t7', "<cmd>ToggleTerm 7<CR>", desc = 'Toggle Terminal 7'},
      {'<leader>t8', "<cmd>ToggleTerm 8<CR>", desc = 'Toggle Terminal 8'},
      {'<leader>t9', "<cmd>ToggleTerm 9<CR>", desc = 'Toggle Terminal 9'},
      {'<leader>st', "<cmd>TermSelect <CR>", desc = 'Select Terminal'},
      {'<leader>tp', desc = "Toggle Tmux Terminal"},
      {'<leader>th', desc = "Toggle asd Terminal"},
      -- {'<leader>tP', function() require("harpoon.term").gotoTerminal(0) end, desc = 'Open Drawer Terminal in Current Window'},
      {'<leader>tt', '<cmd>ToggleTerm<CR>', desc = "Toggle Terminal Popup"}
    }
  }
}
