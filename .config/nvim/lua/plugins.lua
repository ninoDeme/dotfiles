-- ~/.config/nvim/init.lua
vim.cmd [[packadd packer.nvim]]
return require('packer').startup(function(use)

	use 'wbthomason/packer.nvim'
	use 'lambdalisue/vim-manpager'
	use 'vifm/vifm.vim'
	use 'dag/vim-fish'
	use 'lambdalisue/vim-pager'
	-- use 'chrisbra/Colorizer'
	use 'kyazdani42/nvim-tree.lua'
	use 'kosayoda/nvim-lightbulb'
	use 'LoricAndre/OneTerm.nvim'
	use 'gennaro-tedesco/nvim-peekup'
	use 'nvim-lua/plenary.nvim'
	use 'nvim-telescope/telescope.nvim'
	use 'kyazdani42/nvim-web-devicons'
	use 'nvim-treesitter/nvim-treesitter'
	use 'akinsho/bufferline.nvim'
	use 'johann2357/nvim-smartbufs'
	use 'hoob3rt/lualine.nvim'
	use 'glepnir/dashboard-nvim'
	use 'lewis6991/gitsigns.nvim'
	use 'b3nj5m1n/kommentary'
	use 'tpope/vim-surround'
	use 'editorconfig/editorconfig-vim'
	use 'stevearc/qf_helper.nvim'
	use 'p00f/nvim-ts-rainbow'
	use 'romgrk/nvim-treesitter-context'
	use 'justinmk/vim-sneak'
	use 'L3MON4D3/LuaSnip' -- Snippets plugin
	use 'ludovicchabant/vim-gutentags'

-- Lsp and DAP
	use 'neovim/nvim-lspconfig'
	use 'nvim-lua/lsp-status.nvim'
	use 'nvim-lua/lsp_extensions.nvim'
	use 'RishabhRD/nvim-lsputils'
	--[[ use 'mfussenegger/nvim-dap'
	use 'rcarriga/nvim-dap-ui' ]]
	use 'folke/lsp-colors.nvim'
	use 'ojroques/nvim-lspfuzzy'
	use 'onsails/lspkind.nvim'
	use 'williamboman/nvim-lsp-installer'
	use'MunifTanjim/prettier.nvim'

-- Autocompletion
	use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
	use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
	use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
	use 'hrsh7th/cmp-path'
	use 'hrsh7th/cmp-buffer'
	use 'hrsh7th/cmp-cmdline'
	use 'ray-x/cmp-treesitter'

-- Color schemes
	use 'tjdevries/colorbuddy.nvim'
	use 'ishan9299/modus-theme-vim'
	use 'norcalli/nvim-colorizer.lua'
end)
