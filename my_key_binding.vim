" 文件
"
nnoremap <leader>zz :normal! ZZ<CR>
nnoremap <leader>qa :qa<CR>
nnoremap <leader>qq :q<CR>
nnoremap <leader>co :only<CR>
nnoremap <leader>ww :w<CR>
nnoremap <leader>wa :wa<CR>
nnoremap <leader>mks :call WS_gmks()<CR>
nnoremap <leader>rs :call WS_grs()<CR>
function! WS_gmks()
  let l:session_filename = WS_get_session_filename()
  if l:session_filename ==# ''
    return
  endif
  execute ':mksession! ' . l:session_filename
endfunction

function! WS_grs()
  let l:session_filename = WS_get_session_filename()
  if l:session_filename ==# ''
    return
  endif
  if !filereadable(l:session_filename)
    return
  endif
  execute ':source ' . l:session_filename
endfunction

function! WS_get_session_filename()
  let l:ref_name = trim(system('git rev-parse --abbrev-ref=strict @ 2>/dev/null'))
  if v:shell_error
    echo 'Failed to get git branch, abort.'
    return ''
  endif
  if toupper(l:ref_name) ==# 'HEAD'
    echo 'Not on any branch, abort.'
    return ''
  endif
  let l:ref_name_slug = tr(l:ref_name, ' /', '--')
  let l:session_filename = '.' .  l:ref_name_slug . '.vimsession'
  return l:session_filename
endfunction


" 快速打开文件
nnoremap <leader>ev :vsplit $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>
nnoremap <leader>br :browse filter /\v/ oldfiles<S-Left><Left><Left>
nnoremap <leader>of :!open -a 'Google Chrome' '<C-r>=expand('%:p')<CR>'<CR> \| <CR>


" 窗口
nnoremap <leader>ma 99<C-w>+
nnoremap <leader>mi 99<C-w>-
nnoremap <leader>hma 99<C-w>>
nnoremap <leader>hmi 99<C-w><
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
noremap <leader>sc :MPage 2<CR>


" tab
noremap <leader>tbn :tabnew<Space>
noremap <leader>tbs :tabs<CR>
noremap <leader>tbo :tabonly<CR>
noremap <leader>ts :tab split<CR>


" Source/Header文件切换 {{{
let s:c_source_ext = ['cc', 'c', 'cpp', 'm']
let s:c_header_ext = ['h', 'hpp']
function! ToggleSourceHeader()
  let l:ext = tolower(expand('%:e'))
  let l:target_ext = []
  if index(s:c_source_ext, l:ext) >= 0
    let l:target_ext = s:c_header_ext
  elseif index(s:c_header_ext, l:ext) >= 0
    let l:target_ext = s:c_source_ext
  else
    return
  endif
  for l:ext2 in l:target_ext
    let l:file_grep = '%:s;' . l:ext . '$;' . l:ext2 . ';'
    let l:alt_file = expand(l:file_grep)
    if filereadable(l:alt_file)
      silent execute ':edit ' . l:alt_file
      return
    endif
  endfor
  " alt_file not exist, creating one
  let l:file_grep = '%:s;' . l:ext . '$;' . l:target_ext[0] . ';'
  let l:alt_file = expand(l:file_grep)
  silent execute ':edit ' . l:alt_file
endfunction
nnoremap <leader>al :call ToggleSourceHeader()<CR>
" }}}


" 跳转
nnoremap <leader>ju :jumps<CR>


" lsp {{{
nnoremap <leader>ne :throw 'reserved for lsp: next error'<CR>
nnoremap <leader>nw :throw 'reserved for lsp: next warning'<CR>
nnoremap <leader>pe :throw 'reserved for lsp: previous error'<CR>
nnoremap <leader>pw :throw 'reserved for lsp: previous warning'<CR>
nnoremap <leader>ae :throw 'reserved for lsp: list all diagnostic'<CR>
" }}}


" 宏
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>
function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction


" 命令行 {{{
nnoremap <leader>; :
nnoremap <leader>sh :!
nnoremap <leader>55 :%
nnoremap <leader>sw :Spawn! -wait=always -dir=.
nnoremap <leader>st :Spawn! -wait=error -dir=.
nnoremap <leader>msg :messages<CR>
" 快速输入
cnoremap <leader>5p <C-r>=expand('%:p')<CR>
cnoremap <leader>5h <C-r>=expand('%:h')<CR>
cnoremap <leader>5t <C-r>=expand('%:t')<CR>
cnoremap <leader>33 <C-r>=expand('#')<CR>
cnoremap <leader>cf <C-r>=expand('<cfile>')<CR>
cnoremap <leader>cw <C-r>=expand('<cword>')<CR>
cnoremap <leader>cW <C-r>=expand('<cWORD>')<CR>
cnoremap <leader>wd <C-r>=getcwd()<CR>
cnoremap <leader>wh \<\><Left><Left>
" }}}


