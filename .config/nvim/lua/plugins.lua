local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
		vim.cmd [[packadd packer.nvim]]
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)

	use 'wbthomason/packer.nvim'
	use {'lambdalisue/vim-manpager', -- Use vim as a manpager
	     'dag/vim-fish', -- Fish integration
	     'lambdalisue/vim-pager', -- Use vim as a pager
	     'kyazdani42/nvim-tree.lua', -- project browser, use <space><space> to toggle
	     'kosayoda/nvim-lightbulb',
	     'gennaro-tedesco/nvim-peekup', -- See all yank registers use ""
	     'nvim-lua/plenary.nvim', -- Telescope dependency
	     {'nvim-telescope/telescope.nvim', requires = 'plenary.nvim'}, -- Fuzzy finder over lists
	     'kyazdani42/nvim-web-devicons', -- Add icons to plugins
	     'nvim-treesitter/nvim-treesitter', -- Parsesr and highlighter for a lot of languages
	     {'romgrk/barbar.nvim', requires = 'nvim-web-devicons'}, -- tabline
	     'johann2357/nvim-smartbufs', -- Smart buffers
	     'hoob3rt/lualine.nvim', -- Vim mode line
	     'lewis6991/gitsigns.nvim', -- Git stuff
	     'b3nj5m1n/kommentary', -- Use gc<motion> to make comment
	     'stevearc/qf_helper.nvim', -- Quickfix helper use :QF{command}
	     'p00f/nvim-ts-rainbow',
	     {'romgrk/nvim-treesitter-context', requires = 'nvim-treesitter'}, -- Shows the context (current function or method)
	     'L3MON4D3/LuaSnip', -- Snippets plugin
	     'mg979/vim-visual-multi', -- Multiple cursors (use Ctrl+n to select word and Ctrl+Down/Up)
	     'folke/which-key.nvim', disable = vim.g.vscode}
	use 'tommcdo/vim-lion' -- use gl<text> to align
	use 'michaeljsmith/vim-indent-object' -- add indent text object for motions ii ai 
	use 'kana/vim-textobj-entire'
	use 'tpope/vim-surround' -- change surrounding of text object (use ys<motion> to add surround and cs<motion> to change surrounding
	use 'editorconfig/editorconfig-vim' -- Editor config support
	use 'justinmk/vim-sneak' -- Go to next ocurrence of two caracters s{char}{char}
	use ({
		"gbprod/substitute.nvim",
		config = function()
			require("substitute").setup({})
		end
	})
	-- use 'vim-scripts/argtextobj.vim' -- add argument text object ia aa
	use 'wellle/targets.vim'
	use 'kana/vim-textobj-user'
  use 'christoomey/vim-tmux-navigator'

  use 'williamboman/mason.nvim'

	-- Lsp and DAP =======================
	use {'neovim/nvim-lspconfig', -- Common lsp configurations
      {
        'glepnir/lspsaga.nvim',
        requires = {
            {'nvim-tree/nvim-web-devicons'},
            {'nvim-treesitter/nvim-treesitter'} --Please make sure you install markdown and markdown_inline parser
        }
       },
	     'nvim-lua/lsp-status.nvim', -- lsp status
       -- 'RishabhRD/nvim-lsputils',
	     'folke/lsp-colors.nvim',
	     'ojroques/nvim-lspfuzzy', -- lembrar de configurar
	     'onsails/lspkind.nvim',
       'jose-elias-alvarez/null-ls.nvim',
       'jay-babu/mason-null-ls.nvim',
        {
            "ThePrimeagen/refactoring.nvim",
            requires = {
                {"nvim-lua/plenary.nvim"},
                {"nvim-treesitter/nvim-treesitter"}
            },
        },
	     'williamboman/mason-lspconfig.nvim', disable = vim.g.vscode}
	--[[ use 'mfussenegger/nvim-dap'
	use 'rcarriga/nvim-dap-ui' ]]

	-- Autocompletion =======================
	use {'hrsh7th/nvim-cmp', -- Autocompletion plugin
	     'hrsh7th/cmp-nvim-lsp', -- LSP source for nvim-cmp
	     'saadparwaiz1/cmp_luasnip', -- Snippets source for nvim-cmp
	     'hrsh7th/cmp-path',
	     'hrsh7th/cmp-buffer',
	     'hrsh7th/cmp-cmdline',
       'hrsh7th/cmp-nvim-lsp-signature-help',
	     'ray-x/cmp-treesitter', disable = vim.g.vscode}

	-- Color schemes =======================
	use {'tjdevries/colorbuddy.nvim',
	     'ishan9299/modus-theme-vim',
	     'ayu-theme/ayu-vim',
       'navarasu/onedark.nvim',
       -- 'joshdick/onedark.vim',
	     'norcalli/nvim-colorizer.lua', disable = vim.g.vscode}
end)
-- vim: ts=2 sts=2 sw=2 et nowrap
