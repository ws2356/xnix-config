let s:this_file=resolve(expand('<sfile>:p'))
let s:this_dir=fnamemodify(s:this_file, ':p:h')


" vim-plug插件 {{{
" plug begin with given dir; add common plugins
function! StartPlug(plugInDir)
  call plug#begin(a:plugInDir)
  Plug 'scrooloose/nerdtree', { 'commit': '28eb47e2678cf629d92b4f1f00dd56cba22fc4ae' }
  Plug 'ludovicchabant/vim-gutentags', { 'commit': 'eecb136fae97e30d5f01e71f0d3b775c8b017385' }
  Plug 'Valloric/YouCompleteMe', { 'commit': '04c3505129cd80b92f1b6177dca8aecc55cb0760' }
  Plug 'w0rp/ale', { 'commit': 'a5240009ba5ff22daad95c306f7dec372d46bda0' }
  Plug 'bestofsong/vimconfig', { 'commit': 'e4e034afdaf8b979d047e4160859bb8f5fd4d4e0' }
  Plug 'leafgarland/typescript-vim', { 'commit': '7704fac2c765aaf975ad4034933bf63113dd4a64' }
  " Plug 'godlygeek/tabular', { 'commit': '339091ac4dd1f17e225fe7d57b48aff55f99b23a' }
  Plug 'wellle/targets.vim', { 'commit': 'a79447f261e4b8b4327557aa03726f3849334b84' }
  Plug 'easymotion/vim-easymotion', { 'commit': '85e90c9759e14633d878ed534ef313876ab96555' }
  Plug 'tpope/vim-fugitive', { 'commit': '6d42c7df44aa20252e5dac747c3ac9fa7450b21b' }
  Plug 'SirVer/ultisnips', { 'commit': '1a99766b73783bafb08cfa07d7e29e5387c55189' }
  Plug 'honza/vim-snippets', { 'commit': 'a11cf5b47fcb9de72b5c8694a4e2fe2dca8c0ae7' }
  Plug 'tpope/vim-commentary', { 'commit': '141d9d32a9fb58fe474fcc89cd7221eb2dd57b3a' }
  Plug 'tpope/vim-surround', { 'commit': 'ca58a2d886cc18734c90c9665da4775d444b0c04' }
  Plug 'Yggdroot/indentLine', { 'commit': '47648734706fb2cd0e4d4350f12157d1e5f4c465' }
  Plug 'tpope/vim-dispatch', { 'commit': '488940870ab478cc443b06d5a62fea7ab999eabf' }
  Plug 'morhetz/gruvbox', { 'commit': 'cb4e7a5643f7d2dd40e694bcbd28c4b89b185e86' }
  Plug 'pangloss/vim-javascript', { 'commit': 'ee445807a71ee6933cd6cbcd74940bc288815793' }
  Plug 'mxw/vim-jsx', { 'commit': 'ffc0bfd9da15d0fce02d117b843f718160f7ad27' }
  Plug 'mattn/emmet-vim', { 'commit': 'd698f1658770ca5fa58c87e80421c8d65bbe9065' }
  Plug 'ap/vim-css-color', { 'commit': '8a84356d5319cad3da2835bd5fbc6318500f31ce' }
  Plug 'shumphrey/fugitive-gitlab.vim', { 'commit': '43a13dbbc9aae85338877329ed28c9e4d8488db1' }
  Plug 'jiangmiao/auto-pairs', { 'commit': '39f06b873a8449af8ff6a3eee716d3da14d63a76' }
  Plug 'vim-ruby/vim-ruby', { 'commit': '1aa8f0cd0411c093d81f4139d151f93808e53966' }
  let l:fzf_path = trim(system('type -p fzf'))
  if exists(l:fzf_path)
    Plug l:fzf_path
  endif
  Plug 'junegunn/fzf.vim', { 'commit': '359a80e3a34aacbd5257713b6a88aa085337166f' }
  Plug 'vim-airline/vim-airline', { 'commit': 'c213f2ac44292a6c5548872e63acb0648cc07a9a' }
  Plug 'tpope/vim-rhubarb', { 'commit': 'c509c7eedeea641f5b0bdae708581ff610fbff5b' }
  Plug 'vim-scripts/MPage', { 'commit': 'c7915d434d66d51de6f7bb805f353946fd08a5de' }
  Plug 'dart-lang/dart-vim-plugin', { 'commit': '1dca4e12299e26bf4277992fd9b8b22bcc2f4e56' }
  Plug 'prabirshrestha/async.vim', { 'commit': '627a8c4092df24260d3dc2104bc1d944c78f91ca' }
  Plug 'prabirshrestha/vim-lsp', { 'commit': '094a49dccd2d92a57d754bcfaeb5f61b1ead70f4' }
  Plug 'keith/swift.vim', { 'commit': '245e5f7aae6f1bc96849a0a01a58cb81cf56e721' }
  Plug 'prabirshrestha/asyncomplete.vim', { 'commit': 'db3ab51ef6d42ac410afaea53fc0513afd0d5e25' }
  Plug 'prabirshrestha/asyncomplete-lsp.vim', { 'commit': '9e7b2492578dca86ed12b6352cb56d9fc8ac9a6e' }
  " deoplete needs following two
  Plug 'roxma/nvim-yarp', { 'commit': '83c6f4e61aa73e2a53796ea6690fb7e5e64db50a' }
  Plug 'roxma/vim-hug-neovim-rpc', { 'commit': '701ecbb0a1f904c0b44c6beaafef35e1de998a94' }
  Plug 'Shougo/deoplete.nvim', { 'commit': '840c46aed8033efe19c7a5a809713c809b4a6bb5',
        \'do': 'pip3 show pynvim 2>/dev/null 1>&2 \|\| pip3 install --user --upgrade pynvim' }
  Plug 'prabirshrestha/asyncomplete-tags.vim', { 'commit': 'eef50f9630db9a772204af13baa997c176ab1a4e' }
