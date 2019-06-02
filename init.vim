set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

let s:vim_conf_dir = fnamemodify(resolve(expand('<sfile>:p')), ':h')
let s:base_rc = s:vim_conf_dir . '/.base-vimrc'
:execute 'source ' . s:base_rc

call StartPlug('~/.local/share/nvim/plugged')
call EndPlug()

" Color theme {{{
colorscheme gruvbox
" }}}
