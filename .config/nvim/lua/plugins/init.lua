return {
  {'lambdalisue/vim-manpager', cond = NOT_VSCODE}, -- Use vim as a manpager
  {'lambdalisue/vim-pager', cond = NOT_VSCODE}, -- Use vim as a pager
  {'nvim-lua/plenary.nvim', cond = NOT_VSCODE}, -- Telescope dependency
  {'kyazdani42/nvim-web-devicons', cond = NOT_VSCODE}, -- Add icons to plugins
  'christoomey/vim-tmux-navigator',
  {'sedm0784/vim-resize-mode', cond = NOT_VSCODE},
  'editorconfig/editorconfig-vim', -- Editor config support

  {
    "gbprod/substitute.nvim",
    config = function()
      require("substitute").setup({})
    end
  },
  'tpope/vim-surround', -- change surrounding of text object (ys<motion> to add surround and cs<motion> to change surrounding
  {
    'folke/which-key.nvim',
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
  'tommcdo/vim-lion', -- gl<text> to align
  {'mg979/vim-visual-multi', cond = NOT_VSCODE}, -- Multiple cursors (Ctrl+n to select word and Ctrl+Down/Up)
  {'cohama/lexima.vim', cond = NOT_VSCODE}, -- Multiple cursors (Ctrl+n to select word and Ctrl+Down/Up)
  {
    'ggandor/leap.nvim',
    dependencies = {'tpope/vim-repeat'},
    config = function()
      require('leap').add_default_mappings()
    end,
  },

  -- 'vim-scripts/argtextobj.vim' -- add argument text object ia aa
  'wellle/targets.vim',
  {'kana/vim-textobj-user'},
  'michaeljsmith/vim-indent-object', -- add indent text object for motions ii ai 
  {
    'kana/vim-textobj-entire',
    dependencies ={'kana/vim-textobj-user'}
  },

  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",         -- required
      "nvim-telescope/telescope.nvim", -- optional
      "sindrets/diffview.nvim",        -- optional
    },
    cond = NOT_VSCODE
  },
  {'lewis6991/gitsigns.nvim', cond = NOT_VSCODE}, -- Git stuff

  {
    'williamboman/mason.nvim',
    config = function()
      require("mason").setup()
    end
  },

  {
    'L3MON4D3/LuaSnip',
    cond = NOT_VSCODE,
    build = 'make install_jsregexp'
  }, -- Snippets plugin

  --[[ 'mfussenegger/nvim-dap'
    'rcarriga/nvim-dap-ui' ]]

  -- Autocompletion =======================

  {'hrsh7th/nvim-cmp', cond = NOT_VSCODE}, -- Autocompletion plugin
  {'hrsh7th/cmp-nvim-lsp', cond = NOT_VSCODE}, -- LSP source for nvim-cmp
  {'saadparwaiz1/cmp_luasnip', cond = NOT_VSCODE}, -- Snippets source for nvim-cmp
  {'hrsh7th/cmp-path', cond = NOT_VSCODE},
  {'hrsh7th/cmp-buffer', cond = NOT_VSCODE},
  {'hrsh7th/cmp-cmdline', cond = NOT_VSCODE},
  {'hrsh7th/cmp-nvim-lsp-signature-help', cond = NOT_VSCODE},
  {'ray-x/cmp-treesitter', cond = NOT_VSCODE},

  -- Color schemes =======================
  {'tjdevries/colorbuddy.nvim', cond = NOT_VSCODE},
  {'ishan9299/modus-theme-vim', cond = NOT_VSCODE},
  {'ayu-theme/ayu-vim', cond = NOT_VSCODE},
  {'navarasu/onedark.nvim', cond = NOT_VSCODE},
  -- 'joshdick/onedark.vim',
  {'norcalli/nvim-colorizer.lua', cond = NOT_VSCODE},
}
