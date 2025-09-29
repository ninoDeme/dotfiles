return {
  { "nvim-lua/plenary.nvim" },       -- Telescope dependency
  { "nvim-tree/nvim-web-devicons" }, -- Add icons to plugins
  { "sedm0784/vim-resize-mode",   event = "VeryLazy" },

  -- { 'tpope/vim-surround',             event = 'VeryLazy' }, -- change surrounding of text object (ys<motion> to add surround and cs<motion> to change surrounding
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").setup({
        preset = "classic",
        spec = {
          { "<leader><tab>",      group = "Tabs" },
          { "<leader><tab><tab>", "gt",                                        desc = "Next Tab" },
          { "<leader><tab>c",     "<Cmd>tabnew<cr>",                           desc = "New Tab" },
          { "<leader><tab>n",     "<Cmd>tabnew<cr>",                           desc = "New Tab" },
          { "<leader><tab>t",     "<cmd>:tabnew<cr><cmd>:terminal<cr>i",       desc = "Tab With Terminal" },
          { "<leader><tab>x",     "<cmd>:tabclose<cr>",                        desc = "Close Tab" },
          { "<leader>W",          '<Cmd>:call mkdir(expand("%:p:h"),"p")<CR>', desc = "Create dir to current file" },
          { "<leader>b",          group = "Buffers" },
          { "<leader>q",          group = "QuickFix" },
          { "<leader>qb",         "<cmd>:cprevious<cr>",                       desc = "Previous Item" },
          {
            "<leader>qq",
            function()
              local windows = vim.fn.getwininfo()
              for _, win in pairs(windows) do
                if win["quickfix"] == 1 then
                  vim.cmd.cclose()
                  return
                end
              end
              vim.cmd.copen()
            end,
            desc = "Toggle QuickFix",
          },
          { "<leader>qn", "<cmd>:cnext<cr>",                  desc = "Next Item" },
          { "<leader>d",  group = "Debug" },
          { "<leader>g",  group = "Git" },
          { "<leader>o",  group = "Open" },
          { "<leader>o-", "<cmd>Oil<cr>",                     desc = "Oil" },
          { "<leader>ot", "<Cmd>:terminal<CR>i",              desc = "Terminal" },
          { "<leader>s",  group = "Telescope" },
          { "<leader>t",  group = "Toggle Numbered Terminals" },
          {
            "[e",
            function()
              vim.diagnostic.jump({ severity = vim.diagnostic.severity.ERROR, count = -1, float = true })
            end,
            desc = "Previous Error",
          },
          {
            "]e",
            function()
              vim.diagnostic.jump({ severity = vim.diagnostic.severity.ERROR, count = 1, float = true })
            end,
            desc = "Next Error",
          },
        },
      })
    end,
  },
  { "cohama/lexima.vim", event = "VeryLazy" },
  { "tpope/vim-repeat",  event = "VeryLazy" },
  -- {
  --   "ggandor/leap.nvim",
  --   dependencies = { "tpope/vim-repeat" },
  --   config = function()
  --     require("leap").add_default_mappings()
  --   end,
  --   event = "VeryLazy",
  -- },
  {
    "wellle/targets.vim",
    event = "VeryLazy",
  },
  {
    "kana/vim-textobj-entire",
    event = "VeryLazy",
    dependencies = { "kana/vim-textobj-user" },
  },
  {
    "michaeljsmith/vim-indent-object",
    event = "VeryLazy",
  }, -- add indent text object for motions ii ai
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup({
        registries = {
          "github:mason-org/mason-registry",
          "github:Crashdummyy/mason-registry",
        },
      })
    end,
  },

  -- Color schemes =======================
  {
    "kana/vim-textobj-user", --- {{{
    event = "VeryLazy",
    config = function()
      local re_word = [[\(\w\+\)]]
      -- An attribute name: `src`, `data-attr`, `strange_attr`.
      local re_attr_name = [[\([\[\(\#\*]\{0,2}\)\([a-zA-Z0-9\-_:@.]\+\)\([\]\)]\{0,2}\)]]
      -- A quoted string.
      local re_quoted_str = [[\(".\{-}"\)]]
      -- The value of an attribute: a word with no quotes or a quoted string.
      local re_attr_value = [[\(]] .. re_quoted_str .. [[\|]] .. re_word .. [[\)]]
      -- The right-hand side of an XML attr: an optional `=something` or `="str"`.
      local re_attr_rhs = [[\(=]] .. re_attr_value .. [[\)\=]]

      -- The final regex.
      local re_attr_i = [[\(]] .. re_attr_name .. re_attr_rhs .. [[\)]]
      local re_attr_a = [[\s\+]] .. re_attr_i
      local re_attr_ax = [[\s\+]] .. re_attr_name

      vim.fn["textobj#user#plugin"]("angularattr", {
        ["attr-i"] = {
          pattern = re_attr_i,
          select = "ix",
        },
        ["attr-a"] = {
          pattern = re_attr_a,
          select = "ax",
        },
        ["attr-iX"] = {
          pattern = re_attr_name,
          select = "iX",
        },
        ["attr-aX"] = {
          pattern = re_attr_ax,
          select = "aX",
        },
      })
    end,
  }, --- }}}
  {
    "brenoprata10/nvim-highlight-colors",
    event = "VeryLazy",
    enabled = false,
    opts = {
      enable_tailwind = true,
      render = "virtual",
      virtual_symbol_position = "eol",
    },
  },
  {
    "andrewferrier/debugprint.nvim",
    opts = {},
    keys = {
      { mode = { "n", "x" }, "g?",  desc = "+Debug Print" },
      { mode = { "n", "x" }, "g?v", desc = "Print variable below" },
      { mode = { "n", "x" }, "g?V", desc = "Print variable above" },
      { mode = "n",          "g?p", desc = "Print below" },
      { mode = "n",          "g?P", desc = "Print above" },
    },
    cmd = {
      "DeleteDebugPrints",
      "ToggleCommentDebugPrints",
    },
    dependencies = {
      "echasnovski/mini.nvim", -- Needed to enable :ToggleCommentDebugPrints for NeoVim 0.9
    },
  },
  {
    "luukvbaal/statuscol.nvim",
    event = "VeryLazy",
    config = function()
      local builtin = require("statuscol.builtin")
      require("statuscol").setup({
        -- configuration goes here, for example:
        ft_ignore = { "OverseerList", "dap-view", "dap-repl" },
        bt_ignore = { "terminal" },
        segments = {
          {
            text = { "%C" },
            click = "v:lua.ScFa",
            sign = { auto = true },
            condition = {
              function(args)
                return args.nu or args.rnu
              end
            },
          },
          {
            sign = { namespace = { ".*" }, name = { ".*" } },
            condition = {
              function(args)
                return args.nu or args.rnu
              end
            },
            click = "v:lua.ScSa"
          },
          {
            sign = { name = { "Dap.*" }, auto = true },
            click = "v:lua.ScSa",
            condition = {
              function(args)
                return args.nu or args.rnu
              end
            },
          },
          {
            text = { builtin.lnumfunc, " " },
            condition = { true, builtin.not_empty },
            click = "v:lua.ScLa",
          },
          {
            sign = {
              namespace = { "gitsigns_signs_.*" },
              maxwidth = 1,
              colwidth = 1
            },
            click = "v:lua.ScSa",
            condition = {
              function(args)
                return args.nu or args.rnu
              end
            },
          }
        }
      })
    end,
  }
}
