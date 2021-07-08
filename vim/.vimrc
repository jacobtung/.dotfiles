"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""                     jacob's vimrc file                          ""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"" BASIC SETTING
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" looklike
syntax on
set number
set t_Co=256
set background=dark
colorscheme nord

" function
set noswapfile
set nobackup
set undofile
set undodir=~/.vim/.undo//
set noerrorbells

" editor
set smartindent
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set textwidth=79
set nowrap
set colorcolumn=80
highlight ColorColumn ctermbg=0 guibg=lightgrey

" search
set incsearch

"" PLUGINS SETTING
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')

    Plug 'ap/vim-css-color'
    Plug 'itchyny/lightline.vim'
    Plug 'preservim/nerdtree'
    Plug 'arcticicestudio/nord-vim'

call plug#end()

" lighline.vim setting
let g:lightline =
    \{
    \ 'colorscheme':'one',
    \ }