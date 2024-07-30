return {
  -- {
  --   "vigoux/notifier.nvim",
  --   event = "VeryLazy",
  --   config = function()
  --     require'notifier'.setup {}
  --   end,
  --   cond = NOT_VSCODE
  --
  -- },
  {
    enabled = false,
    "j-hui/fidget.nvim",
    event = "VeryLazy",
    opts = {
      notification = {
        override_vim_notify = true, -- Automatically override vim.notify() with Fidget
      },
    },
  },
  -- {
  --   'kevinhwang91/nvim-bqf',
  --   config = function()
  --     require("bqf").setup({
  --       preview = {
  --         winblend = 0,
  --         border = require("hover").border
  --       }
  --     })
  --   end,
  --   ft = 'qf',
  --   cond = NOT_VSCODE
  -- },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = "VeryLazy",
    config = function()
      -- local hooks = require("ibl.hooks")
      -- hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)

      require("ibl").setup({
        enabled = true,
        exclude = {
          filetypes = {
            "help",
            "terminal",
            "lazy",
            "lspinfo",
            "TelescopePrompt",
            "TelescopeResults",
            "mason",
            "alpha",
            "",
          },
          buftypes = {
            "terminal",
          },
        },

        indent = {
          char = "│",
          -- char = "▎",
          highlight = "IblChar",
        },

        scope = {
          char = "│",
          -- char = "▎",
          highlight = "IblScopeChar",
        },
      })
    end,
    cond = NOT_VSCODE,
  },
  -- {
  -- 	"yorickpeterse/nvim-pqf",
  -- 	event = "VeryLazy",
  -- 	opts = {
  -- 		signs = {
  -- 			error = { text = " ", hl = "DiagnosticSignError" },
  -- 			warning = { text = " ", hl = "DiagnosticSignWarn" },
  -- 			info = { text = " ", hl = "DiagnosticSignInfo" },
  -- 			hint = { text = " ", hl = "DiagnosticSignHint" },
  -- 		},
  -- 		-- By default, only the first line of a multi line message will be shown. When this is true, multiple lines will be shown for an entry, separated by a space
  -- 		show_multiple_lines = false,
  -- 		-- How long filenames in the quickfix are allowed to be. 0 means no limit. Filenames above this limit will be truncated from the beginning with `filename_truncate_prefix`.
  -- 		max_filename_length = 0,
  -- 		-- Prefix to use for truncated filenames.
  -- 		filename_truncate_prefix = "[...]",
  -- 	},
  -- },
  -- {
  --   'rcarriga/nvim-notify',
  --   init = function()
  --     vim.notify = require("notify")
  --   end
  -- }
  -- {'stevearc/qf_helper.nvim', cond = NOT_VSCODE}, -- Quickfix helper :QF{command}
  -- {
  --   "NvChad/ui",
  --   config = function ()
  --     require("nvchad")
  --   end,
  --   lazy = false
  -- }
}
