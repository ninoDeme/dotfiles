return {
  {
    'romgrk/barbar.nvim', -- tabline and buffer management
    config = function()
      vim.g.barbar_auto_setup = false -- disable auto-setup

      require("barbar").setup({
        exclude_ft = {
          "drex",
          "dosini"
        },
        sidebar_filetypes = {
          NvimTree = true,
          drex = true,
          DiffviewFiles = true,
        },
      })
    end,
    lazy = false,
    enabled = false,
    event = "VeryLazy",
    dependencies = 'nvim-web-devicons',
    cond = NOT_VSCODE,
    keys = {
      {"<leader>bx" , '<cmd>BufferClose<CR>', desc = 'Close Current Buffer'},
      {"<leader>bb" , '<cmd>BufferPick<CR>', desc = 'Pick Buffer...'},
      {"<leader>bq" , '<cmd>BufferPickDelete<CR>', desc = 'Close Buffer...'},
      {"<leader>bp" , '<cmd>BufferPin<CR>', desc = 'Pin Current Buffer'},
      {'<leader>b>' , '<cmd>BufferMoveNext<CR>', desc = 'Move Buffer Forwards'},
      {'<leader>b<' , '<cmd>BufferMovePrevious<CR>', desc = 'Move Buffer Backwards'},
      {'<leader>b.' , '<cmd>BufferNext<CR>', desc = 'Next Buffer'},
      {'<leader>b,' , '<cmd>BufferPrevious<CR>', desc = 'Previous Buffer'},
      { "gt", "<cmd>BufferNext<CR>", desc = "Next Buffer"},
      { "gT", "<cmd>BufferPrevious<CR>", desc = "Previous Buffer"},

      { "<A-1>", "<Cmd>BufferGoto 1<CR>"},
      { "<A-2>", "<Cmd>BufferGoto 2<CR>"},
      { "<A-3>", "<Cmd>BufferGoto 3<CR>"},
      { "<A-4>", "<Cmd>BufferGoto 4<CR>"},
      { "<A-5>", "<Cmd>BufferGoto 5<CR>"},
      { "<A-6>", "<Cmd>BufferGoto 6<CR>"},
      { "<A-7>", "<Cmd>BufferGoto 7<CR>"},
      { "<A-8>", "<Cmd>BufferGoto 8<CR>"},
      { "<A-9>", "<Cmd>BufferGoto 9<CR>"},
      { "<A-0>", "<Cmd>BufferLast<CR>"}
    }
  },
  {
    'akinsho/bufferline.nvim', -- tabline and buffer management
    config = function()
      require("bufferline").setup({
        options = {
          mode = "tabs",
          close_command = "tabclose! %d",
          diagnostics = "nvim_lsp"
        }
        -- exclude_ft = {
        --   "drex",
        --   "dosini"
        -- },
        -- sidebar_filetypes = {
        --   NvimTree = true,
        --   drex = true,
        --   DiffviewFiles = true,
        -- },
      })
    end,
    lazy = false,
    event = "VeryLazy",
    dependencies = 'nvim-web-devicons',
    keys = {
      {"<leader>bx", '<cmd>tabclose<CR>', desc = 'Close Current Tab'},
      {"<leader>bb", '<cmd>BufferLinePick<CR>', desc = 'Pick Tab...'},
      {"<leader>bq", '<cmd>BufferLinePickClose<CR>', desc = 'Close Tab...'},
      {"<leader>bc", '<cmd>tabnew<CR>', desc = 'New Tab'},
      {"<leader>bp", '<cmd>BufferLinePin<CR>', desc = 'Pin Current Tab'},
      {'<leader>b>', '<cmd>BufferLineMoveNext<CR>', desc = 'Move Tab Forwards'},
      {'<leader>b<', '<cmd>BufferLineMovePrev<CR>', desc = 'Move Tab Backwards'},
      {'<leader>b.', '<cmd>bnext<CR>', desc = 'Next Buffer'},
      {'<leader>b,', '<cmd>bprevious<CR>', desc = 'Previous Buffer'},

      { "gt", "<cmd>BufferLineCycleNext<CR>", desc = "Next Tab"},
      { "gT", "<cmd>BufferLineCyclePrev<CR>", desc = "Previous Tab"},

      { "<A-1>", "<Cmd>BufferLineGoToBuffer 1<CR>"},
      { "<A-2>", "<Cmd>BufferLineGoToBuffer 2<CR>"},
      { "<A-3>", "<Cmd>BufferLineGoToBuffer 3<CR>"},
      { "<A-4>", "<Cmd>BufferLineGoToBuffer 4<CR>"},
      { "<A-5>", "<Cmd>BufferLineGoToBuffer 5<CR>"},
      { "<A-6>", "<Cmd>BufferLineGoToBuffer 6<CR>"},
      { "<A-7>", "<Cmd>BufferLineGoToBuffer 7<CR>"},
      { "<A-8>", "<Cmd>BufferLineGoToBuffer 8<CR>"},
      { "<A-9>", "<Cmd>BufferLineGoToBuffer 9<CR>"},
    },
    cond = NOT_VSCODE
  },
  {
    'hoob3rt/lualine.nvim', -- Vim mode line
    config = function()
      require('lualine').setup {
        options = {
          theme = 'onedark',
          section_separators = '',
          component_separators = '│'
        },
        sections = {
          lualine_c = {
            "require('lsp-progress').progress()"
          }
        }
      }
      vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
      vim.api.nvim_create_autocmd("User LspProgressStatusUpdated", {
        group = "lualine_augroup",
        callback = require("lualine").refresh,
      })
    end,
    dependencies = {
      'nvim-web-devicons',
      'linrongbin16/lsp-progress.nvim',
      'nvim-lua/lsp-status.nvim'
    },
    cond = NOT_VSCODE
  },

  {'stevearc/qf_helper.nvim', cond = NOT_VSCODE}, -- Quickfix helper :QF{command}

  {
    "lewis6991/hover.nvim",
      config = function()
      require("hover").setup {
        init = function()
          require("hover.providers.lsp")
          require('hover.providers.man')
        end,
        preview_opts = {
          border = 'solid'
        },
        -- Whether the contents of a currently open hover window should be moved
        -- to a :h preview-window when pressing the hover keymap.
        preview_window = true,
        -- title = true
      }
      -- Setup keymaps
      vim.keymap.set("n", "K", require("hover").hover, {desc = "hover.nvim"})
      vim.keymap.set("n", "gh", require("hover").hover_select, {desc = "hover.nvim (select)"})
    end,
    cond = NOT_VSCODE
  }
}

