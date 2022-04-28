set nocompatible
if has('filetype')
  filetype indent plugin on
endif

" Enable syntax highlighting
if has('syntax')
  syntax on
endif

" Plugins {{{
call plug#begin(stdpath('data') . '/plugged')

Plug 'lambdalisue/vim-manpager'
Plug 'vifm/vifm.vim'
Plug 'dag/vim-fish'
Plug 'lambdalisue/vim-pager'
Plug 'chrisbra/Colorizer'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'kosayoda/nvim-lightbulb'
Plug 'simrat39/rust-tools.nvim'
Plug 'nvim-lua/completion-nvim'
Plug 'LoricAndre/OneTerm.nvim'
Plug 'gennaro-tedesco/nvim-peekup'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'mfussenegger/nvim-jdtls'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} 
Plug 'preservim/nerdcommenter'
Plug 'xiyaowong/nvim-transparent' 
Plug 'akinsho/bufferline.nvim'
Plug 'johann2357/nvim-smartbufs'
Plug 'hoob3rt/lualine.nvim'
Plug 'glepnir/dashboard-nvim'
Plug 'nvim-treesitter/completion-treesitter'
Plug 'lewis6991/gitsigns.nvim'
Plug 'b3nj5m1n/kommentary'
Plug 'tpope/vim-surround'
Plug 'editorconfig/editorconfig-vim'
Plug 'stevearc/qf_helper.nvim'
Plug 'p00f/nvim-ts-rainbow'
Plug 'romgrk/nvim-treesitter-context'
Plug 'justinmk/vim-sneak'
Plug 'kristijanhusak/orgmode.nvim'
Plug 'L3MON4D3/LuaSnip' " Snippets plugin

" Lsp and DAP
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp-status.nvim'
Plug 'nvim-lua/lsp_extensions.nvim'
Plug 'RishabhRD/nvim-lsputils'
Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'
Plug 'folke/lsp-colors.nvim'
Plug 'ojroques/nvim-lspfuzzy'
Plug 'onsails/lspkind-nvim'
Plug 'williamboman/nvim-lsp-installer'

" Autocompletion
Plug 'hrsh7th/nvim-cmp' " Autocompletion plugin
Plug 'hrsh7th/cmp-nvim-lsp' " LSP source for nvim-cmp
Plug 'saadparwaiz1/cmp_luasnip' " Snippets source for nvim-cmp

" Color schemes
Plug 'norcalli/nvim-colorizer.lua'
Plug 'tjdevries/colorbuddy.nvim'
Plug 'RishabhRD/nvim-rdark'
Plug 'ishan9299/modus-theme-vim'
Plug 'Yagua/nebulous.nvim'

call plug#end() " }}}

filetype plugin indent on
colorscheme modus-vivendi
set termguicolors

lua <<EOF

local lsp_installer = require("nvim-lsp-installer")

-- Register a handler that will be called for each installed server when it's ready (i.e. when installation is finished
-- or if the server is already installed).
lsp_installer.on_server_ready(function(server) --{{{
    local opts = {}

    -- (optional) Customize the options passed to the server
    -- if server.name == "tsserver" then
    --     opts.root_dir = function() ... end
    -- end

    -- This setup() function will take the provided server configuration and decorate it with the necessary properties
    -- before passing it onwards to lspconfig.
    -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
    server:setup(opts)
    end) --}}}
local lspconfig = require('lspconfig')

require'nvim-tree'.setup()
local cmp = require 'cmp'
cmp.setup { --{{{
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
} --}}}

