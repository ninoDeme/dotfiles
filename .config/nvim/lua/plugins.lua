return require('packer').startup(function(use)

	use 'wbthomason/packer.nvim'
	use 'lambdalisue/vim-manpager' -- Use vim as a manpager
	use 'vifm/vifm.vim' -- vifm integratio
	use 'dag/vim-fish' -- Fish integration
	use 'lambdalisue/vim-pager' -- Use vim as a pager
	-- use 'chrisbra/Colorizer'
	use 'kyazdani42/nvim-tree.lua' -- project browser, use <space><space> to toggle
	use 'kosayoda/nvim-lightbulb'
	-- use 'LoricAndre/OneTerm.nvim' 
	use 'gennaro-tedesco/nvim-peekup' -- See all yank registers use ""
	use 'nvim-lua/plenary.nvim' -- Telescope dependency
	use 'nvim-telescope/telescope.nvim' -- Fuzzy finder over lists
	use 'kyazdani42/nvim-web-devicons' -- Add icons to plugins
	use 'nvim-treesitter/nvim-treesitter' -- Parsesr and highlighter for a lot of languages
	use 'akinsho/bufferline.nvim' -- bufferline
	use 'johann2357/nvim-smartbufs' -- Smart buffers
	use 'hoob3rt/lualine.nvim' -- Vim mode line
	use 'lewis6991/gitsigns.nvim' -- Git stuff
	use 'b3nj5m1n/kommentary' -- Use gc<motion> to make comment
	use 'tpope/vim-surround' -- change surrounding of text object (use ys<motion> to add surround and cs<motion> to change surrounding
	use 'editorconfig/editorconfig-vim' -- Editor config support
	use 'stevearc/qf_helper.nvim' -- Quickfix helper use :QF{command}
	use 'p00f/nvim-ts-rainbow'
	use 'romgrk/nvim-treesitter-context' -- Shows the context (current function or method)
	use 'justinmk/vim-sneak' -- Go to next ocurrence of two caracters s{char}{char}
	use 'L3MON4D3/LuaSnip' -- Snippets plugin
	use 'mg979/vim-visual-multi' -- Multiple cursors (use Ctrl+n to select word and Ctrl+Down/Up)
	-- use 'junegunn/vim-easy-align' -- Use ga<text> to align
	use 'tommcdo/vim-exchange' -- use gl<text> to align
	use 'michaeljsmith/vim-indent-object' -- add indent text object for motions ii ai 
	use 'tommcdo/vim-exchange' -- mark with cx<motion> and substitute with cx<motion>
	use 'vim-scripts/argtextobj.vim' -- add argument text object ia aa

	-- Lsp and DAP =======================
	use 'neovim/nvim-lspconfig' -- Common lsp configurations
	use 'nvim-lua/lsp-status.nvim' -- lsp status
	use 'nvim-lua/lsp_extensions.nvim'
	use 'RishabhRD/nvim-lsputils'
	--[[ use 'mfussenegger/nvim-dap'
	use 'rcarriga/nvim-dap-ui' ]]
	use 'folke/lsp-colors.nvim'
	use 'ojroques/nvim-lspfuzzy'
	use 'onsails/lspkind.nvim'
	use 'williamboman/nvim-lsp-installer'

	-- Autocompletion =======================
	use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
	use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
	use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
	use 'hrsh7th/cmp-path'
	use 'hrsh7th/cmp-buffer'
	use 'hrsh7th/cmp-cmdline'
	use 'ray-x/cmp-treesitter'

	-- Color schemes =======================
	use 'tjdevries/colorbuddy.nvim'
	use 'ishan9299/modus-theme-vim'
	use 'ayu-theme/ayu-vim'
	use 'norcalli/nvim-colorizer.lua'
end)
-- vim: nowrap
