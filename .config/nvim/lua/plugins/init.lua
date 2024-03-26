return {
  { 'lambdalisue/vim-manpager',
    cond = NOT_VSCODE,
    cmd = {
      'ASMANPAGER',
      'Man'
    },
    ft = {
      'man',
    }
  }, -- Use vim as a manpager
  { 'nvim-lua/plenary.nvim',          cond = NOT_VSCODE },             -- Telescope dependency
  { 'kyazdani42/nvim-web-devicons',   cond = NOT_VSCODE },             -- Add icons to plugins
  { 'sedm0784/vim-resize-mode',       cond = NOT_VSCODE, keys = { '<C-w>' } },
  { 'editorconfig/editorconfig-vim',  event = "VeryLazy" }, -- Editor config support

  { 'tpope/vim-surround',             event = 'VeryLazy' }, -- change surrounding of text object (ys<motion> to add surround and cs<motion> to change surrounding
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function()
      require('which-key').register({
        s = { name = 'Telescope', },
        t = { name = '+Toggle Numbered Terminals', },
        g = { name = '+Git', },
        d = { name = '+Debug', },
        b = { name = '+Buffers', },
        o = {
          name = '+Open',
          t = { '<Cmd>:terminal<CR>i', 'Terminal'},
          ['-'] = { '<cmd>Oil<cr>', 'Oil'},
        },
        W = { '<Cmd>:call mkdir(expand("%:p:h"),"p")<CR>', 'Create dir to current file' },
      }, { prefix = '<leader>' })
    end,
    cond = NOT_VSCODE
  },
  { 'mg979/vim-visual-multi', cond = NOT_VSCODE, event = "VeryLazy" }, -- Multiple cursors (Ctrl+n to select word and Ctrl+Down/Up)
  { 'cohama/lexima.vim',      cond = NOT_VSCODE, event = "VeryLazy" },
  {
    'ggandor/leap.nvim',
    dependencies = { 'tpope/vim-repeat' },
    config = function()
      require('leap').add_default_mappings()
    end,
    event = 'VeryLazy'
  },
  {
    'skywind3000/asyncrun.vim',
    cmd = {
      'AsyncRun'
    }
  },
  -- -- 'vim-scripts/argtextobj.vim' -- add argument text object ia aa
  -- {
  --   'wellle/targets.vim',
  --   event = 'VeryLazy'
  -- },
  --
  -- {
  --   'kana/vim-textobj-entire',
  --   event = 'VeryLazy',
  --   dependencies ={'kana/vim-textobj-user'}
  -- },
  {
    'michaeljsmith/vim-indent-object',
    event = 'VeryLazy'
  }, -- add indent text object for motions ii ai 
  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewLog",
      "DiffviewRefresh",
      "DiffviewReference",
      "DiffviewFileHistory",
      "DiffviewToggleFiles",
    },
    cond = NOT_VSCODE,
  },

  {
    'williamboman/mason.nvim',
    event = "VeryLazy",
    config = function()
      require("mason").setup()
    end
  },

  {
    'L3MON4D3/LuaSnip',
    cond = NOT_VSCODE,
    event = 'VeryLazy',
    build = 'make install_jsregexp',
    keys = {
      {
        "<tab>",
        function()
          return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
        end,
        expr = true, silent = true, mode = "i",
      },
      { "<tab>", function() require("luasnip").jump(1) end, mode = "s" },
      { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
    },
  }, -- Snippets plugin

  -- Color schemes =======================
  { 'ayu-theme/ayu-vim', cond = NOT_VSCODE },
  {
    lazy = false,
    priority = 1006,
    'navarasu/onedark.nvim',
    config = function()
      require('onedark').setup {
        -- toggle_style_key = "<leader>tc", -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
        style = 'darker'
      }
      require('onedark').load()

      require('colors')
    end,
    cond = NOT_VSCODE
  },
  -- {'kana/vim-textobj-user', --- {{{
  --   event = 'VeryLazy',
  --   config = function()
  --     vim.cmd[[
  --     " Regexes
  --     " Note that all regexes are surrounded by (), use that to your advantage.
  --
  --     " Teste usar lookbehind para verificar se não é o nome da tag
  --     " A word: `attr=value`, with no quotes.
  --     let s:RE_WORD = '\(\w\+\)'
  --     " An attribute name: `src`, `data-attr`, `strange_attr`.
  --     let s:RE_ATTR_NAME = '\([\[\(\#\*]\{0,2}\)\([a-zA-Z0-9\-_:@.]\+\)\([\]\)]\{0,2}\)'
  --     " A quoted string.
  --     let s:RE_QUOTED_STR = '\(".\{-}"\)'
  --     " The value of an attribute: a word with no quotes or a quoted string.
  --     let s:RE_ATTR_VALUE = '\(' . s:RE_QUOTED_STR . '\|' . s:RE_WORD . '\)'
  --     " The right-hand side of an XML attr: an optional `=something` or `="str"`.
  --     let s:RE_ATTR_RHS = '\(=' . s:RE_ATTR_VALUE . '\)\='
  --
  --     " The final regex.
  --     let s:RE_ATTR_I = '\(' . s:RE_ATTR_NAME . s:RE_ATTR_RHS . '\)'
  --     let s:RE_ATTR_A = '\s\+' . s:RE_ATTR_I
  --     let s:RE_ATTR_AX = '\s\+' . s:RE_ATTR_NAME
  --
  --     call textobj#user#plugin('angularattr', {
  --     \   'attr-i': {
  --     \     'pattern': s:RE_ATTR_I,
  --     \     'select': 'ix',
  --     \   },
  --     \   'attr-a': {
  --     \     'pattern': s:RE_ATTR_A,
  --     \     'select': 'ax',
  --     \   },
  --     \   'attr-iX': {
  --     \     'pattern': s:RE_ATTR_NAME,
  --     \     'select': 'iX'
  --     \   },
  --     \   'attr-aX': {
  --     \     'pattern': s:RE_ATTR_AX,
  --     \     'select': 'aX'
  --     \   },
  --     \ })
  --
  --     ]]
  --   end
  -- }, --- }}}

  {
    'echasnovski/mini.nvim',
    event = 'VeryLazy',
    config = function()
      if NOT_VSCODE() then
        require("mini.comment").setup()
        require("mini.files").setup()

        -- require('mini.cursorword').setup()
        local hipatterns = require('mini.hipatterns')
        hipatterns.setup({
          highlighters = {
            -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
            fixme     = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
            hack      = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
            todo      = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
            note      = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },

            -- Highlight hex color strings (`#rrggbb`) using that color
            hex_color = hipatterns.gen_highlighter.hex_color(),
          },
        })
      end
      require('mini.bracketed').setup()
      require('mini.ai').setup({
        custom_textobjects = {
          g = function()
            local from = { line = 1, col = 1 }
            local to = {
              line = vim.fn.line('$'),
              col = math.max(vim.fn.getline('$'):len(), 1)
            }
            return { from = from, to = to }
          end,
          x = {  {
            '%s()%*?%[?%(?[%w_-]+%)?%]?=%b""()',
            "%s()%*?%[?%(?[%w_-]+%)?%]?=%b''()",
            '%s()%*?%[?%(?[%w_-]+%)?%]?=%b{}()',
            '%s()%*?%[?%(?[%w_-]+%)?%]?=[%w_-]+()'
          } }
        },
      })
      require('mini.align').setup()
      require('mini.splitjoin').setup()
      require('mini.operators').setup({
        exchange = {
          prefix = 'cx'
        },
      })
    end,
    keys = {
      { mode = { "n", "v" }, "<leader>r",                               '"+gr',                  remap = true },
      { mode = "n",        "<leader>R",                                 '"+gr$',                 remap = true },
      { mode = "n",        "gR",                                        'gr$',                   remap = true },
      { mode = "n",        "cX",                                        'cx$',                   remap = true },
      { '<leader>m',       desc = "+Mini" },
      { '<leader>me',      function() require("mini.files").open() end, desc = "Open Mini Files" },
      { '<leader>m.',      function() require("mini.files").open(vim.fn.expand("%:p:h")) end, desc = "Open Mini Files at dir" }
    }
  }
}

