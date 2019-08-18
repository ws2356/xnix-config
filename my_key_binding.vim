" 配置 vim-fugitive {{{
nnoremap <leader>ge :Gedit<CR>
nnoremap <leader>gb :Gblame<CR>
noremap <leader>gbr :Gbrowse<CR>
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>ga :Git add -p<CR>
nnoremap <leader>gc :Gcommit -v<CR>
nnoremap <leader>gcm :Gcommit --amend<CR>
nnoremap <leader>gp :Gpush<CR>
nnoremap <leader>gvd :Gvdiff<CR>
nnoremap <leader>gdi :Gvdiff @<CR>
nnoremap <leader>gdd :Gvdiff :%<Left><Left>
nnoremap <leader>gdt :Git difftool --cached<CR>
nnoremap <leader>gwr :Gwrite<CR>
nnoremap <leader>grd :Gread<CR>
nnoremap <leader>gll :Git ll<CR>
nnoremap <leader>glg :Git lg<CR>
nnoremap <leader>grm :Gremove<CR>
nnoremap <leader>gdel :Gdelete<CR>
nnoremap <leader>gmv :Gmove<Space>
nnoremap <leader>grmt :r ! git remote get-url origin<CR>
nnoremap <leader>gph :Gpush<Space>
nnoremap <leader>gpl :Gpull<Space>
nnoremap <leader>gfh :Gfetch<CR>
" }}}


" custom key bindings {{{
nnoremap <leader>msg :messages<CR>
nnoremap <leader>ev :vsplit $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>
nnoremap <leader>zz :normal! ZZ<CR>
nnoremap <leader>zs :normal! <C-z><CR>
nnoremap <leader>qa :qa<CR>
nnoremap <leader>qq :q<CR>
nnoremap <leader>co :only<CR>
nnoremap <leader>cl :close<CR>
nnoremap <leader>ww :w<CR>
nnoremap <leader>wa :wa<CR>
nnoremap <leader>wq :wq<CR>
nnoremap <leader>vs :vsp ~/
nnoremap <leader>ed :edit<Space>
nnoremap <leader>; :
nnoremap <leader>sh :!
nnoremap <leader>rr :r<Space>
nnoremap <leader>r1 :r!<Space>
nnoremap <leader>st :Spawn! -wait=always -dir=.
nnoremap <leader>dg :diffget<CR>
nnoremap <leader>ma 99<C-w>+
nnoremap <leader>mi 99<C-w>-
nnoremap <leader>hma 99<C-w>>
nnoremap <leader>hmi 99<C-w><
nnoremap <leader>2 @
" 把选中文字写入到指定文件
vnoremap <leader>wr :write<Space>
" 选用寄存器
nnoremap <leader>' "
" 直接选用+寄存器，用于存取系统剪切板
nnoremap <leader>= "+
vnoremap <leader>= "+

" vsplit打开光标所在文件
nnoremap <C-W><C-F> <C-W>vgf
nnoremap <C-W><C-^> :vs #<CR>
" location list导航
nnoremap <leader>cn :cn<CR>
nnoremap <leader>cp :cp<CR>
nnoremap <leader>cl :cl<CR>
nnoremap <leader>cc :cc<Space>
" 最近打开文件历史
nnoremap <leader>bro :browse filter /\v/ oldfiles<S-Left><Left><Left>

" 删除当前行末尾空白符
nnoremap <leader>dsp :.s/\s\+$//<CR>
" 删除选中行末尾空白符
vnoremap <leader>dsp :g/\s\+$/s/\s\+$//<CR>
" 改变选中行的第一个非空白符之前的空白字符，替换tab为softtabstop个空格
command -range=% WSChangeTab <line1>,<line2>g/\t/s/\v^([\s\t]+)(.+)$/\=substitute(submatch(1),'\t',repeat(' ',&softtabstop),'g').submatch(2)
vnoremap <leader>ct :WSChangeTab<CR>
nnoremap <leader>ct :WSChangeTab<CR>
" 倒转选中行
vnoremap <leader>rev :<C-u>'<+1,'>g/^/move <C-r>=line("'<")-1<CR><CR>

" 打开文件所在目录、打开文件、打开当前工作目录
nnoremap <leader>odf :!open <C-r>=expand('%:p:h')<CR><CR>
nnoremap <leader>odt :!open -a iTerm.app <C-r>=expand('%:p:h')<CR><CR>
nnoremap <leader>of :!open <C-r>=expand('%:p')<CR><C-b><S-Right>
nnoremap <leader>owd :!open -a iTerm.app .<CR>
nnoremap <leader>y5 :let @+ = expand('%')<CR>

nnoremap <leader>dl cc<Esc>

" 快速保存
inoremap <Esc><Esc> <Esc>:w<CR>
" 清除上次搜索记录
nnoremap <leader>nh :let @/ = ""<CR>
 
" 向前/后跳转至{/}符号
map [[ ?{<CR>w99[{
map ][ /}<CR>b99]}
map ]] j0[[%/{<CR>
map [] k$][%?}<CR>

nnoremap <leader>p :set paste<CR>
nnoremap <leader>np :set nopaste<CR>

command! -nargs=1 CMDGoNextFold call GoNextFold(<args>)
command! -nargs=1 CMDGoPrevFold call GoPrevFold(<args>)
nnoremap <leader>zj :call :<C-U>CMDGoNextFold(v:count1)<CR>
nnoremap <leader>zk :call :<C-U>CMDGoPrevFold(v:count1)<CR>

xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction

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

" 切换窗口
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
" tab操作
noremap <leader>tb :tabnew<Space>
noremap <leader>tbs :tabs<CR>
noremap <leader>tbo :tabonly<CR>
noremap <leader>tbl :tablast<CR>
noremap <leader>tbf :tabfirst<CR>

map <Up> gk
map <Down> gj
vnoremap // y/<C-R>"

nnoremap gb :normal `[v`]<CR>
nnoremap <leader>fmt :normal '[=']<CR>

nnoremap <leader>ju :jumps<CR>
nnoremap <leader>ss :%s/

nnoremap <leader>` g~

" 命令行模式快捷操作
cnoremap <leader>5h <C-r>=expand('%:h')<CR>
cnoremap <leader>5t <C-r>=expand('%:t')<CR>
cnoremap <leader>33 <C-r>=expand('#')<CR>
cnoremap <leader>cf <C-r>=expand('<cfile>')<CR>
cnoremap <leader>cw <C-r>=expand('<cword>')<CR>
cnoremap <leader>cW <C-r>=expand('<cWORD>')<CR>
cnoremap <leader>wd <C-r>=getcwd()<CR>
cnoremap <leader>wh \<\><Left><Left>
" }}}


" C系列语言Source/Header文件切换 {{{
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


" 搜索 {{{
command! -nargs=+ -complete=file GRR call GrepSourceCodeRaw(<f-args>)
command! -complete=file GRV call VGrepSourceCode()
" 根据正则表达式匹配，其他的是匹配原始字符
command! -nargs=+ -complete=file GRE call EGrepSourceCode(<f-args>)

nnoremap <leader>ff :GRR<Space><Space>.<Left><Left>
nnoremap <leader>fc :GRR<Space><C-r>=expand("<cword>")<CR><Space>.<Left><Left>
nnoremap <leader>fC :GRR<Space><C-r>=shellescape(expand("<cWORD>"))<CR><Space>.<Left><Left>
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
" }}}
