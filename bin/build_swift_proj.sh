#! /usr/bin/env bash
# 不知道为啥，不能从vim ex命令直接执行，几个函数不存在，但是.bash_profile确实执行过，因为有的环境变量只有它会导出
# 绕过的办法暂时不直接执行swift build，而是写出到一个sh脚本，用户手工执行脚本进行编译
set -e

output_file="swiftw"
if ! [ -e "$output_file" ] ; then
>>"$output_file" cat <<'EOF'
#! /usr/bin/env bash

xcrun --toolchain swift swift "$@"

# swift build \
#   -Xswiftc -sdk -Xswiftc "$(get_default_ios_sdk_path)" \
#   -Xswiftc -target -Xswiftc "$(get_swift_host_triplet)"
EOF
chmod +x "$output_file"
else
  echom "swiftw already exists"
fi

if ! [ -e ".vimrc" ] ; then
output_file2='.vimrc'
>>"$output_file2" cat <<'EOF'
let g:ws_sourcekit_lsp_path = trim(system('xcrun --toolchain swift --find sourcekit-lsp'))
let g:ws_swift_sdk_path=trim(system('xcrun --toolchain swift -show-sdk-path'))
let g:ws_swift_triplet=trim(system('guess_swift_host_triplet || printf "x86_64-apple-macosx10.15"'))
call WS_start_sourcekit_lsp()
EOF
else
  echom ".vimrc already exists"
fi
