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
	use {'lambdalisue/vim-manpager', disable = vim.g.vscode} -- Use vim as a manpager
	use {'dag/vim-fish', disable = vim.g.vscode} -- Fish integration
	use {'lambdalisue/vim-pager', disable = vim.g.vscode} -- Use vim as a pager
	-- use 'chrisbra/Colorizer'
	use {'kyazdani42/nvim-tree.lua', disable = vim.g.vscode} -- project browser, use <space><space> to toggle
	use {'kosayoda/nvim-lightbulb', disable = vim.g.vscode}
	use {'gennaro-tedesco/nvim-peekup', disable = vim.g.vscode} -- See all yank registers use ""
	use {'nvim-lua/plenary.nvim', disable = vim.g.vscode} -- Telescope dependency
	use {'nvim-telescope/telescope.nvim', disable = vim.g.vscode} -- Fuzzy finder over lists
	use {'kyazdani42/nvim-web-devicons', disable = vim.g.vscode} -- Add icons to plugins
	use {'nvim-treesitter/nvim-treesitter', disable = vim.g.vscode} -- Parsesr and highlighter for a lot of languages
	use {'akinsho/bufferline.nvim', disable = vim.g.vscode} -- bufferline
	use {'johann2357/nvim-smartbufs', disable = vim.g.vscode} -- Smart buffers
	use {'hoob3rt/lualine.nvim', disable = vim.g.vscode} -- Vim mode line
	use {'lewis6991/gitsigns.nvim', disable = vim.g.vscode} -- Git stuff
	use {'b3nj5m1n/kommentary', disable = vim.g.vscode} -- Use gc<motion> to make comment
	use 'tpope/vim-surround' -- change surrounding of text object (use ys<motion> to add surround and cs<motion> to change surrounding
	use 'editorconfig/editorconfig-vim' -- Editor config support
	use {'stevearc/qf_helper.nvim', disable = vim.g.vscode} -- Quickfix helper use :QF{command}
	use {'p00f/nvim-ts-rainbow', disable = vim.g.vscode}
	use {'romgrk/nvim-treesitter-context', disable = vim.g.vscode} -- Shows the context (current function or method)
	use 'justinmk/vim-sneak' -- Go to next ocurrence of two caracters s{char}{char}
	use {'L3MON4D3/LuaSnip', disable = vim.g.vscode} -- Snippets plugin
	use 'mg979/vim-visual-multi' -- Multiple cursors (use Ctrl+n to select word and Ctrl+Down/Up)
	use 'tommcdo/vim-lion' -- use gl<text> to align
	use 'michaeljsmith/vim-indent-object' -- add indent text object for motions ii ai 
	use({
		"gbprod/substitute.nvim",
		config = function()
			require("substitute").setup({})
		end
	})
	use 'vim-scripts/argtextobj.vim' -- add argument text object ia aa
	use {'folke/which-key.nvim', disable = vim.g.vscode}

	-- Lsp and DAP =======================
	use {'neovim/nvim-lspconfig', disable = vim.g.vscode} -- Common lsp configurations
	use {'nvim-lua/lsp-status.nvim', disable = vim.g.vscode} -- lsp status
	use {'nvim-lua/lsp_extensions.nvim', disable = vim.g.vscode}
	use {'RishabhRD/nvim-lsputils', disable = vim.g.vscode}
	--[[ use 'mfussenegger/nvim-dap'
	use 'rcarriga/nvim-dap-ui' ]]
	use {'folke/lsp-colors.nvim', disable = vim.g.vscode}
	use {'ojroques/nvim-lspfuzzy', disable = vim.g.vscode}
	use {'onsails/lspkind.nvim', disable = vim.g.vscode}
	use {'williamboman/nvim-lsp-installer', disable = vim.g.vscode}

	-- Autocompletion =======================
	use {'hrsh7th/nvim-cmp', disable = vim.g.vscode} -- Autocompletion plugin
	use {'hrsh7th/cmp-nvim-lsp', disable = vim.g.vscode} -- LSP source for nvim-cmp
	use {'saadparwaiz1/cmp_luasnip', disable = vim.g.vscode} -- Snippets source for nvim-cmp
	use {'hrsh7th/cmp-path', disable = vim.g.vscode}
	use {'hrsh7th/cmp-buffer', disable = vim.g.vscode}
	use {'hrsh7th/cmp-cmdline', disable = vim.g.vscode}
	use {'ray-x/cmp-treesitter', disable = vim.g.vscode}

	-- Color schemes =======================
	use {'tjdevries/colorbuddy.nvim', disable = vim.g.vscode}
	use {'ishan9299/modus-theme-vim', disable = vim.g.vscode}
	use {'ayu-theme/ayu-vim', disable = vim.g.vscode}
	use {'norcalli/nvim-colorizer.lua', disable = vim.g.vscode}

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if packer_bootstrap then
		require('packer').sync()
	end

end)
-- vim: nowrap
