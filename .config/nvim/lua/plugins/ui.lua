return {

  { -- LuaLine {{{
    'hoob3rt/lualine.nvim', -- Vim mode line
    lazy = false,
    config = function()
      local lsp_progress = function()
        local active_clients = vim.lsp.get_clients({bufnr = vim.api.nvim_get_current_buf()})
        local filtered_clients = {}
        for _, v in ipairs(active_clients) do
          table.insert(filtered_clients, v)
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
          -- theme = 'auto',
          section_separators = '',
          component_separators = '',
          globalstatus = true
        },
        sections = {
          lualine_b = {
          },
          lualine_c = {
            {
              'filename',
              path = 1,
              color = function(_)
                return { fg = vim.bo.modified and colors.yellow or nil }
              end,
              shorting_target = 50,
              symbols = {
                modified = '󰆓',      -- Text to show when the file is modified.
                readonly = '',      -- Text to show when the file is non-modifiable or readonly.
                unnamed = '[*]', -- Text to show for unnamed buffers.
                newfile = '󰈔',     -- Text to show for newly created file before first write
              },
            },
            'location',
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
              icons_enabled = false,
              color = { fg = colors.green }
            },
            {
              'filetype',
              -- fmt = string.upper,
              -- color = { fg = colors.orange }
            },
            {
              'branch',
              icon = '',
              color = { fg = colors.purple },
              ---@param str string
              fmt = function (str)
                if str:len() > 50 then
                  str = str:sub(0, 47) .. '...'
                end
                return str
              end,
              on_click = function () require("neogit").open() end
            },
          },
          lualine_y = {
          },
          lualine_z = {
            {
              '" "',
              padding = 0
            }
          }
        },
        -- winbar = {
        --   lualine_c = {
        --     {
        --       'filename',
        --       path = 1,
        --       -- color = function(_)
        --       --   return { fg = vim.bo.modified and colors.yellow or nil }
        --       -- end,
        --       symbols = {
        --         modified = '󰆓',      -- Text to show when the file is modified.
        --         readonly = '',      -- Text to show when the file is non-modifiable or readonly.
        --         unnamed = '[*]', -- Text to show for unnamed buffers.
        --         newfile = '󰈔',     -- Text to show for newly created file before first write
        --       },
        --     },
        --   },
        -- },
        -- inactive_winbar = {
        --   lualine_c = {
        --     {
        --       'filename',
        --       path = 1,
        --       -- color = function(_)
        --       --   return { fg = vim.bo.modified and colors.yellow or nil }
        --       -- end,
        --       symbols = {
        --         modified = '󰆓',      -- Text to show when the file is modified.
        --         readonly = '',      -- Text to show when the file is non-modifiable or readonly.
        --         unnamed = '[*]', -- Text to show for unnamed buffers.
        --         newfile = '󰈔',     -- Text to show for newly created file before first write
        --       },
        --     }
        --   },
        --
        -- }
      }
      vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
      -- vim.api.nvim_create_autocmd("User LspAttach LspDetach", {
      --   group = "lualine_augroup",
      --   callback = require("lualine").refresh,
      -- })
    end,
    dependencies = {
      'nvim-web-devicons',
      'nvim-lua/lsp-status.nvim'
    },
    cond = NOT_VSCODE
  }, -- }}}
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
    "j-hui/fidget.nvim",
    event = "VeryLazy",
    opts = {
      notification = {
        override_vim_notify = true,  -- Automatically override vim.notify() with Fidget
      }
    },
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
    end,
    ft = 'qf',
    cond = NOT_VSCODE
  },
  -- {
  --   "lukas-reineke/indent-blankline.nvim",
  --   config = function ()
  --     require("ibl").setup({
  --       enabled = true,
  --       exclude = {
  --         filetypes = {
  --           "help",
  --           "terminal",
  --           "lazy",
  --           "lspinfo",
  --           "TelescopePrompt",
  --           "TelescopeResults",
  --           "mason",
  --           "alpha",
  --           "",
  --         },
  --         buftypes = {
  --           "terminal"
  --         },
  --       },
  --
  --       scope = {
  --         enabled = false,
  --         show_start = false,
  --         show_end = false,
  --         -- char = "│",
  --         highlight = {"IblScopeChar", "IblScopeChar", "IblScopeFunction"},
  --       }
  --   })
  --   end,
  --   enabled = false,
  --   event = "VeryLazy",
  --   cond = NOT_VSCODE
  -- },
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

