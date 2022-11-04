set nocompatible

set number relativenumber

set tabstop=4
set expandtab
set shiftwidth=4

set path+=**

set wildmode=full
set wildmenu

"force yourself not to not use arrow keys

nnoremap <Up> <nop>
nnoremap <Down> <nop>
nnoremap <Left> <nop>
nnoremap <Right> <nop>
inoremap <Up> <nop>
inoremap <Down> <nop>
inoremap <Left> <nop>
inoremap <Right> <nop>

nnoremap <C-h> :tabf  <C-r>%<Bs>h<Cr>                       "open header for c file if it exists
nnoremap <C-h><C-p> :tabf <C-r>%<Bs><Bs><Bs>h<Cr>           "open h header for cpp file if it exists
nnoremap <C-h><C-p><C-p> :tabf <C-r>%<Bs><Bs><Bs>hpp<Cr>    "open hpp header for cpp file if it exists

"VIM PLUG

call plug#begin()
    Plug 'preservim/nerdtree'
    Plug 'bfrg/vim-cpp-modern'
call plug#end()

