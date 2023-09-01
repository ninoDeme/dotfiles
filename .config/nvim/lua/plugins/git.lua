return {
  {
    "NeogitOrg/neogit",
    config = true,
    opts = {},
    dependencies = {
      "nvim-lua/plenary.nvim",         -- required
      "nvim-telescope/telescope.nvim", -- optional
      "sindrets/diffview.nvim",        -- optional
    },
    cmd = {
      "NeoGit",
      "NeoGitMessages",
      "NeoGitResetState"
    },
    keys = {
      {'<leader>gg', function() require("neogit").open() end, 'Open NeoGit'}
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
      { mode = 'n', '<leader>gs', function() require("gitsigns").stage_hunk() end, desc = "Stage Hunk"},
      { mode = 'n', '<leader>gr', function() require("gitsigns").reset_hunk() end, desc = "Revert Hunk"},
      { mode = 'v', '<leader>gs', function() require("gitsigns").stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, desc = "Stage Hunk"},
      { mode = 'v', '<leader>gr', function() require("gitsigns").reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, desc = "Revert Hunk"},
      { mode = 'n', '<leader>gS', function() require("gitsigns").stage_buffer() end, desc = "Stage File"},
      { mode = 'n', '<leader>gR', function() require("gitsigns").reset_buffer() end, desc = "Revert File"},
      { mode = 'n', '<leader>gu', function() require("gitsigns").undo_stage_hunk() end, desc = "Undo Stage Hunk"},
      { mode = 'n', '<leader>gp', function() require("gitsigns").preview_hunk() end, desc = "Preview Hunk"},
      { mode = 'n', '<leader>gtb', function() require("gitsigns").toggle_current_line_blame() end, desc = "Toggle Current Line Blame"},
      { mode = 'n', '<leader>gtd', function() require("gitsigns").toggle_deleted() end, desc = "Toggle Show Deleted"},

      -- Text object
      { mode = {'o', 'x'}, 'ih', '<cmd><C-U>Gitsigns select_hunk<CR>'},
      { mode = {'o', 'x'}, 'ah', '<cmd><C-U>Gitsigns select_hunk<CR>'}
    },
    event = 'VeryLazy',
    cond = NOT_VSCODE
  }, -- Git stuff

}
