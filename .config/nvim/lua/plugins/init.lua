return {
  {'lambdalisue/vim-manpager', cond = NOT_VSCODE}, -- Use vim as a manpager
  {'lambdalisue/vim-pager', cond = NOT_VSCODE}, -- Use vim as a pager
  {'nvim-lua/plenary.nvim', cond = NOT_VSCODE}, -- Telescope dependency
  {
    'nvim-telescope/telescope.nvim', -- Fuzzy finder over lists
    dependencies = 'nvim-lua/plenary.nvim',
    cond = NOT_VSCODE
  },
  {
    'natecraddock/telescope-zf-native.nvim',
    dependencies = 'nvim-telescope/telescope.nvim',
    cond = NOT_VSCODE
  },
  {'kyazdani42/nvim-web-devicons', cond = NOT_VSCODE}, -- Add icons to plugins
  'christoomey/vim-tmux-navigator',
  {
    'romgrk/barbar.nvim', -- tabline and buffer management
    config = function()
      vim.g.barbar_auto_setup = false -- disable auto-setup

      require("barbar").setup({
        exclude_ft = {
          "drex"
        },
        sidebar_filetypes = {
          NvimTree = true,
          drex = true,
        }
      })
    end,
    lazy = false,
    event = "VeryLazy",
    dependencies = 'nvim-web-devicons',
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
  {'sedm0784/vim-resize-mode', cond = NOT_VSCODE},
  {
    "lewis6991/hover.nvim",
    config = function()
      require("hover").setup {
        init = function()
          require("hover.providers.lsp")
          require('hover.providers.man')
        end,
        preview_opts = {
          border = 'single'
        },
        -- Whether the contents of a currently open hover window should be moved
        -- to a :h preview-window when pressing the hover keymap.
        preview_window = true,
        title = true
      }
      -- Setup keymaps
      vim.keymap.set("n", "K", require("hover").hover, {desc = "hover.nvim"})
      vim.keymap.set("n", "gh", require("hover").hover_select, {desc = "hover.nvim (select)"})
    end,
    cond = NOT_VSCODE
  },
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
  {'b3nj5m1n/kommentary', cond = NOT_VSCODE}, -- Use gc<motion> to make comment
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
