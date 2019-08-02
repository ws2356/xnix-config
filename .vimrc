set encoding=utf-8
set nocompatible

let s:vim_conf_dir = fnamemodify(resolve(expand('<sfile>:p')), ':h')
let s:base_rc = s:vim_conf_dir . '/.base-vimrc'
:execute 'source ' . s:base_rc

call StartPlug('~/.vim/plugged')
" Plug 'xxx/xxx'
call EndPlug()

" Color theme {{{
colorscheme gruvbox
" }}}