require('lualine').setup{
	options = {
 		theme = 'codedark',
 		section_separators = '',
		component_separators = '|'
	}
}
require('orgmode').setup_ts_grammar()
require('orgmode').setup({
  org_agenda_files = {'~/Documents/org/*', '~/my-orgs/**/*'},
  org_default_notes_file = '~/Documents/org/refile.org',
})
vim.g.completion_chain_complete_list = {
  org = {
    { mode = 'omni'},
  },
}
require('gitsigns').setup{
	signcolumn = true,
	numhl = true,
	current_line_blame = true,
}
vim.cmd[[autocmd FileType org setlocal iskeyword+=:,#,+]]
require'colorizer'.setup()
require("bufferline").setup{}
require('kommentary.config').use_extended_mappings()
require'qf_helper'.setup()
require'nvim-treesitter.configs'.setup {
  rainbow = {
    enable = true
  }
}
require'treesitter-context'.setup{enable = true, throttle = true,}
require("dapui").setup()
require'nvim-web-devicons'.setup()

EOF

autocmd BufEnter * lua require'completion'.on_attach()
let mapleader = "\<Space>"
set showcmd
let g:dashboard_default_executive ='telescope'
set wildmenu
set hlsearch
set ignorecase
set smartcase
set hidden
set omnifunc=v:lua.vim.lsp.omnifunc
let g:colorizer_auto_filetype='css,html,man'
set ruler
set laststatus=2
set confirm
set visualbell
set foldmethod=marker
if has('mouse')
	set mouse=a
endif
set guifont=RobotoMono\ Nerd\ Font:h9
set cmdheight=2
set number                     " Show current line number
set relativenumber             " Show relative line numbers

" Press ESC to clear search
nnoremap <silent> <ESC> :nohlsearch<CR><ESC>

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion
set shortmess+=c

noremap <leader><leader> :NvimTreeToggle<CR>

"copy and paste from system clipboard
noremap <Leader>Y "*y
noremap <Leader>P "*p
noremap <Leader>y "+y
noremap <Leader>p "+p
" reload config
nnoremap <leader>sv :source $MYVIMRC<CR>

" DAP mode bindings
noremap <leader>dd :lua require("dapui").toggle("sidebar")<CR>
noremap <F5> :lua require'dap'.continue()<CR>
noremap <leader>db :lua require'dap'.toggle_breakpoint()<CR>

" Go to next buffer (alt-tab equivalent)
noremap <leader><Tab> :BufferLineCycleNext<CR>

" close current buffer
nnoremap <silent><Leader>qq :lua require("nvim-smartbufs").close_current_buffer()<CR>

" open numbered terminals
nnoremap <Leader>t1 :lua require("nvim-smartbufs").goto_terminal(1)<CR>
nnoremap <Leader>t2 :lua require("nvim-smartbufs").goto_terminal(2)<CR>
nnoremap <Leader>t3 :lua require("nvim-smartbufs").goto_terminal(3)<CR>
nnoremap <Leader>t4 :lua require("nvim-smartbufs").goto_terminal(4)<CR>

" exit terminal mode
tnoremap <Esc> <C-\><C-n>

" use ALT+movement keys to navigate windows in all modes {{{
tnoremap <silent><A-h> <C-\><C-N><C-w>h
tnoremap <silent><C-A-h> <C-\><C-N>:BufferLineCyclePrev<CR>
tnoremap <silent><A-j> <C-\><C-N><C-w>j
tnoremap <silent><A-k> <C-\><C-N><C-w>k
tnoremap <silent><A-l> <C-\><C-N><C-W>l
tnoremap <silent><C-A-l> <C-\><C-N>:BufferLineCycleNext<CR>
inoremap <silent><A-h> <C-\><C-N><C-w>h
inoremap <silent><C-A-h> <C-\><C-N>:BufferLineCyclePrev<CR>
inoremap <silent><A-j> <C-\><C-N><C-w>j
inoremap <silent><A-k> <C-\><C-N><C-w>k
inoremap <silent><A-l> <C-\><C-N><C-w>l
inoremap <silent><C-A-l> <C-\><C-N>:BufferLineCycleNext<CR>
nnoremap <silent><A-h> <C-w>h
nnoremap <silent><C-A-h> :BufferLineCyclePrev<CR>
nnoremap <silent><A-j> <C-w>j
nnoremap <silent><A-k> <C-w>k
nnoremap <silent><A-l> <C-w>l
nnoremap <silent><C-A-l> :BufferLineCycleNext<CR>
" }}}

