

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

nnoremap <silent> <Leader><return> :!alacritty &<CR>

" esc to exit terminal mode
tnoremap <Esc> <C-\><C-n>

" use CTRL+ALT+movement keys to navigate windows in all modes 
tnoremap <silent><C-A-h> <C-\><C-N><C-w>h
tnoremap <silent><C-A-j> <C-\><C-N><C-w>j
tnoremap <silent><C-A-k> <C-\><C-N><C-w>k
tnoremap <silent><C-A-l> <C-\><C-N><C-W>l
inoremap <silent><C-A-h> <C-\><C-N><C-w>h
inoremap <silent><C-A-j> <C-\><C-N><C-w>j
inoremap <silent><C-A-k> <C-\><C-N><C-w>k
inoremap <silent><C-A-l> <C-\><C-N><C-w>l
nnoremap <silent><C-A-h> <C-w>h
nnoremap <silent><C-A-j> <C-w>j
nnoremap <silent><C-A-k> <C-w>k
nnoremap <silent><C-A-l> <C-w>l
