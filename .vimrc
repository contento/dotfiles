set tabstop=4
set nocompatible
set shiftwidth=4
syntax on
filetype plugin indent on
set term=screen-256color

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

highlight ColorColumn ctermbg=black
set colorcolumn=80

" >>> Vim-Plug 
" # https://github.com/junegunn/vim-plug

call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdtree'
map <C-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1

Plug 'scrooloose/nerdcommenter'
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
" Align line-wise comment delimiters flush left instead of following code
" indentation
let g:NERDDefaultAlign = 'left'

" Allow commenting and inverting empty lines (useful when commenting a
" region)
let g:NERDCommentEmptyLines = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

Plug 'tpope/vim-markdown'

Plug 'scrooloose/syntastic'
let g:syntastic_python_flake8_args = "--ignore=E501 --max-complexity 10"

Plug 'ctrlpvim/ctrlp.vim'
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline_theme='powerlineish'

" Plug 'chriskempson/base16-vim'
" colorscheme base16-default-dark 

Plug 'tpope/vim-surround'

Plug 'neoclide/coc.nvim' , {'branch': 'release'}

call plug#end()

" # << Vim-Plug
