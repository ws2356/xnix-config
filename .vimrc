let &t_TI = ""
let &t_TE = ""

let s:this_file=resolve(expand('<sfile>:p'))
let s:this_dir=fnamemodify(s:this_file, ':p:h')


" vim-plug插件 {{{
" plug begin with given dir; add common plugins
function! StartPlug(plugInDir)
  call plug#begin(a:plugInDir)
  Plug 'scrooloose/nerdtree', { 'commit': '28eb47e2678cf629d92b4f1f00dd56cba22fc4ae' }
  Plug 'ludovicchabant/vim-gutentags', { 'commit': 'eecb136fae97e30d5f01e71f0d3b775c8b017385' }
  Plug 'w0rp/ale', { 'commit': 'a5240009ba5ff22daad95c306f7dec372d46bda0' }
  Plug 'bestofsong/vimconfig', { 'branch': 'master' }
  Plug 'leafgarland/typescript-vim', { 'commit': '7704fac2c765aaf975ad4034933bf63113dd4a64' }
  Plug 'wellle/targets.vim', { 'commit': 'a79447f261e4b8b4327557aa03726f3849334b84' }
  Plug 'easymotion/vim-easymotion', { 'commit': '85e90c9759e14633d878ed534ef313876ab96555' }
  Plug 'tpope/vim-fugitive', { 'commit': '6d42c7df44aa20252e5dac747c3ac9fa7450b21b' }
  Plug 'SirVer/ultisnips', { 'commit': '1a99766b73783bafb08cfa07d7e29e5387c55189' }
  Plug 'honza/vim-snippets', { 'commit': 'a11cf5b47fcb9de72b5c8694a4e2fe2dca8c0ae7' }
  Plug 'tpope/vim-commentary', { 'commit': '141d9d32a9fb58fe474fcc89cd7221eb2dd57b3a' }
  Plug 'tpope/vim-surround', { 'commit': 'ca58a2d886cc18734c90c9665da4775d444b0c04' }
  Plug 'Yggdroot/indentLine', { 'commit': '5617a1cf7d315e6e6f84d825c85e3b669d220bfa' }
  Plug 'tpope/vim-dispatch', { 'commit': '488940870ab478cc443b06d5a62fea7ab999eabf' }
  Plug 'morhetz/gruvbox', { 'commit': 'cb4e7a5643f7d2dd40e694bcbd28c4b89b185e86' }
  Plug 'pangloss/vim-javascript', { 'commit': 'ee445807a71ee6933cd6cbcd74940bc288815793' }
  Plug 'MaxMEllon/vim-jsx-pretty', { 'commit': 'c665d5ca4247b696f478f91b7c97b9e44442e4b6' }
  Plug 'mattn/emmet-vim', { 'commit': 'd698f1658770ca5fa58c87e80421c8d65bbe9065' }
  Plug 'ap/vim-css-color', { 'commit': '8a84356d5319cad3da2835bd5fbc6318500f31ce' }
  Plug 'shumphrey/fugitive-gitlab.vim', { 'commit': '43a13dbbc9aae85338877329ed28c9e4d8488db1' }
  Plug 'jiangmiao/auto-pairs', { 'commit': '39f06b873a8449af8ff6a3eee716d3da14d63a76' }
  Plug 'vim-ruby/vim-ruby', { 'commit': '1aa8f0cd0411c093d81f4139d151f93808e53966' }
  Plug 'junegunn/fzf', {
        \ 'commit': 'ab3937ee5a62d63bac9307bfe72601eeb4fc9cd2',
        \ 'do': { -> fzf#install() }
        \ }
  Plug 'junegunn/fzf.vim' , { 'commit': 'e9d62b4c873f5f207202b4ba5bbd63de7003a0d3' }
  Plug 'vim-airline/vim-airline', { 'commit': 'c213f2ac44292a6c5548872e63acb0648cc07a9a' }
  Plug 'tpope/vim-rhubarb', { 'commit': 'c509c7eedeea641f5b0bdae708581ff610fbff5b' }
  Plug 'vim-scripts/MPage', { 'commit': 'c7915d434d66d51de6f7bb805f353946fd08a5de' }
  Plug 'dart-lang/dart-vim-plugin', { 'commit': '1dca4e12299e26bf4277992fd9b8b22bcc2f4e56' }
  Plug 'prabirshrestha/async.vim', { 'commit': '627a8c4092df24260d3dc2104bc1d944c78f91ca' }
  Plug 'prabirshrestha/vim-lsp', { 'commit': '094a49dccd2d92a57d754bcfaeb5f61b1ead70f4' }
  Plug 'keith/swift.vim', { 'commit': '245e5f7aae6f1bc96849a0a01a58cb81cf56e721' }
  "Plug 'prabirshrestha/asyncomplete.vim', { 'commit': 'db3ab51ef6d42ac410afaea53fc0513afd0d5e25' }
  Plug 'prabirshrestha/asyncomplete-lsp.vim', { 'commit': '9e7b2492578dca86ed12b6352cb56d9fc8ac9a6e' }
  " deoplete needs following two
  Plug 'roxma/nvim-yarp', { 'commit': '83c6f4e61aa73e2a53796ea6690fb7e5e64db50a' }
  Plug 'roxma/vim-hug-neovim-rpc', { 'commit': '701ecbb0a1f904c0b44c6beaafef35e1de998a94' }
  Plug 'Shougo/deoplete.nvim', {
        \ 'commit': '840c46aed8033efe19c7a5a809713c809b4a6bb5',
        \ 'do': 'pip3 show pynvim 2>/dev/null 1>&2 \|\| pip3 install --user --upgrade pynvim'
        \ }
  Plug 'prabirshrestha/asyncomplete-tags.vim', { 'commit': 'eef50f9630db9a772204af13baa997c176ab1a4e' }
  Plug 'neoclide/coc.nvim', {
        \ 'commit': '1a74bf3c57fec8442f837b3baad0d6fb75d1b97a',
        \ 'do': ':CocInstall coc-json coc-tsserver coc-ultisnips coc-tag coc-solargraph coc-python coc-css coc-sourcekit',
        \ }
  Plug 'othree/csscomplete.vim', { 'commit': 'f1c7288a4e63b736678dba6fe4f8e825a8a9fd4b' }
  Plug 'octol/vim-cpp-enhanced-highlight', { 'commit': '27e0ffc215b81fa5aa87eca396acd4421d36c060' }
  Plug 'liuchengxu/vista.vim', {
	\ 'commit': 'dc84cda95c1a408dca72a5e540903b6a8a6bdcfe',
	\ }
        " \ 'do': 'export tmp_repo=\"$(mktemp -d)\" && git clone \"https://github.com/ws2356/fonts\" \"$tmp_repo\"'
        " \ . ' && cd \"${tmp_repo}\" && ./install.sh'
  Plug 'MattesGroeger/vim-bookmarks', { 'commit': '3adeae10639edcba29ea80dafa1c58cf545cb80e' }
endfunction

function! EndPlug()
  call plug#end()
  call s:load_custom_color_scheme()
endfunction
" }}}


" vim-bookmarks config {{{
let g:bookmark_save_per_working_dir = 1
let g:bookmark_auto_save = 1
" }}}


" config for current environment {{{
let s:resolved_clangd = trim(system('xcrun -f clangd'))
let s:resolved_clang = trim(system('xcrun -f clang'))
let s:ncpucores = str2nr(system('getconf _NPROCESSORS_ONLN 2>/dev/null || sysctl -n hw.ncpu | sed "s/[^0-9]//g"'))
let s:resolved_resource_dir = trim(system('xcrun clang -print-resource-dir'))
let s:CLANGD_OPTIONS = ['-completion-style=detailed', '-log=error',
      \'-pretty', '-limit-results=100', '-j=' . s:ncpucores / 2, '-pch-storage=disk',
      \'-resource-dir=' . s:resolved_resource_dir]
" }}}


" load my_func.vim
let s:func_file = s:this_dir . '/my_func.vim'
:execute 'source ' . s:func_file


" 脚本变量 {{{
let g:WS_RIPGREP_GLOB = '--glob !.git/ '
      \ . '--glob !node_modules/ '
      \ . '--glob !tmp/ '
      \ . '--glob !TMP/ '
      \ . '--glob !build/ '
      \ . '--glob !built/ '
      \ . '--glob !.build/ '
      \ . '--glob !.tags '
      \ . '--glob !.tags.temp '
      \ . '--glob !*.pyc '
      \ . '--glob !*.swp '
      \ . '--glob !compile_commands.json '
      \ . '--glob !*.temp '
" }}}


" vim 内置选项等 {{{
set encoding=utf-8
set nocompatible
set termguicolors
set history=10000
set exrc
set secure
set nowrapscan
set wildmenu
set tildeop

set ignorecase
set nogdefault
set smartcase
set relativenumber
set pumheight=10
" Switch syntax highlighting on, when the terminal has colors
syntax on
filetype plugin indent on

" 否则报错
if !has('nvim')
  packadd! matchit
endif

if match(&matchpairs, '<:>') == -1
  set matchpairs+=<:>
endif

let mapleader = ","

set cursorline
set nu
set ruler
set softtabstop=2
set shiftwidth=2
set linebreak
set expandtab
set foldmethod=indent
" foldlevel初始值，高于此值的fold会默认关闭
set foldlevelstart=6
" 搜索逐字符高亮
set hlsearch
set incsearch
set completeopt=menu,menuone,preview,noselect,noinsert
let &grepprg='rg --vimgrep --no-heading --no-ignore --hidden ' . g:WS_RIPGREP_GLOB

function! WS_reload_grepprg()
  let &grepprg='rg --vimgrep --no-heading --no-ignore --hidden ' . g:WS_RIPGREP_GLOB
  let $FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow ' . g:WS_RIPGREP_GLOB
endfunction

" 配置window style
set fillchars+=vert:\ 
" set statusline=%<%f%Y%=\ [%n%1*%M%R%*]\ %-19(%3l,%02c%03V%)'%02b'
" }}}


" 配置tag {{{
set tags=./.tags;
" }}}


" 配置gutentags {{{
" gutentags 搜索工程目录的标志，碰到这些文件/目录名就停止向上一级目录递归
let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']
" 所生成的数据文件的名称
let g:gutentags_ctags_tagfile = '.tags'
" 配置 ctags 的参数
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']
let s:ctags_d = s:this_dir . '/.ctags.d'
if isdirectory(s:ctags_d)
  let g:gutentags_ctags_extra_args += ['--optlib-dir=+' . s:ctags_d]
endif
let g:gutentags_ctags_extra_args += ['--options-maybe=swift.ctags']
let g:gutentags_ctags_exclude = ['node_modules', '.build']
" }}}


" 配置NERDTree {{{
let NERDTreeShowHidden=1
noremap <C-n> :NERDTreeToggle<CR>
noremap <leader>ee :NERDTree <bar> NERDTreeFind <C-R>%<CR>
" }}}



" 配置ale {{{
" nnoremap <leader>] :ALEGoToDefinition<CR>
" nnoremap <leader>\ :ALEGoToDefinitionInVSplit<CR>
" nnoremap <leader>rf :ALEFindReferences<CR>
" nnoremap <leader>hv :ALEHover<CR>
" nnoremap <leader>fsm :ALESymbolSearch <cword><CR>
let g:ale_completion_enabled = 0
let g:ale_set_highlights = 0 " Disable highligting
" let g:ale_set_signs = 0
let g:ale_linters = {
      \ 'javascript': ['eslint', 'tsserver'],
      \ 'cpp': ['clangd'],
      \ 'objc': ['clangd'],
      \ 'objcpp': ['clangd'],
      \ }
let g:ale_cpp_clangd_executable = s:resolved_clangd
let g:ale_cpp_clangd_options = join(s:CLANGD_OPTIONS)
let g:ale_objc_clangd_executable = s:resolved_clangd
let g:ale_objc_clangd_options = join(s:CLANGD_OPTIONS)
let g:ale_objcpp_clangd_executable = s:resolved_clangd
let g:ale_objcpp_clangd_options = join(s:CLANGD_OPTIONS)
if exists('$SOURCEKIT_LSP_PATH')
  let g:ale_sourcekit_lsp_executable=$SOURCEKIT_LSP_PATH
endif
" }}}


" coc {{{
" Remap keys for gotos
" :CocInstall coc-tsserver
" :CocInstall coc-json
nmap <leader>gd <Plug>(coc-definition)
nmap <leader>gy <Plug>(coc-type-definition)
nmap <leader>gi <Plug>(coc-implementation)
nmap <leader>gr <Plug>(coc-references)
set statusline^=%{coc#status()}
let g:coc_snippet_next = '<C-n>'
let g:coc_snippet_prev = '<C-p>'
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : 
      \"\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

inoremap <silent><expr> <c-f> coc#float#has_float() ? coc#float#scroll(1) : "\<c-f>"
inoremap <silent><expr> <c-b> coc#float#has_float() ? coc#float#scroll(0) : "\<c-b>"
" }}}


" vim-lsp {{{
" let g:ws_sourcekit_lsp_path
let g:lsp_log_verbose = 1
let g:lsp_log_file = expand('~/.vim-lsp.log')
let g:lsp_signs_error = {'text': '✗'}
" macos系统可以用下面的命令获取相应环境
" let g:ws_sourcekit_lsp_path = trim(system('xcrun --toolchain swift --find sourcekit-lsp'))
" let g:ws_swift_sdk_path=trim(system('xcrun --toolchain swift -show-sdk-path'))
" let g:ws_swift_triplet='x86_64-apple-macosx10.15'
function! WS_start_sourcekit_lsp()
  if exists('g:ws_sourcekit_lsp_path') && exists('g:ws_swift_sdk_path') && exists('g:ws_swift_triplet')
    " let s:ws_lsp_default_ios_sdk_path=trim(system('get_default_ios_sdk_path'))
    " let s:ws_lsp_swift_host_triplet=trim(system('get_swift_host_triplet'))
    autocmd User lsp_setup call lsp#register_server({
          \ 'name': 'sourcekit-lsp',
          \ 'cmd': {server_info->[
          \   g:ws_sourcekit_lsp_path,
          \   '-Xswiftc', '-sdk',
          \   '-Xswiftc', g:ws_swift_sdk_path,
          \   '-Xswiftc', '-target',
          \   '-Xswiftc', g:ws_swift_triplet]
          \ },
          \ 'whitelist': ['swift'],
          \ })
  else
    echom 'Cannot start swift lsp, because either executable or build option not exist'
  endif
