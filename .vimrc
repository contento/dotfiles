set tabstop=4
set nocompatible
set shiftwidth=4
syntax on
filetype plugin indent on
set term=screen-256color
colorscheme PaperColor

set autoindent
set bg=dark
set backspace=indent,eol,start
set expandtab
set ignorecase
set incsearch
set laststatus=2
set linebreak
set nobackup
set noerrorbells
set nolist
set noswapfile
set novb
set nowrap
set number
set relativenumber
set ruler
set scrolloff=8
set showmatch
set shiftwidth=4
set shortmess=I
set showcmd
set showmode
set sidescroll=1
set sidescrolloff=7
set smartcase
set softtabstop=4
set undolevels=1000
set nrformats-=octal
set vb
" >>> Vim-Plug 
" # https://github.com/junegunn/vim-plug

call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdtree'
map <C-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1

Plug 'scrooloose/syntastic'

Plug 'ctrlpvim/ctrlp.vim'
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline_theme='powerlineish'

Plug 'tpope/vim-surround'

Plug 'neoclide/coc.nvim'

call plug#end()

" # << Vim-Plug
