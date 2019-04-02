set encoding=utf-8
set nocompatible

let s:vim_conf_dir = fnamemodify(resolve(expand('<sfile>:p')), ':h')
let s:base_rc = s:vim_conf_dir . '/.base-vimrc'
:execute 'source ' . s:base_rc

" 自带的插件 {{{
packadd! matchit
" }}}

" vim-plug插件 {{{
call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'ludovicchabant/vim-gutentags'
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer' }
Plug 'w0rp/ale'
Plug 'bestofsong/vimconfig'
Plug 'leafgarland/typescript-vim'
Plug 'Quramy/tsuquyomi'
Plug 'kien/ctrlp.vim'
call plug#end()
" }}}