endfunction
" }}}


" 配置SirVer/ultisnips {{{
" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<C-l>"
let g:UltiSnipsJumpForwardTrigger = "<C-j>"
let g:UltiSnipsJumpBackwardTrigger = "<C-k>"
" }}}


" Config indentLine {{{
let g:indentLine_enabled = 1
let g:indentLine_char_list = ['|', '¦', '┆',  '↓', '↑', '†', '·', '‖', 'ˇ', '┊']
nnoremap <leader>ig :IndentLinesToggle<CR>
let g:indentLine_concealcursor = 'c'
" }}}


" 自动命令 ---------------------- {{{
function! WSTurnOnOrOffDeoplete()
  if &filetype == 'swift'
    call deoplete#custom#option('auto_complete', 1)
  else
    call deoplete#custom#option('auto_complete', 0)
  endif
endfunction

augroup mygroup
  autocmd!
  autocmd BufNewFile,BufRead *.ejs set filetype=html
  autocmd BufNewFile,BufRead *.swift set filetype=swift
  autocmd BufNewFile,BufRead *.graphql set filetype=graphql
  " autocmd BufNewFile,BufRead *.tsx set filetype=javascript
  autocmd BufNewFile,BufRead Fastfile set filetype=ruby
  autocmd FileType vim setlocal foldmethod=marker
  " 打开文件时光标自动定位到上次退出时的位置
  autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit'
        \ |   exe "normal! g`\""
        \ | endif
  autocmd FileType json syntax match Comment +\/\/.\+$+
  autocmd FileType * :silent call WSTurnOnOrOffDeoplete()
  autocmd BufRead,BufNewFile {*.markdown,*.md} set filetype=markdown
  autocmd FileType markdown setlocal syntax=off spell
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS noci
  autocmd FileType vista,vista_kind nnoremap <buffer> <silent> / :<c-u>call vista#finder#fzf#Run()<CR>
