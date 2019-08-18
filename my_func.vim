" 封装的通用函数 {{{
function! Add_project_vim_dir()
  let l:proj_root = expand('%:p:h')
  let l:proj_runtime = l:proj_root . '/.vim'
  if isdirectory(l:proj_runtime)
    let &runtimepath = &runtimepath . ',' . l:proj_runtime
  endif
endfunction
" 代码搬运自https://stackoverflow.com/questions/1533565/how-to-get-visually-selected-text-in-vimscript/6271254#6271254
function! WS_get_visual_selection()
  " Why is this not a built-in Vim script function?!
  let [line_start, column_start] = getpos("'<")[1:2]
  let [line_end, column_end] = getpos("'>")[1:2]
  let lines = getline(line_start, line_end)
  if len(lines) == 0
    return ''
  endif
  let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
  let lines[0] = lines[0][column_start - 1:]
  return join(lines, "\n")
endfunction
" }}}
