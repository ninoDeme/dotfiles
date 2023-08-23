local function not_vscode()
  return not vim.g.vscode
end

return {
  {'lambdalisue/vim-manpager', cond = not_vscode}, -- Use vim as a manpager
  {'lambdalisue/vim-pager', cond = not_vscode}, -- Use vim as a pager
  {'kyazdani42/nvim-tree.lua', cond = not_vscode}, -- project browser, <space><space> to toggle
  {'nvim-lua/plenary.nvim', cond = not_vscode}, -- Telescope dependency
  {
    'nvim-telescope/telescope.nvim', -- Fuzzy finder over lists
    dependencies = 'nvim-lua/plenary.nvim',
    cond = not_vscode
  },
  {
    'natecraddock/telescope-zf-native.nvim',
    dependencies = 'nvim-telescope/telescope.nvim',
    cond = not_vscode
  },
  {'kyazdani42/nvim-web-devicons', cond = not_vscode}, -- Add icons to plugins
  {
    'akinsho/toggleterm.nvim',
    config = function()
      require('toggleterm').setup()
    end,
    cond = not_vscode
  },
  'christoomey/vim-tmux-navigator',
  {
    'romgrk/barbar.nvim', -- tabline and buffer management
    dependencies = 'nvim-web-devicons',
    cond = not_vscode
  },
  {'hoob3rt/lualine.nvim', cond = not_vscode}, -- Vim mode line
  {'stevearc/qf_helper.nvim', cond = not_vscode}, -- Quickfix helper :QF{command}
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
    cond = not_vscode
  },
	'editorconfig/editorconfig-vim', -- Editor config support

  {
    "gbprod/substitute.nvim",
    config = function()
      require("substitute").setup({})
    end
  },
	'tpope/vim-surround', -- change surrounding of text object (ys<motion> to add surround and cs<motion> to change surrounding
  {'folke/which-key.nvim', cond = not_vscode },
  {'b3nj5m1n/kommentary', cond = not_vscode}, -- Use gc<motion> to make comment
	'tommcdo/vim-lion', -- gl<text> to align
  {'mg979/vim-visual-multi', cond = not_vscode}, -- Multiple cursors (Ctrl+n to select word and Ctrl+Down/Up)
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
	'kana/vim-textobj-entire',

  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",         -- required
      "nvim-telescope/telescope.nvim", -- optional
      "sindrets/diffview.nvim",        -- optional
    },
    cond = not_vscode
  },
  {'lewis6991/gitsigns.nvim', cond = not_vscode}, -- Git stuff

  'williamboman/mason.nvim',

  {'nvim-treesitter/nvim-treesitter', cond = not_vscode}, -- Parsesr and highlighter for a lot of languages
  {
    'romgrk/nvim-treesitter-context', -- Shows the context (current function or method)
    dependencies = 'nvim-treesitter',
    cond = not_vscode
  },
  {'p00f/nvim-ts-rainbow', cond = not_vscode},

  {
    'L3MON4D3/LuaSnip',
    cond = not_vscode,
    build = 'make install_jsregexp'
  }, -- Snippets plugin

	-- Lsp and DAP =======================

  {'neovim/nvim-lspconfig', cond = not_vscode}, -- Common lsp configurations
  {'nvim-lua/lsp-status.nvim', cond = not_vscode}, -- lsp status
  -- 'RishabhRD/nvim-lsputils',
  {'folke/lsp-colors.nvim', cond = not_vscode},
  {'ojroques/nvim-lspfuzzy', cond = not_vscode}, -- lembrar de configurar
  {'onsails/lspkind.nvim', cond = not_vscode},
  {'jose-elias-alvarez/null-ls.nvim', cond = not_vscode},
  {'jay-babu/mason-null-ls.nvim', cond = not_vscode},
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      {"nvim-lua/plenary.nvim"},
      {"nvim-treesitter/nvim-treesitter"}
    },
    cond = not_vscode
  },
  {
    "aznhe21/actions-preview.nvim",
    config = function()
      require("actions-preview").setup {
        telescope = vim.tbl_extend( "force", require("telescope.themes").get_ivy(), {make_value = nil, make_make_display = nil})
      }
      vim.keymap.set({ "v", "n" }, "<leader>la", require("actions-preview").code_actions, {desc = 'Code Actions'})
    end,
    cond = not_vscode
  },
  {'williamboman/mason-lspconfig.nvim', cond = not_vscode},

	--[[ 'mfussenegger/nvim-dap'
	'rcarriga/nvim-dap-ui' ]]

	-- Autocompletion =======================

  {'hrsh7th/nvim-cmp', cond = not_vscode}, -- Autocompletion plugin
  {'hrsh7th/cmp-nvim-lsp', cond = not_vscode}, -- LSP source for nvim-cmp
  {'saadparwaiz1/cmp_luasnip', cond = not_vscode}, -- Snippets source for nvim-cmp
  {'hrsh7th/cmp-path', cond = not_vscode},
  {'hrsh7th/cmp-buffer', cond = not_vscode},
  {'hrsh7th/cmp-cmdline', cond = not_vscode},
  {'hrsh7th/cmp-nvim-lsp-signature-help', cond = not_vscode},
  {'ray-x/cmp-treesitter', cond = not_vscode},

  -- Color schemes =======================
  {'tjdevries/colorbuddy.nvim', cond = not_vscode},
  {'ishan9299/modus-theme-vim', cond = not_vscode},
  {'ayu-theme/ayu-vim', cond = not_vscode},
  {'navarasu/onedark.nvim', cond = not_vscode},
  -- 'joshdick/onedark.vim',
  {'norcalli/nvim-colorizer.lua', cond = not_vscode},

}
-- vim: ts=2 sts=2 sw=2 et nowrap
