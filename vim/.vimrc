"      █████ █      ██          █████  █     █████   ██    ██       █████ ███       █ ███ █ 
"   ██████  █    █████       ██████  █    ██████  █████ █████    ██████  █ ██     █  ████  █
"  ██   █  █       █████    ██   █  █    ██   █  █  █████ █████ ██   █  █  ██    █  █  ████ 
" █    █  ██       █ ██    █    █  █    █    █  █   █ ██  █ ██ █    █  █   ██   █  ██   ██  
"     █  ███      █   █        █  █         █  █    █     █        █  █    █   █  ███       
"    ██   ██      █           ██ ██        ██ ██    █     █       ██ ██   █   ██   ██       
"    ██   ██      █           ██ ██        ██ ██    █     █       ██ ██  █    ██   ██       
"    ██   ██     █          ████ ██        ██ ██    █     █       ██ ████     ██   ██       
"    ██   ██     █         █ ███ ██        ██ ██    █     █       ██ ██  ███  ██   ██       
"    ██   ██     █            ██ ██        ██ ██    █     ██      ██ ██    ██ ██   ██       
"     ██  ██    █        ██   ██ ██        █  ██    █     ██      █  ██    ██  ██  ██       
"      ██ █     █       ███   █  █            █     █      ██        █     ██   ██ █      █ 
"       ███     █        ███    █         ████      █      ██    ████      ███   ███     █  
"        ███████          ██████         █  █████           ██  █  ████    ██     ███████   
"          ███              ███         █     ██               █    ██     █        ███     
"                                       █                      █                            
"                                        █                      █                           
"                                         ██                     ██                         
"                                                                                           
"
set nocompatible

set number relativenumber

set tabstop=4
set expandtab
set shiftwidth=4

set path+=**

set wildmode=full
set wildmenu

let mapleader=" "

"force yourself not to not use arrow keys

nnoremap <Up> <nop>
nnoremap <Down> <nop>
nnoremap <Left> <nop>
nnoremap <Right> <nop>
inoremap <Up> <nop>
inoremap <Down> <nop>
inoremap <Left> <nop>
inoremap <Right> <nop>

"custom mappings

nnoremap <Leader>s :so ~/.vimrc<Cr>
nnoremap <Leader>h :echo "hello"<Cr>
nnoremap <Leader>N :NERDTree<Cr>

""" config for ctrlP

let g:ctrlp_show_hidden=1
let g:ctrlp_max_files=0
if executable('rg')
    set grepprg=rg\ --color=never
    let g:ctrlp_user_command='rg %s --files --color=never --glob ""'
    let g:ctrlp_use_caching=0
endif

""" config for gitgutter

nnoremap ]g :GitGutterDiffOrig<Cr><C-w>h
set updatetime=250

""" config for ale
nmap <Leader>d <Plug>(ale_go_to_definition)
nmap <Leader>r <Plug>(ale_find_references)



highlight GitGutterAdd     ctermbg=black ctermfg=green
highlight GitGutterChange  ctermbg=black ctermfg=yellow
highlight GitGutterDelete  ctermbg=black ctermfg=red
highlight! link SignColumn LineNr

"VIM PLUG

call plug#begin()
    Plug 'preservim/nerdtree'
    Plug 'bfrg/vim-cpp-modern'
    Plug 'airblade/vim-gitgutter'
    Plug 'tpope/vim-fugitive'
    Plug 'ctrlpvim/ctrlp.vim'
    Plug 'dense-analysis/ale'
call plug#end()

