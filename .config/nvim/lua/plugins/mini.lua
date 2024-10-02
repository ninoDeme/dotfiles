return {
  {
    "echasnovski/mini.nvim",
    lazy = false,
    config = function()
      -- require("mini.files").setup({
      --   mappings = {
      --     close       = 'q',
      --     go_in       = '<c-l>',
      --     go_in_plus  = 'L',
      --     go_out      = '<c-h>',
      --     go_out_plus = 'H',
      --     reset       = '<BS>',
      --     reveal_cwd  = '@',
      --     show_help   = 'g?',
      --     synchronize = '=',
      --     trim_left   = '<',
      --     trim_right  = '>',
      --   },
      --   windows = {
      --     -- Whether to show preview of file/directory under cursor
      --     preview = true,
      --     -- Width of preview window
      --     width_preview = 60,
      --   }
      -- })

      require("mini.surround").setup({
        -- mappings = {
        --   add = "gsa", -- Add surrounding in Normal and Visual modes
        --   delete = "gsd", -- Delete surrounding
        --   find = "gsf", -- Find surrounding (to the right)
        --   find_left = "gsF", -- Find surrounding (to the left)
        --   highlight = "gsh", -- Highlight surrounding
        --   replace = "gsr", -- Replace surrounding
        --   update_n_lines = "gsn", -- Update `n_lines`
        --
        --   suffix_last = "l", -- Suffix to search with "prev" method
        --   suffix_next = "n", -- Suffix to search with "next" method
        -- },
        n_lines = 5000,

        respect_selection_type = true,
      })

      -- require('mini.cursorword').setup()
      require('mini.notify').setup({
        window = {
          config = {
            border = require("hover").border
          }
        }
      })
      require("mini.bracketed").setup()

      local imap_expr = function(lhs, rhs)
        vim.keymap.set('i', lhs, rhs, { expr = true })
      end
      imap_expr('<Tab>', [[pumvisible() ? "\<C-n>" : "\<Tab>"]])
      imap_expr('<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]])

      local opts = { ERROR = { duration = 10000 } }
      vim.notify = require('mini.notify').make_notify(opts)
      require("mini.align").setup()
      require("mini.splitjoin").setup()
      require("mini.operators").setup({
        exchange = {
          prefix = "cx",
        },
      })
    end,
    keys = {
      { mode = "n", "gR", "gr$", remap = true },
      { mode = "n", "cX", "cx$", remap = true },
      -- {
      --   "<leader>me",
      --   function()
      --     require("mini.files").open()
      --   end,
      --   desc = "Open Mini Files",
      -- },
      -- {
      --   "<leader>m.",
      --   function()
      --     require("mini.files").open(vim.fn.expand("%:p:h"))
      --   end,
      --   desc = "Open Mini Files at dir",
      -- },
      -- { "gs", desc = "+Surrounding" },
      -- { mode = { "n", "v" }, "sa", desc = "Add surrounding" },
      -- { mode = "n", "sd", desc = "Delete surrounding" },
      -- { mode = "n", "sf", desc = "Find surrounding (to the right)" },
      -- { mode = "n", "sF", desc = "Find surrounding (to the left)" },
      -- { mode = "n", "sh", desc = "Highlight surrounding" },
      -- { mode = "n", "sr", desc = "Replace surrounding" },
      -- { mode = "n", "sn", desc = "Update `n_lines`" },
    },
  },
}