endfunction

function! EndPlug()
  call plug#end()
  call s:load_custom_color_scheme()
endfunction
" }}}


" config for current environment {{{
let s:ncpucores = str2nr(system('getconf _NPROCESSORS_ONLN 2>/dev/null || sysctl -n hw.ncpu | sed "s/[^0-9]//g"'))
" 三种clang安装方式，按照binary，brew，ycm的顺序解析
let s:brew_clangd = trim(system('type brew 2>/dev/null 1>&2 && brew --prefix || echo /dev/null')) . '/opt/llvm/bin/clangd'
" 需要把二进制的llvm套件安装在~/usr
" FIXME: customize this?
let s:binary_clangd = expand('~/usr/bin/clangd')

" set this to one of three (brew|binary|ycm) to specify version of clang to use
let s:specified_clang = ''
let s:resolved_clangd = ''
let s:resolved_resource_dir = trim(system('xcrun clang -print-resource-dir'))

" 可以通过环境变量选择clang版本
if exists('$VIM_SPECIFIED_CLANG')
  let s:specified_clang = $VIM_SPECIFIED_CLANG
endif

if index(['', 'binary'], s:specified_clang) >= 0 && filereadable(s:binary_clangd)
  let s:resolved_clangd = s:binary_clangd
  let s:resolved_clang = expand('~/usr/bin/clang')
elseif index(['', 'brew'], s:specified_clang) >= 0 && filereadable(s:brew_clangd)
  let s:resolved_clangd = s:brew_clangd
  let s:resolved_clang = '/usr/local/opt/llvm/bin/clang'
elseif index(['', 'ycm'], s:specified_clang) >= 0
  let s:locate_ycm_clang_script = s:this_dir . '/bin/locate_ycm_clang.vim'
  :execute 'source ' . s:locate_ycm_clang_script
  let s:ycm_clangd = WS_get_ycm_clangd()
  if filereadable(s:ycm_clangd)
    let s:resolved_clangd = s:ycm_clangd
  endif
endif

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
set nowrapscan
set wildmenu

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
set foldlevelstart=4
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


" 配置ycm {{{
if $VIRTUAL_ENV != ''
  let g:python3_host_prog = $VIRTUAL_ENV . '/bin/python3'
  let g:ycm_python_interpreter_path = $VIRTUAL_ENV . '/bin/python3'
endif

function! s:MyYCMTheme()
  highlight YcmErrorSection ctermbg=DarkRed
  highlight YcmErrorSign ctermbg=DarkRed
endfunction

noremap <leader>ja :YcmCompleter GoTo<CR>
noremap <leader>jd :YcmCompleter GoToDefinition<CR>
noremap <leader>jr :YcmCompleter GoToReferences<CR>
noremap <leader>ef :YcmShowDetailedDiagnostic<CR>
noremap <leader>ycmdbg :YcmDebugInfo<CR>
noremap <leader>ycmrst :YcmRestartServer<CR>
let g:ycm_clangd_args = s:CLANGD_OPTIONS
" Let clangd fully control code completion
let g:ycm_clangd_uses_ycmd_caching = 0
" Use installed clangd, not YCM-bundled clangd which doesn't get updates.
let g:ycm_clangd_binary_path = s:resolved_clangd
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_filetype_blacklist = {
      \ 'swift': 1
      \ }
" }}}