" 寄存器
" 选择寄存器
nnoremap <expr> \ '"' . nr2char(getchar())
vnoremap <expr> \ '"' . nr2char(getchar())
nnoremap <expr> \= '"+'
vnoremap <expr> \= '"+'
nnoremap <expr> \2 '"@'
vnoremap <expr> \2 '"@'
nnoremap <expr> \; '":'
vnoremap <expr> \; '":'


" 剪切板
" y后面可跟p, h, t, e, r等，用于展开相关路径
nnoremap <expr> <leader>y ':let @+ = expand("%:' . nr2char(getchar()) . '")<CR>'
nnoremap <leader>ywd :let @+ = getcwd()<CR>


" 文件内导航 {{{
" 查找
nnoremap <leader>nh :let @/ = ""<CR>
vnoremap // y/<C-R>"

" 向前/后跳转至{/}符号
map <Up> gk
map <Down> gj
command! -nargs=1 CMDGoNextFold call GoNextFold(<args>)
command! -nargs=1 CMDGoPrevFold call GoPrevFold(<args>)
nnoremap <leader>zj :call :<C-U>CMDGoNextFold(v:count1)<CR>
nnoremap <leader>zk :call :<C-U>CMDGoPrevFold(v:count1)<CR>
function! GoNextFold(cnt)
  if a:cnt ==# 0
    return
  endif
  let l:initial_line = line('.')
  let l:lnum = foldclosedend(l:initial_line) + 1
  if l:lnum ==# 0
    let l:lnum = l:initial_line
  endif
  let l:end_line = line('$')
  while foldclosed(l:lnum) ==# -1 && l:lnum <=# l:end_line
    let l:lnum += 1
  endwhile
  if l:lnum ># l:end_line
    return
  endif
  execute 'normal! ' . l:lnum . 'G'
  call GoNextFold(a:cnt - 1)
endfunction
function! GoPrevFold(cnt)
  if a:cnt ==# 0
    return
  endif
  let l:initial_line = line('.')
  let l:lnum = foldclosed(l:initial_line) - 1
  if l:lnum ==# -2
    let l:lnum = l:initial_line
  endif
  let l:end_line = 1
  while foldclosed(l:lnum) ==# -1 && l:lnum >=# l:end_line
    let l:lnum -= 1
  endwhile
  if l:lnum <# l:end_line
    return
  endif
  execute 'normal! ' . l:lnum . 'G'
  call GoPrevFold(a:cnt - 1)
endfunction

" 编辑 {{{
" 删除当前行末尾空白符
nnoremap <leader>dsp :.s/\v\s+$//e<CR>
" 删除选中行末尾空白符
vnoremap <leader>dsp :s/\v\s+$//e<CR>
" 改变选中行的第一个非空白符之前的空白字符，替换tab为softtabstop个空格
command -range=% WSChangeTab
      \ <line1>,<line2>
      \ g/\t/s/\v^([\s\t]+)(.+)$/\=substitute(
      \ submatch(1),'\t',repeat(' ',&softtabstop),'g').submatch(2)
vnoremap <leader>ct :WSChangeTab<CR>
nnoremap <leader>ct :WSChangeTab<CR>
" 倒转选中行
" vnoremap <leader>rev :<C-u>'<+1,'>g/^/move <C-r>=line("'<")-1<CR><CR>
nnoremap <leader>dl cc<Esc>
nnoremap <leader>p :set paste<CR>
nnoremap <leader>np :set nopaste<CR>
" 快速保存
inoremap <Esc><Esc> <Esc>:w<CR>
" 选中刚刚改变的内容
nnoremap gb :normal `[v`]<CR>
nnoremap <leader>fmt :normal '[=']<CR>
nnoremap <leader>ss :%s/
nnoremap <leader>ss :%s/
inoremap <C-b>wd <C-r>=getcwd()<CR>
inoremap <C-b>fp <C-r>=expand('%:p')<CR>
inoremap <C-b>fh <C-r>=expand('%:h')<CR>
inoremap <C-b>ft <C-r>=expand('%:t')<CR>
inoremap <C-b>f5 <C-r>=expand('%')<CR>
inoremap <C-b>f3 <C-r>=expand('#')<CR>
" 绕过emmet不能完整展开自动补全的表达式的问题
" deprecate: coc基于lsp提供的补全似乎够用
imap <C-y>\ <Esc>a<C-y>,
" inoremap <expr> <C-b>r repeat(nr2char(getchar()), 10)
function! AppendModeline()
  let l:modeline = printf("vim: set sts=%d ts=%d sw=%d tw=%d %set :",
        \ &tabstop, &tabstop, &shiftwidth, &textwidth, &expandtab ? '' : 'no')
  let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
  execute ':0s@^@' . l:modeline . '\r@'
