return {
  {
    "nvim-telescope/telescope.nvim", -- Fuzzy finder over lists
    lazy = true,
    cmd = "Telescope",
    config = function() -- Shamelessly stolen from github.com/NvChad/NvChad
      local telescope = require("telescope")
      local telescope_actions = require("telescope.actions")
      -- local action_state = require("telescope.actions.state")
      local fb_actions = require("telescope").extensions.file_browser.actions
      telescope.setup({
        defaults = {
          prompt_prefix = "   ",
          selection_caret = "  ",
          entry_prefix = "  ",
          initial_mode = "insert",
          selection_strategy = "reset",
          bottom_pane = {
            theme = "ivy",
          },
          file_ignore_patterns = { "node_modules" },
          path_display = { "truncate" },
          -- border = {},
          -- borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
          color_devicons = true,
          set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
          mappings = {
            n = {
              ["q"] = telescope_actions.close,
              ["<C-Down>"] = telescope_actions.cycle_history_next,
              ["<C-Up>"] = telescope_actions.cycle_history_prev,
              ["<C-k>"] = telescope_actions.move_selection_previous,
              ["<C-j>"] = telescope_actions.move_selection_next,
              ["<C-l>"] = telescope_actions.select_default,
              ["l"] = telescope_actions.select_default,
            },
            i = {
              ["<C-k>"] = telescope_actions.move_selection_previous,
              ["<C-j>"] = telescope_actions.move_selection_next,
              ["<C-Down>"] = telescope_actions.cycle_history_next,
              ["<C-Up>"] = telescope_actions.cycle_history_prev,
              ["<C-l>"] = telescope_actions.select_default,
              -- ["<C-m>"] = function(prompt_bufnr)
              --   local current_picker = action_state.get_current_picker(prompt_bufnr) -- picker state
              --   vim.notify(vim.inspect(current_picker))
              -- end
            },
          },
        },
        pickers = {
          buffers = {
            mappings = {
              n = {
                ["<C-x>"] = telescope_actions.delete_buffer,
              },
              i = {
                ["x"] = telescope_actions.delete_buffer,
                ["<C-x>"] = telescope_actions.delete_buffer,
              },
            },
          },
          find_files = {
            hidden = true,
          },
          live_grep = {
            additional_args = { "-." },
          },
        },
        extensions = {
          file_browser = {
            hidden = true,
            hijack_netrw = false,
            no_ignore = true,
            respect_gitignore = false,
            dir_icon = "",
            grouped = true,
            prompt_path = true,
            mappings = {
              n = {
                ["h"] = fb_actions.goto_parent_dir,
                ["<C-h>"] = fb_actions.goto_parent_dir,
                ["."] = fb_actions.toggle_hidden,
              },
              i = {
                ["<C-h>"] = fb_actions.goto_parent_dir,
                ["<C-.>"] = fb_actions.toggle_hidden,
              },
            },
          },
          ["zf-native"] = {
            file = {
              -- enable zf filename match priority
              match_filename = true,
            }
          },
          project = {
            base_dirs = {
              { "~/Projects", max_depth = 2 }
            },
            hidden_files = true,
            -- { 'tab' }
          }
        },
      })

      require("telescope").load_extension("file_browser")

      require("telescope").load_extension("zf-native")
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "natecraddock/telescope-zf-native.nvim",
    },
    cond = NOT_VSCODE,
    keys = {
      { "<leader>ss", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
      { "<leader>sb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Highlights" },
      { "<leader>sr", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
      { "<leader>ch", "<cmd>Telescope quickfixhistory<cr>", desc = "History" },
      { "<leader>sc", "<cmd>Telescope quickfixhistory<cr>", desc = "Quickfix History" },
      {
        "<leader>sd",
        function()
          require("telescope.builtin").diagnostics({ severity_limit = vim.diagnostic.severity.HINT })
        end,
        desc = "Diagnostics",
      },
      {
        "<leader>sD",
        function()
          require("telescope.builtin").diagnostics({ severity_limit = vim.diagnostic.severity.ERROR })
        end,
        desc = "Errors",
      },
      { "<leader>,", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      {
        "<leader>gb",
        function()
          require("telescope.builtin").git_branches()
        end,
        desc = "Branches",
      },
      { "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader><leader>", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>sF", function() require("telescope.builtin").find_files({find_command = {'fd', '--type', 'd', '--color', 'never'}}) end, desc = "Find Folders" },
    },
  },
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    lazy = true,
    event = "VeryLazy",
    cond = NOT_VSCODE,
    keys = {
      {
        "<leader>.",
        "<cmd>Telescope file_browser path=%:p:h select_buffer=true<CR>",
        desc = "File Browser (current dir)",
      },
      { "<leader>e", "<cmd>Telescope file_browser<CR>", desc = "File Browser (root)" },
    },
  },
  {
    'prochri/telescope-all-recent.nvim',
    event = "VeryLazy",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "kkharji/sqlite.lua",
    },
    opts =
      {
        -- your config goes here
      }
  },
  {
    'nvim-telescope/telescope-project.nvim',
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    event = "VeryLazy",
    config = function ()
      require'telescope'.load_extension('project')
    end,
    keys = {
      { "<leader>sp", function () require'telescope'.extensions.project.project{} end, desc = "Projects" }
    }
  }
}