" 配置ale {{{
nnoremap <leader>] :ALEGoToDefinition<CR>
nnoremap <leader>\ :ALEGoToDefinitionInVSplit<CR>
nnoremap <leader>rf :ALEFindReferences<CR>
nnoremap <leader>hv :ALEHover<CR>
nnoremap <leader>fsm :ALESymbolSearch <cword><CR>
" ycm semantic completion does not quite work, so i'm gonna: use ale to do lint and
" semantic completion, use ycm to do tag based completion
let g:ale_completion_enabled = 1
let g:ale_set_highlights = 0 " Disable highligting
" let g:ale_set_signs = 0
let g:ale_linters = {
      \ 'javascript': ['eslint', 'tsserver'],
      \ 'cpp': ['clangd'],
      \ 'objc': ['clangd'],
      \ 'objcpp': ['clangd'],
      \ 'dart': ['language_server'],
      \ 'swift': ['swiftlint'],
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
nmap <leader>gd <Plug>(coc-definition)
nmap <leader>gy <Plug>(coc-type-definition)
nmap <leader>gi <Plug>(coc-implementation)
nmap <leader>gr <Plug>(coc-references)
set statusline^=%{coc#status()}
" }}}


" vim-lsp {{{
let g:lsp_log_verbose = 1
let g:lsp_log_file = expand('~/.vim-lsp.log')
if exists('$SOURCEKIT_LSP_PATH')
  let s:ws_lsp_default_ios_sdk_path=trim(system('get_default_ios_sdk_path'))
  let s:ws_lsp_swift_host_triplet=trim(system('get_swift_host_triplet'))
  autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'sourcekit-lsp',
        \ 'cmd': {server_info->[
        \   $SOURCEKIT_LSP_PATH,
        \   '-Xswiftc', '-sdk',
        \   '-Xswiftc', s:ws_lsp_default_ios_sdk_path,
        \   '-Xswiftc', '-target',
        \   '-Xswiftc', s:ws_lsp_swift_host_triplet]
        \ },
        \ 'whitelist': ['swift'],
        \ })
endif
" }}}


" 配置SirVer/ultisnips {{{
" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<C-l>"
let g:UltiSnipsJumpForwardTrigger = "<C-j>"
let g:UltiSnipsJumpBackwardTrigger = "<C-k>"
" }}}


" Config indentLine {{{
let g:indentLine_char_list = ['|', '¦', '┆',  '↓', '↑', '†', '·', '‖', 'ˇ', '┊']
nnoremap <leader>ig :IndentLinesToggle<CR>
let g:indentLine_concealcursor = 'c'
" }}}


" 自动命令 ---------------------- {{{
" 该函数执行的时候vimrc可能还没有执行过，此时延时递归，否则立即执行
function! WSWrapYcmRestartServer(_)
  if v:vim_did_enter
    :silent YcmRestartServer
  else
    call timer_start(1000, 'WSWrapYcmRestartServer')
  endif
endfunction

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
  autocmd FileType vim setlocal foldmethod=marker
  " 打开文件时光标自动定位到上次退出时的位置
  autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit'
        \ |   exe "normal! g`\""
        \ | endif
  autocmd BufEnter COMMIT_EDITMSG let g:ycm_collect_identifiers_from_comments_and_strings = 1 | :silent call WSWrapYcmRestartServer(0)
  autocmd BufLeave COMMIT_EDITMSG let g:ycm_collect_identifiers_from_comments_and_strings = 0 | :silent call WSWrapYcmRestartServer(0)
  autocmd FileType json syntax match Comment +\/\/.\+$+
  autocmd FileType * :silent call WSTurnOnOrOffDeoplete()
augroup END
" }}}


" emmet-vim {{{
let g:user_emmet_install_global = 0
let g:user_emmet_settings = {
      \  'javascript.jsx' : {
      \      'extends' : 'jsx',
      \  },
      \}
autocmd mygroup FileType html,css,javascript,typescript,jsx,xml EmmetInstall
" }}}


" 配置fugitive-gitlab {{{
let g:fugitive_gitlab_domains = []
" }}}


" 配置tagbar {{{
let g:tagbar_autoclose = 1
noremap <silent> <F8> :TagbarToggle<CR>
" }}}


" 配置fzf {{{
" 环境变量
let $FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow ' . g:WS_RIPGREP_GLOB
let g:fzf_buffers_jump = 1
nnoremap <silent> <C-p>p :Files<CR>
nnoremap <silent> <C-p>b :Buffers<CR>
nnoremap <silent> <C-p>l :Lines<CR>
" }}}


" {{{ colorscheme
function! s:load_custom_color_scheme()
  " 依赖plugin的初始化
  set background=dark
  colorscheme gruvbox
  call s:MyYCMTheme()
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


" {{{
" let g:LanguageClient_serverCommands = {
"       \ 'rust': ['rustup', 'run', 'stable', 'rls'],
"       \ 'objc': ['/Users/ws2356/.vim/plugged/YouCompleteMe/third_party/ycmd/third_party/clangd/output/bin/clangd', '-log=error', '-pretty', '-limit-results=100', '-j=12', '-pch-storage=disk', '-header-insertion-decorators=0', '-resource-dir=/Users/ws2356/.vim/plugged/YouCompleteMe/third_party/ycmd/third_party/clang/lib/clang/8.0.0'],
"       \ }
" nnoremap <silent> <leader>K :call LanguageClient#textDocument_hover()<CR>
" nnoremap <silent> <leader>gd :call LanguageClient#textDocument_definition()<CR>
" nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
" set completefunc=LanguageClient#complete
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
" call WS_unplug('majutsushi/tagbar')
call EndPlug()
