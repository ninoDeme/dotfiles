return {
  {
    "NeogitOrg/neogit",
    config = true,
    enabled = false,
    opts = {
      -- graph_style = "unicode",
      integrations = {
        telescope = true,
        diffview = true,
      },
    },
    branch = 'master',
    dependencies = {
      "nvim-lua/plenary.nvim",         -- required
      "nvim-telescope/telescope.nvim", -- optional
      "sindrets/diffview.nvim",        -- optional
    },
    cmd = {
      "NeoGit",
      "NeoGitResetState"
    },
    keys = {
      {'<leader>gg', function() require("neogit").open() end, desc = 'Open NeoGit'}
    },
    cond = NOT_VSCODE
  },
  {
    'lewis6991/gitsigns.nvim',
    config = function ()
      require('gitsigns').setup {
        signcolumn = true,
        numhl = true,
        current_line_blame = true,
      }
    end,
    keys = {
      { mode = 'n', '<leader>gd', function() require("gitsigns").diffthis() end, desc = "Open File Diff"},
      { mode = 'n', '<leader>gs', function() require("gitsigns").stage_hunk() end, desc = "Stage Hunk"},
      { mode = 'n', '<leader>gr', function() require("gitsigns").reset_hunk() end, desc = "Revert Hunk"},
      { mode = 'v', '<leader>gs', function() require("gitsigns").stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, desc = "Stage Hunk"},
      { mode = 'v', '<leader>gr', function() require("gitsigns").reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, desc = "Revert Hunk"},
      { mode = 'n', '<leader>gS', function() require("gitsigns").stage_buffer() end, desc = "Stage File"},
      { mode = 'n', '<leader>gR', function() require("gitsigns").reset_buffer() end, desc = "Revert File"},
      { mode = 'n', '<leader>gu', function() require("gitsigns").undo_stage_hunk() end, desc = "Undo Stage Hunk"},
      { mode = 'n', '<leader>gp', function() require("gitsigns").preview_hunk() end, desc = "Preview Hunk"},
      { mode = 'n', '<leader>gh', function() require("gitsigns").blame_line({full = true}) end, desc = "Git Blame Hover"},
      { mode = 'n', '<leader>gtb', function() require("gitsigns").toggle_current_line_blame() end, desc = "Toggle Current Line Blame"},
      { mode = 'n', '<leader>gtd', function() require("gitsigns").toggle_deleted() end, desc = "Toggle Show Deleted"},
      { mode = 'n', '<leader>gtl', function() require("gitsigns").toggle_linehl() end, desc = "Toggle Line Highlight"},
      { mode = 'n', '<leader>gtw', function() require("gitsigns").toggle_word_diff() end, desc = "Toggle Word Diff"},

      -- Text object
      { mode = {'o', 'x'}, 'ih', '<cmd><C-U>Gitsigns select_hunk<CR>'},
      { mode = {'o', 'x'}, 'ah', '<cmd><C-U>Gitsigns select_hunk<CR>'}
    },
    event = 'VeryLazy',
    cond = NOT_VSCODE
  }, -- Git stuff

  -- {
  --   "kdheepak/lazygit.nvim",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --   },
  --   keys = {
  --     {"<leader>gG", "<cmd>LazyGitCurrentFile<CR>", desc = "LazyGitCurrent"},
  --     {"<leader>gG", "<cmd>LazyGitCurrentFile<CR>", desc = "LazyGitCurrent"}
  --   }
  -- },
  {
    "tpope/vim-fugitive",
    event = "VeryLazy",
  },
  {
    'fredeeb/tardis.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = {
      'Tardis'
    },
    keys = {
      { mode = 'n', '<leader>gt', '<cmd>:Tardis git<cr>', desc = 'Open tardis Time machine' }
    },
    opts = {}
  }
}
