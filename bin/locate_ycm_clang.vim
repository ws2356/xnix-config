function! WS_get_ycm_dir()
  let l:plugin_dirs = split(&runtimepath, ',')
  let l:ycm_dir = ''
  for dd in plugin_dirs
    let l:parts = split(dd, '/')
    if l:parts[-1] ==# 'YouCompleteMe'
      let l:ycm_dir = dd
      break
    elseif isdirectory(dd . '/plugged/YouCompleteMe')
      let l:ycm_dir = dd . '/plugged/YouCompleteMe'
      break
    elseif isdirectory(dd . '/YouCompleteMe')
      let l:ycm_dir = dd . '/YouCompleteMe'
      break
    endif
  endfor
  let l:ycm_dir = fnamemodify(l:ycm_dir, ':s;\v/$;;')
  return l:ycm_dir
endfunction

function! WS_get_ycm_clang_resource_dir()
  let l:ycm_dir = WS_get_ycm_dir()
  let l:clang_resource_include_dir = system(
        \'find ' . l:ycm_dir .
        \' -type d -regex ".*/clang/lib/clang/[0-9\.][0-9\.]*/include" -print -quit'
        \)
  let l:ret = fnamemodify(trim(l:clang_resource_include_dir), ':s;\v/include$;;')
  return l:ret
endfunction

function! WS_get_ycm_clangd()
  let l:ycm_dir = WS_get_ycm_dir()
  let l:clang_resource_include_dir = system(
        \'find ' . l:ycm_dir .
        \' -type f -regex "^.*/bin/clangd" -print -quit'
        \)
  let l:ret = trim(l:clang_resource_include_dir)
  return l:ret
endfunction