augroup END
" }}}


" emmet-vim {{{
let g:user_emmet_install_global = 0
let g:user_emmet_settings = {
      \  'javascript.jsx' : {
      \      'extends' : 'jsx',
      \  },
      \}
autocmd mygroup FileType html,css,javascript,typescript,jsx,xml,javascriptreact,typescriptreact EmmetInstall
" }}}


" 配置fugitive-gitlab {{{
let g:fugitive_gitlab_domains = []
" }}}


" 配置tagbar {{{
let g:tagbar_autoclose = 1
let g:tagbar_compact = 1
let g:tagbar_show_linenumbers = 2
let g:tagbar_foldlevel = 1
nnoremap ,6 :TagbarToggle<CR>
" }}}


" 配置fzf {{{
" 环境变量
let $FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow ' . g:WS_RIPGREP_GLOB
let g:fzf_buffers_jump = 1
nnoremap <silent> <C-p>p :Files<CR>
nnoremap <silent> <C-p>b :Buffers<CR>
nnoremap <silent> <C-p>l :Lines<CR>
nnoremap <C-p>f :Rg<Space>
nnoremap <C-p>c :Rg <C-r>=expand('<cword>')<CR>
function! s:copy_results(lines)
  let joined_lines = join(a:lines, "\n")
  if len(a:lines) > 1
    let joined_lines .= "\n"
  endif
  let @+ = joined_lines
