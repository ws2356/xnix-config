" call bin/build_ios_proj.sh to build current ios proj, creating compile db {{{
let s:build_ios_proj_cmd = expand('<sfile>:p:h') . '/bin/build_ios_proj.sh'
function! WS_BuildIOSProj(...)
  execute ':Spawn! -wait=error -dir=. ' .
        \ shellescape(s:build_ios_proj_cmd) . ' ' . join(a:000)
endfunction
command! -complete=file -nargs=* BuildIOSProj call WS_BuildIOSProj(<f-args>) 
" }}}
