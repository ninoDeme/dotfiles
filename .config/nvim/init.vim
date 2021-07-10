set nocompatible
if has('filetype')
  filetype indent plugin on
endif

" Enable syntax highlighting
if has('syntax')
  syntax on
endif

set runtimepath+=~/.vim/bundle/neobundle.vim/

call neobundle#begin(expand('~/.vim/bundle/'))


NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'bling/vim-airline'
NeoBundle 'vim-airline/vim-airline-themes'
NeoBundle 'vifm/vifm.vim'


call neobundle#end()

filetype plugin indent on


NeoBundleCheck

let mapleader = ","
noremap <leader>p "*p
let g:airline_powerline_fonts = 1
set showcmd
set wildmenu
set hlsearch
set ignorecase
set smartcase

set ruler
set laststatus=2
set confirm
set visualbell
if has('mouse')
	set mouse=a
endif
set cmdheight=2
set number                     " Show current line number
set relativenumber             " Show relative line numbers
noremap <leader>h :NERDTreeToggle<CR>
