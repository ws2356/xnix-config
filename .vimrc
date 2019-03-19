let mapleader = ","

" vim-plug插件 {{{
call plug#begin('~/.vim/plugged')
" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
" Initialize plugin system
call plug#end()
" }}}

set nocompatible

" Switch syntax highlighting on, when the terminal has colors
syntax on

set nu
set ruler
set tabstop=2
set expandtab

set foldmethod=indent
set shiftwidth=2
set foldlevel=0

" 搜索逐字符高亮
set hlsearch
set incsearch

" hack {{{
" trick netrm not to load
let loaded_netrwPlugin = 1
" }}}

" 配置tag
set tags=./.tags;

" key bindings {{{
noremap <C-n> :NERDTreeToggle<CR>

nnoremap <leader>ev :vsplit $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>
" 练习
nnoremap <leader>g :silent execute "grep! -R " . shellescape(expand("<cword>")) . " ."<cr>:copen<cr>

" 编辑快捷键
inoremap <C-d> <esc>ddi
" }}}

" 自动命令 ---------------------- {{{
augroup mygroup
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
		autocmd VimEnter * call MyOpenNERDTreeIfNeeded()
augroup END
" }}}

function! MyOpenNERDTreeIfNeeded()
	if argc() == 0 || getftype(expand('%:p')) ==# "dir"
    NERDTree
	endif
endfunction

