" 文件路径操作 {{{
function! WS_get_repo_root()
  let s:cur_dir = expand('%:p:h')
  if s:cur_dir == ''
    let s:cur_dir = getcwd()
  endif

  while 1
    let s:git_dir = fnamemodify(s:cur_dir, ':s;\v/?$;/.git;')
    if isdirectory(s:git_dir) || filereadable(s:git_dir)
      return s:cur_dir
    endif
    let s:cur_dir = fnamemodify(s:cur_dir, ':s;\v/[^/]+/?$;/;')
    if s:cur_dir == '/' || s:cur_dir == ''
      return ''
    endif
  endwhile
endfunction

function! s:get_top_dir(path)
  let s:ret = fnamemodify(a:path, ':s;\v^(/[^/]*).*$;\1;')
  return s:ret
endfunction

function! s:trim_top_dir(path)
  return fnamemodify(a:path, ':s;\v^/[^/]*/?(.*)$;/\1;')
endfunction

function! WS_relative_to(base_, path_)
  let s:base = a:base_
  let s:path = a:path_
  let s:base = fnamemodify(s:base, ':p')
  let s:path = fnamemodify(s:path, ':p')
  if s:base == s:path
    return '.'
  endif
  while s:get_top_dir(s:base) == s:get_top_dir(s:path)
        \ && s:get_top_dir(s:path) != '/'
    let s:base = s:trim_top_dir(s:base)
    let s:path = s:trim_top_dir(s:path)
  endwhile
  while s:base =~ '[^/.]'
    let s:base = fnamemodify(s:base, ':s;\v/[^/]*[^/.]+[^/]*;/..;g')
  endwhile
  let s:base = fnamemodify(s:base, ':s;\v^/?;;')
  let s:base = fnamemodify(s:base, ':s;\v/?$;;')
  if s:base == '/' || s:base == ''
    let s:base = '.'
  endif
  return s:base . fnamemodify(s:path, ':s;\v^/?(.*)$;/\1;')
endfunction
" }}}


