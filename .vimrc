set encoding=utf-8
set nocompatible


" vim-plug插件 {{{
call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'ludovicchabant/vim-gutentags'
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer' }
call plug#end()
" }}}


let mapleader = ","

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


" 关闭netrw {{{
let loaded_netrwPlugin = 1
" }}}


" 配置tag
set tags=./.tags;


" 配置gutentags {{{
" gutentags 搜索工程目录的标志，碰到这些文件/目录名就停止向上一级目录递归
let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']

" 所生成的数据文件的名称
let g:gutentags_ctags_tagfile = '.tags'

" 将自动生成的 tags 文件全部放入 ~/.cache/tags 目录中，避免污染工程目录
let s:vim_tags = expand('~/.cache/tags')
let g:gutentags_cache_dir = s:vim_tags

" 配置 ctags 的参数
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']

" 检测 ~/.cache/tags 不存在就新建
if !isdirectory(s:vim_tags)
   silent! call mkdir(s:vim_tags, 'p')
endif
" }}}


" key bindings {{{
noremap <C-n> :NERDTreeToggle<CR>

nnoremap <leader>ev :vsplit $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>
" 练习
nnoremap <leader>g :silent execute "grep! -R " . shellescape(expand("<cword>")) . " ."<cr>:copen<cr>

" 编辑快捷键
inoremap <C-d> <esc>ddi
" 向前/后跳转至{/}符号
map [[ ?{<CR>w99[{
map ][ /}<CR>b99]}
map ]] j0[[%/{<CR>
map [] k$][%?}<CR>
" }}}


" 自动命令 ---------------------- {{{
augroup mygroup
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
		autocmd VimEnter * call MyOpenNERDTreeIfNeeded()
augroup END

function! MyOpenNERDTreeIfNeeded()
	if argc() == 0 || getftype(expand('%:p')) ==# "dir"
    NERDTree
	endif
endfunction

" }}}

