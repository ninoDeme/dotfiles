filetype plugin indent on

set termguicolors

if has('mouse')
	set mouse=a
endif

set wildmenu

" Set highlight on search
set hlsearch

" deal with case sensitivity on search
set ignorecase
set smartcase

set hidden
set ruler
set laststatus=2
set confirm
set visualbell

" add manual folding
set foldmethod=marker
set cmdheight=2
set number
set relativenumber

" save undo history
set undofile

" Press ESC to clear search
nnoremap <silent> <ESC> :nohlsearch<CR><ESC>

" Set completeopt to have a better completion experience
set completeopt=menu,menuone,noselect

" Avoid showing message extra message when using completion
set shortmess+=c

" copy and paste from system clipboard
noremap <Leader>Y "*y
noremap <Leader>P "*p
noremap <Leader>y "+y
noremap <Leader>p "+p

" reload config
nnoremap <leader>r :source $MYVIMRC<CR>

" esc to exit terminal mode
tnoremap <Esc> <C-\><C-n>
