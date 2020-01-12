#! /usr/bin/env bash
# 不知道为啥，不能从vim ex命令直接执行，几个函数不存在，但是.bash_profile确实执行过，因为有的环境变量只有它会导出
# 绕过的办法暂时不直接执行swift build，而是写出到一个sh脚本，用户手工执行脚本进行编译
set -e

output_file="build.sh"
if [ -e "$output_file" ] ; then
  exit 1
fi

>"$output_file" cat <<'EOF'
#! /usr/bin/env bash

swift build \
  -Xswiftc -sdk -Xswiftc "$(get_default_ios_sdk_path)" \
  -Xswiftc -target -Xswiftc "$(get_swift_host_triplet)"
EOF

chmod +x "$output_file"
