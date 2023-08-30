return {
  {
    'nvim-telescope/telescope.nvim', -- Fuzzy finder over lists
    init = function ()
      require('which-key').register({
        s  = { name = 'Telescope', }
      }, {prefix = '<leader>'})
    end,
    lazy = false,
    cmd = "Telescope",
    config = function () -- Shamelessly stolen from github.com/NvChad/NvChad 
      local telescope = require("telescope")
      local telescope_actions = require("telescope.actions")
      local fb_actions = require("telescope").extensions.file_browser.actions
      telescope.setup({
        defaults = {
          prompt_prefix = "   ",
          selection_caret = "  ",
          entry_prefix = "  ",
          initial_mode = "insert",
          selection_strategy = "reset",
          sorting_strategy = "ascending",
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
              results_width = 0.8,
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          -- file_sorter = require("telescope.sorters").get_fuzzy_file,
          file_ignore_patterns = { "node_modules" },
          generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
          path_display = { "truncate" },
          winblend = 0,
          border = {},
          borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
          color_devicons = true,
          set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
          file_previewer = require("telescope.previewers").vim_buffer_cat.new,
          grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
          qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
          -- Developer configurations: Not meant for general override
          buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
          mappings = {
            n = {
              ["q"] = telescope_actions.close,
              ['x'] = telescope_actions.delete_buffer
            },
            i = {
              ['<c-x>'] = telescope_actions.delete_buffer,
              ["<C-k>"] = telescope_actions.move_selection_previous,
              ["<C-j>"] = telescope_actions.move_selection_next,
              ["<C-l>"] = telescope_actions.select_default,
            }
          },

        },
        extensions = {
          file_browser  = {
            hijack_netrw = true,
            mappings = {
              n = {
                ["h"] = fb_actions.goto_parent_dir,
                ["l"] = telescope_actions.select_default,
                ["."] = fb_actions.toggle_hidden
              },
              i = {
                ["<C-h>"] = fb_actions.goto_parent_dir,
                ["<C-k>"] = telescope_actions.move_selection_previous,
                ["<C-j>"] = telescope_actions.move_selection_next,
                ["<C-l>"] = telescope_actions.select_default,
                ["<C-.>"] = fb_actions.toggle_hidden
              }
            }
          },
        }
      })

      require("telescope").load_extension("file_browser")
    end,
    dependencies = 'nvim-lua/plenary.nvim',
    cond = NOT_VSCODE,
    keys = {
      {"<leader>ss", "<cmd>Telescope live_grep<cr>", desc = 'Grep' },
      {"<leader>sb", "<cmd>Telescope buffers<cr>", desc = 'Buffers' },
      {"<leader>sf", "<cmd>Telescope find_files<cr>", desc = 'Find Files' },
      {"<leader>sh", "<cmd>Telescope highlights<cr>", desc = 'Highlights' },
    }
  },
  {
    'natecraddock/telescope-zf-native.nvim',
    config = function ()
      require("telescope").load_extension("zf-native")
    end,
    dependencies = 'nvim-telescope/telescope.nvim',
    cond = NOT_VSCODE
  },
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    cond = NOT_VSCODE,
    keys = {
      {'<leader>.', '<cmd>Telescope file_browser path=%:p:h select_buffer=true<CR>', desc = "File Browser (current dir)"},
      {'<leader>se', '<cmd>Telescope file_browser<CR>', desc = "File Browser (root)"}
    }
  }
}
