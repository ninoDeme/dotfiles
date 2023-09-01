return {
  {'lambdalisue/vim-manpager', cond = NOT_VSCODE, event = "VeryLazy"}, -- Use vim as a manpager
  {'lambdalisue/vim-pager', cond = NOT_VSCODE, event = "VeryLazy"}, -- Use vim as a pager
  {'nvim-lua/plenary.nvim', cond = NOT_VSCODE}, -- Telescope dependency
  {'kyazdani42/nvim-web-devicons', cond = NOT_VSCODE }, -- Add icons to plugins
  {'christoomey/vim-tmux-navigator', event = "VeryLazy"},
  {'sedm0784/vim-resize-mode', cond = NOT_VSCODE, keys = {'<C-w>'}},
  {'editorconfig/editorconfig-vim', event = "VeryLazy"}, -- Editor config support

  {
    "gbprod/substitute.nvim",
    config = true,
    keys = {
      {mode = "n", "gr", function() require('substitute').operator() end,  noremap = true },
      {mode = "n", "grr", function() require('substitute').line() end,  noremap = true },
      {mode = "n", "gR", function() require('substitute').eol() end,  noremap = true },
      {mode = "x", "gr", function() require('substitute').visual() end,  noremap = true },
      {mode = "n", "<leader>r", '"+<cmd>lua require("substitute").operator()<cr>',  noremap = true },
      {mode = "n", "<leader>rr", '"+<cmd>lua require("substitute").line()<cr>',  noremap = true },
      {mode = "n", "<leader>R", '"+<cmd>lua require("substitute").eol()<cr>',  noremap = true },
      {mode = "x", "<leader>r", '"+<cmd>lua require("substitute").visual()<cr>',  noremap = true },
      {mode = "n", "cx", function() require('substitute.exchange').operator() end,  noremap = true },
      {mode = "n", "cxx", function() require('substitute.exchange').line() end,  noremap = true },
      {mode = "x", "cx", function() require('substitute.exchange').visual() end,  noremap = true },
      {mode = "n", "cxc", function() require('substitute.exchange').cancel() end,  noremap = true },
    },
    opts = {}
  },
  {'tpope/vim-surround', event = 'VeryLazy'}, -- change surrounding of text object (ys<motion> to add surround and cs<motion> to change surrounding
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function()
      require('which-key').register({
        s  = { name = 'Telescope', },
        t  = { name = '+Toggle Numbered Terminals', },
        g  = { name = '+Git', },
        b = { name = '+Buffers', },
        W = { 'Create dir to current file' , '<Cmd>:call mkdir(expand("%:p:h"),"p")<CR>'},
      }, {prefix = '<leader>'})
    end,
    cond = NOT_VSCODE
  },

  {
    "numToStr/Comment.nvim",
    keys = {
      { "gcc", mode = "n", desc = "Comment toggle current line" },
      { "gc", mode = { "n", "o" }, desc = "Comment toggle linewise" },
      { "gc", mode = "x", desc = "Comment toggle linewise (visual)" },
      { "gbc", mode = "n", desc = "Comment toggle current block" },
      { "gb", mode = { "n", "o" }, desc = "Comment toggle blockwise" },
      { "gb", mode = "x", desc = "Comment toggle blockwise (visual)" },
    },
    config = function()
      require("Comment").setup()
    end,
  },
  {
    'tommcdo/vim-lion',
    keys = {
      {'gl' , desc = 'Align text at (right)' },
      {'gL' , desc = 'Align text at (left)' },
    }
  }, -- gl<text> to align
  {'mg979/vim-visual-multi', cond = NOT_VSCODE, event = "VeryLazy"}, -- Multiple cursors (Ctrl+n to select word and Ctrl+Down/Up)
  {'cohama/lexima.vim', cond = NOT_VSCODE, event = "VeryLazy"},
  {
    'ggandor/leap.nvim',
    dependencies = {'tpope/vim-repeat'},
    config = function()
      require('leap').add_default_mappings()
    end,
    event = 'VeryLazy'
  },

  -- 'vim-scripts/argtextobj.vim' -- add argument text object ia aa
  {
    'wellle/targets.vim',
    event = 'VeryLazy'
  },

  {
    'michaeljsmith/vim-indent-object',
    event = 'VeryLazy'
  }, -- add indent text object for motions ii ai 
  {
    'kana/vim-textobj-entire',
    event = 'VeryLazy',
    dependencies ={'kana/vim-textobj-user'}
  },

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
    }
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
    build = 'make install_jsregexp'
  }, -- Snippets plugin

  --[[ 'mfussenegger/nvim-dap'
    'rcarriga/nvim-dap-ui' ]]

  -- Color schemes =======================
  {'ayu-theme/ayu-vim', cond = NOT_VSCODE},
  {
    lazy = false,
    priority = 9999,
    'navarasu/onedark.nvim',
    config = function()
      require('onedark').setup {
        style = 'darker'
      }
      require('onedark').load()

      require('colors')
    end,
    cond = NOT_VSCODE
  },
  {
    'norcalli/nvim-colorizer.lua',
    cond = NOT_VSCODE,
    cmd = {"ColorizerToggle", "ColorizerAttachToBuffer", "ColorizerDetachFromBuffer", "ColorizerReloadAllBuffers"}
  },

  {'kana/vim-textobj-user',
    event = 'VeryLazy',
    config = function()
      vim.cmd[[
" Regexes
" Note that all regexes are surrounded by (), use that to your advantage.

" Teste usar lookbehind para verificar se não é o nome da tag
" A word: `attr=value`, with no quotes.
let s:RE_WORD = '\(\w\+\)'
" An attribute name: `src`, `data-attr`, `strange_attr`.
let s:RE_ATTR_NAME = '\([\[\(\#\*]\{0,2}\)\([a-zA-Z0-9\-_:@.]\+\)\([\]\)]\{0,2}\)'
" A quoted string.
let s:RE_QUOTED_STR = '\(".\{-}"\)'
" The value of an attribute: a word with no quotes or a quoted string.
let s:RE_ATTR_VALUE = '\(' . s:RE_QUOTED_STR . '\|' . s:RE_WORD . '\)'
" The right-hand side of an XML attr: an optional `=something` or `="str"`.
let s:RE_ATTR_RHS = '\(=' . s:RE_ATTR_VALUE . '\)\='

" The final regex.
let s:RE_ATTR_I = '\(' . s:RE_ATTR_NAME . s:RE_ATTR_RHS . '\)'
let s:RE_ATTR_A = '\s\+' . s:RE_ATTR_I
let s:RE_ATTR_AX = '\s\+' . s:RE_ATTR_NAME

call textobj#user#plugin('angularattr', {
\   'attr-i': {
\     'pattern': s:RE_ATTR_I,
\     'select': 'ix',
\   },
\   'attr-a': {
\     'pattern': s:RE_ATTR_A,
\     'select': 'ax',
\   },
\   'attr-iX': {
\     'pattern': s:RE_ATTR_NAME,
\     'select': 'iX'
\   },
\   'attr-aX': {
\     'pattern': s:RE_ATTR_AX,
\     'select': 'aX'
\   },
\ })

      ]]
    end
  },
}
