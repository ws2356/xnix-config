set encoding=utf-8
set nocompatible

let s:vim_conf_dir = fnamemodify(resolve(expand('<sfile>:p')), ':h')
let s:base_rc = s:vim_conf_dir . '/.base-vimrc'
:execute 'source ' . s:base_rc

" 自带的插件 {{{
packadd! matchit
" }}}

call StartPlug('~/.vim/plugged')
