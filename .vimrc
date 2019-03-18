" vim-plug插件
call plug#begin('~/.vim/plugged')
" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
" Initialize plugin system
call plug#end()


" 自定义插件Add vim config search path, and source config files in it
" set runtimepath+=~/.vim/config
" runtime basic.vim
" runtime plugins.vim
" runtime bindings.vim

" 手工搜索并加载config文件
" for f in split(glob('~/.vim/config/*.vim'), '\n')
"   exe 'source' f
" endfor


set nocompatible

" Switch syntax highlighting on, when the terminal has colors
syntax on

set nu
set ruler

set tabstop=2

set foldmethod=indent
set shiftwidth=2
set foldlevel=0

"搜索逐字符高亮
set hlsearch
set incsearch

" 配置tag
set tags=./.tags;

" key bindings
map <C-n> :NERDTreeToggle<CR>