endfunction
nnoremap <silent> <Leader>ml :call AppendModeline()<CR>

inoremap <S-TAB> <C-X><C-O>
" }}}

" 搜索 {{{
command! -nargs=+ -complete=file GRR call GrepSourceCodeRaw(<f-args>)
command! -complete=file GRV call VGrepSourceCode()
" 根据正则表达式匹配，其他的是匹配原始字符
command! -nargs=+ -complete=file GRE call EGrepSourceCode(<f-args>)
nnoremap <leader>ff :GRR<Space><Space>.<Left><Left>
nnoremap <leader>fi :GRR<Space>-i<Space><Space>.<Left><Left>
nnoremap <leader>fc :GRR<Space><C-r>=expand("<cword>")<CR><Space>.<Left><Left>
nnoremap <leader>fC :GRR<Space><C-r>=
      \ shellescape(expand("<cWORD>"))<CR><Space>.<Left><Left>
vnoremap <leader>fv :<C-u>GRV
noremap <leader>fe :GRE<Space><C-r>=expand("<cword>")<CR><Space>.<Left><Left>
function! CGrepSourceCode(...)
  let l:word = expand('<cword>')
  let l:args = a:000[0:]
  let l:prepended = reverse(add(reverse(l:args), l:word))
  call call(function('GrepSourceCodeRaw'), l:prepended)
endfunction
function! VGrepSourceCode()
  let l:word = WS_get_visual_selection()
  call GrepSourceCodeRaw(shellescape(l:word), '.')
endfunction
" 文字匹配
function! GrepSourceCodeRaw(...)
  execute 'grep ' . ' --fixed-strings ' . join(a:000) . ' '
endfunction
" 正则表达式匹配
function! EGrepSourceCode(...)
  execute 'grep ' . ' -e ' . join(a:000) . ' '
endfunction
" location list
nnoremap <leader>cn :cn<CR>
nnoremap <leader>cp :cp<CR>
nnoremap <leader>cl :cl<CR>
nnoremap <leader>cc :cc<Space>
" }}}


" git
function! WSOpenUrl(url)
  let l:trimmed = trim(a:url)
  let l:fixed = l:trimmed
  if a:url =~ '^git@'
    let l:fixed = substitute(
          \ l:trimmed,
          \ '^git@\(.\+\):\(.\+\)$',
          \ {m -> 'http://' .  m[1] . '/' . m[2] },
          \ 'g')
  endif
  execute '!open -a "Google Chrome" ' . l:fixed
endfunction

command! -nargs=1 WSOpenUrl call WSOpenUrl(<f-args>)
nnoremap <leader>dg :diffget<CR>
nnoremap <leader>lnk yi':WSOpenUrl <C-r>0<CR>
nnoremap <leader>llnk yy:WSOpenUrl <C-r>0<CR>
nnoremap <leader>wlnk yy:WSOpenUrl <cWORD><CR>


" vim-fugitive {{{
nnoremap <leader>ge :Gedit<Space>
nnoremap <leader>gg :Git!<Space>
nnoremap <leader>gb :Gblame<CR>
noremap <leader>gbr :Gbrowse<CR>
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gvd :Gvdiff<CR>
nnoremap <leader>gdi :Gvdiff @<CR>
nnoremap <leader>gdf :Gvdiff :%<Left><Left>
nnoremap <leader>gdt :Git difftool<Space>
nnoremap <leader>gwr :Gwrite<CR>
nnoremap <leader>grd :Gread<CR>
nnoremap <leader>gll :Git ll<CR>
nnoremap <leader>glg :Git lg<CR>
nnoremap <leader>grm :Gremove<CR>
nnoremap <leader>gmv :Gmove<Space>
nnoremap <leader>gph :Gpush<Space>
nnoremap <leader>gpl :Gpull<Space>
nnoremap <leader>gfh :Gfetch<CR>
" }}}
