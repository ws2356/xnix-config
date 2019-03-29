let s:vim_conf_dir = fnamemodify(resolve(expand('<sfile>:p')), ':h')
let s:base_rc = s:vim_conf_dir . '/.base-vimrc'
:execute 'source ' . s:base_rc

" vim-plug插件 {{{
call plug#begin('~/.local/share/nvim/plugged')
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'ludovicchabant/vim-gutentags'
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer' }
call plug#end()
" }}}