endfunction
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit',
  \ 'ctrl-o': function('s:copy_results'),
  \ }
" }}}


" {{{ colorscheme
function! s:load_custom_color_scheme()
  " 依赖plugin的初始化
  set background=light
  colorscheme gruvbox
endfunction
" }}}


" {{{ dart-vim-plugin
let dart_html_in_string=v:true
" }}}


" {{{ asyncomplete
let g:asyncomplete_auto_popup = 1
let g:asyncomplete_popup_delay = 1000
imap <c-\> <Plug>(asyncomplete_force_refresh)
autocmd mygroup User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#tags#get_source_options({
    \ 'name': '.tags',
    \ 'whitelist': ['swift'],
    \ 'completor': function('asyncomplete#sources#tags#completor'),
    \ 'config': {
    \    'max_file_size': 50000000,
    \  },
    \ }))
" }}}


" vista {{{
let g:vista_default_executive = 'coc'
let g:vista_finder_alternative_executives = 'vim-lsp'
let g:vista_executive_for = {
  \ 'c': 'coc',
  \ 'cpp': 'coc',
  \ 'javascript': 'coc',
  \ 'javascriptreact': 'coc',
  \ 'typescript': 'coc',
  \ 'typescriptreact': 'coc',
  \ }
" let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
" Ensure you have installed some decent font to show these pretty symbols, then you can enable icon for the kind.
let g:vista#renderer#enable_icon = 0

nnoremap <C-p>n :Vista coc<CR>
" affect performance
" let g:vista_log_file = expand('~/.vista.vim.log')
" }}}


" vim-cpp-enhanced-highlight {{{
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_posix_standard = 1
let g:cpp_experimental_template_highlight = 1
" }}}


" load my_key_binding.vim
let s:my_key_binding_file = s:this_dir . '/my_key_binding.vim'
:execute 'source ' . s:my_key_binding_file
let s:my_key_binding_shell_file = s:this_dir . '/my_key_binding_shell.vim'
:execute 'source ' . s:my_key_binding_shell_file
let s:my_key_binding_npm_file = s:this_dir . '/my_key_binding_npm.vim'
:execute 'source ' . s:my_key_binding_npm_file

let s:vimrc_local = expand('~') . '/.vimrc.local'
if filereadable(s:vimrc_local)
  :execute 'source ' . s:vimrc_local
endif


call StartPlug('~/.vim/plugged')
" Plug 'xxx/xxx'
call EndPlug()
