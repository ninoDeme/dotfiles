return {
  { -- BARBAR tabline and buffer management {{{
    'romgrk/barbar.nvim',
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
  }, --- }}}

  { -- bufferline tabline and buffer management {{{
    'akinsho/bufferline.nvim',
    config = function()
      require("bufferline").setup({
        options = {
          mode = "tabs",
          close_command = "tabclose! %d",
          diagnostics = "nvim_lsp",
          always_show_bufferline = false
        }
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
  }, -- }}}

  { -- LuaLine {{{
    'hoob3rt/lualine.nvim', -- Vim mode line
    lazy = false,
    config = function()
      local lsp_progress = function()
        local active_clients = vim.lsp.get_clients({bufnr = vim.api.nvim_get_current_buf()})
        local filtered_clients = {}
        for _, v in ipairs(active_clients) do
          if (v.name ~= "null-ls") then
            table.insert(filtered_clients, v)
          end
        end
        if #filtered_clients > 0 then
          local names = ""
          for _, v in ipairs(filtered_clients) do
            names = names .. " " .. v.name
          end
          return " LSP:" .. names
        else
          return ""
        end
      end
      local colors = require("colors")
      require('lualine').setup {
        extensions = {
          "toggleterm",
          "lazy"
        },
        options = {
          theme = 'onedark',
          section_separators = '',
          component_separators = '',
          globalstatus = true
        },
        sections = {
          lualine_b = {
            {
              'filename',
              path = 1,
              color = function(_)
                return { fg = vim.bo.modified and colors.yellow or nil }
              end,
              symbols = {
                modified = '󰆓',      -- Text to show when the file is modified.
                readonly = '',      -- Text to show when the file is non-modifiable or readonly.
                unnamed = '[*]', -- Text to show for unnamed buffers.
                newfile = '󰈔',     -- Text to show for newly created file before first write
              },
            },
            'location'
          },
          lualine_c = {
            {
              'diff',
              symbols = { added = ' ', modified = '󰝤 ', removed = ' ' },
            },
            {
              'diagnostics',
              symbols = { error = " ", warn = " ", hint = " ", info = "󰋼 " }
            }
          },
          lualine_x = {
            {
              lsp_progress,
              color = { fg = colors.blue }
            },
            {
              'encoding',
              fmt = string.upper,
              color = { fg = colors.green }
            },
            {
              'fileformat',
              fmt = string.upper,
              icons_enabled = false, -- I think icons are cool but Eviline doesn't have them. sigh
              color = { fg = colors.green }
            },
            {
              'filetype',
              -- fmt = string.upper,
              -- color = { fg = colors.orange }
            },
          },
          lualine_y = {
            {
              'b:gitsigns_head',
              icon = ''
              -- ---@param str string
              -- fmt = function (str)
              --   if str:len() > 40 then
              --     str = str:sub(0, 37) .. '...'
              --   end
              --   return str
              -- end
            },
          },
          lualine_z = {
            {
              '" "',
              padding = 0
            }
          }
        }
      }
      vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
      vim.api.nvim_create_autocmd("User LspAttach LspDetach", {
        group = "lualine_augroup",
        callback = require("lualine").refresh,
      })
    end,
    dependencies = {
      'nvim-web-devicons',
      'nvim-lua/lsp-status.nvim'
    },
    cond = NOT_VSCODE
  }, -- }}}
  {
    "vigoux/notifier.nvim",
    event = "VeryLazy",
    config = function()
      require'notifier'.setup {}
    end,
    cond = NOT_VSCODE

  },
  {
    'kevinhwang91/nvim-bqf',
    config = function()
      require("bqf").setup({
        preview = {
          winblend = 0,
          border = require("hover").border
        }
      })
      vim.print(require("hover").border)
    end,
    ft = 'qf',
    cond = NOT_VSCODE

  },
  {
    "lukas-reineke/indent-blankline.nvim",
    opts = {
      indentLine_enabled = 1,
      filetype_exclude = {
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
      buftype_exclude = { "terminal" },
      show_trailing_blankline_indent = false,
      show_first_indent_level = false,
      show_current_context = true,
      show_current_context_start = true,
    },
    event = "VeryLazy",
    cond = NOT_VSCODE
  },
  -- {
  --   "levouh/tint.nvim",
  --   event = "VeryLazy",
  --   config = function()
  --     require("tint").setup({
  --       tint = -20,  -- Darken colors, use a positive value to brighten
  --       saturation = 0.8,  -- Darken colors, use a positive value to brighten
  --     })
  --   end
  -- }
  -- {
  --   'rcarriga/nvim-notify',
  --   init = function()
  --     vim.notify = require("notify")
  --   end
  -- }
  -- {'stevearc/qf_helper.nvim', cond = NOT_VSCODE}, -- Quickfix helper :QF{command}
}

