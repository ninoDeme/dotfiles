set nocompatible
if has('filetype')
  filetype indent plugin on
endif

" Enable syntax highlighting
if has('syntax')
  syntax on
endif

" Plugins
call plug#begin(stdpath('data') . '/plugged')

Plug 'vifm/vifm.vim'
Plug 'dag/vim-fish'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp-status.nvim'
Plug 'nvim-lua/lsp_extensions.nvim'
Plug 'RishabhRD/nvim-lsputils'
Plug 'kosayoda/nvim-lightbulb'
Plug 'simrat39/rust-tools.nvim'
Plug 'folke/lsp-colors.nvim'
Plug 'ojroques/nvim-lspfuzzy'
Plug 'onsails/lspkind-nvim'
Plug 'kabouzeid/nvim-lspinstall'
Plug 'nvim-lua/completion-nvim'
Plug 'blackCauldron7/surround.nvim'
Plug 'LoricAndre/OneTerm.nvim'
Plug 'gennaro-tedesco/nvim-peekup'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'mfussenegger/nvim-jdtls'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} 
Plug 'preservim/nerdcommenter'
Plug 'xiyaowong/nvim-transparent' 
Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'
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
Plug 'liuchengxu/vim-which-key'
Plug 'AckslD/nvim-whichkey-setup.lua'
Plug 'kristijanhusak/orgmode.nvim'
Plug 'famiu/feline.nvim'

" Color schemes
Plug 'norcalli/nvim-colorizer.lua'
Plug 'tjdevries/colorbuddy.nvim'
Plug 'RishabhRD/nvim-rdark'
Plug 'ishan9299/modus-theme-vim'
Plug 'Yagua/nebulous.nvim'

call plug#end()

filetype plugin indent on
colorscheme nebulous

lua <<EOF

local function setup_servers()
  require'lspinstall'.setup()
  local servers = require'lspinstall'.installed_servers()
  for _, server in pairs(servers) do
    require'lspconfig'[server].setup{}
  end
end
setup_servers()
 -- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
require'lspinstall'.post_install_hook = function ()
  setup_servers() -- reload installed servers
  vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end

require('lualine').setup{
	options = {
 		theme = 'codedark',
 		section_separators = '',
		component_separators = '|'
	}
}
-- require('feline').setup({
--     preset = 'noicon'
-- })
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
require("whichkey_setup").config{
    hide_statusline = false,
    default_keymap_settings = {
        noremap=true,
    },
    default_mode = 'n',
}
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
set termguicolors
set hidden

set ruler
set laststatus=2
set confirm
set visualbell
if has('mouse')
	set mouse=a
endif
set guifont=RobotoMono\ Nerd\ Font:h9
set cmdheight=2
set number                     " Show current line number
set relativenumber             " Show relative line numbers
" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect
" Avoid showing message extra message when using completion
set shortmess+=c
noremap <leader><leader> :NvimTreeToggle<CR>
" paste from system clipboard
noremap <leader>p "*p
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
" use ALT+movement keys to navigate windows in all modes
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

