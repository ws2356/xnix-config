#!/bin/bash
# 功能：遍历xc工程里的全部(workspace, scheme)，并编译，输出compile_commands.json
# 用于结合clangd(language server)提供语义跳转等功能
set -e

this_script=$(which "$0")
if echo "$this_script" | grep -E '^/' >/dev/null ; then
  this_dir=$(dirname "$this_script")
else
  this_dir=$(dirname "$(pwd)/${this_script}")
fi
# TODO: wansong 2019-11-16 solve this?
# 暂时不太好用，因为使用module语法的代码或使用index store编译器feature的工程
# 生成的compile_commands.json不好用

# 从argument或stdin读取参数
# 推荐传入完整参数(workspace, scheme, target)
# 对指定的(workspace, scheme, target)有特殊处理：
# 1. 当有第四个参数且非0时，仅clean & build指定的(workspace, scheme, target)
# 2. 针对指定的(workspace, scheme, target)在处理过程会编辑对应的target的编译选项，以绕过上面todo里提到的问题
designated_workspace=${1-}
designated_scheme=${2:-}
designated_target=${3:-}
build_designated_only=${4:-0}
if [ -z "$designated_workspace" ] && [ -z "$designated_scheme" ] \
  && [ -z "$designated_target" ] ; then
  read -t 1 -r designated_workspace designated_scheme designated_target || true
fi

# 去掉/便于比较
designated_workspace=${designated_workspace%/}
# 获取指定workspace的basename（不支持多个workspace同名）
if [ -n "$designated_workspace" ] ; then
  designated_workspace=$(basename "$designated_workspace")
fi

echo "designated_workspace: $designated_workspace, \
designated_scheme: $designated_scheme, designated_target: $designated_target"

declare -a workspace_files
IFS_=$IFS
IFS=$'\n' workspace_files=(`find . -maxdepth 1 -name '*.xcworkspace'`)
IFS=$IFS_

clean_scheme() {
  local workspace_file=${1%/}
  local workspace_filename
  workspace_filename=$(basename "$workspace_file")
  local scheme=${2}
  if [ "$build_designated_only" -ne 0 ] && \
    ( [ "$workspace_filename" != "$designated_workspace" ] || [ "$scheme" != "$designated_scheme" ] ) ; then
    return
  fi
  echo "Cleaning workspace: $workspace_file scheme: $scheme"
  xcodebuild clean -workspace "$workspace_file" -scheme "$scheme" || true
}

patch_project() {
  local workspace_file=$1
  local scheme=$2
  local target=$3
  project_path=$(xcodebuild -workspace "$workspace_file" \
    -scheme "$scheme" -showBuildSettings -json |\
    jq -r '.[] | select(.target == '"\"${target}\""') | .buildSettings.PROJECT_FILE_PATH' |\
    sed -E 's/^[[:space:]]*(.+)/\1/' |\
    sed -E 's/(.+)[[:space:]]*$/\1/'
  )
  if [ -z "$project_path" ] ; then
    return 0
  fi
  "${this_dir}/modify_target.rb" "$project_path" "$target"
}

build_scheme() {
  # 目前的问题：只有关闭这两个编译选项CLANG_ENABLE_MODULES=NO COMPILER_INDEX_STORE_ENABLE=NO时生成的
  # compile_commands.json才能被ycm/clangd正确使用
  # 然而有些工程使用了module的语法，关闭之后无法编译...
  local workspace_file=${1%/}
  local workspace_filename
  workspace_filename=$(basename "$workspace_file")
  local scheme=${2}
  if [ "$build_designated_only" -ne 0 ] && \
    ( [ "$workspace_filename" != "$designated_workspace" ] || [ "$scheme" != "$designated_scheme" ] ) ; then
    return
  fi

  if [ "$workspace_filename" = "$designated_workspace" ] && [ "$scheme" = "$designated_scheme" ] ; then
    patch_project "$workspace_file" "$scheme" "$designated_target"
  fi

  echo "Building workspace: $workspace_file scheme: $scheme"
  xcodebuild -workspace "$workspace_file" -scheme "$scheme" | \
    xcpretty --report json-compilation-database  --output "compile_commands_${scheme}.json" || true
  # 如果是指定的workspace，scheme则创建软连接
  if [ "$workspace_filename" = "$designated_workspace" ] && [ "$scheme" = "$designated_scheme" ] ; then
    test -f "compile_commands.json" && rm "$_"
    ln -s "compile_commands_${scheme}.json" "compile_commands.json"
  fi
}

build_workspace() {
  local workspace_file=${1%/}
  IFS_=$IFS
  IFS=$'\n' schemes=(`xcodebuild -workspace "$workspace_file" -list -json | jq -r '.workspace.schemes | .[]'`)
  IFS=$IFS_

  for scheme in "${schemes[@]}"; do
    clean_scheme "$workspace_file" "$scheme"
  done

  for scheme in "${schemes[@]}"; do
    build_scheme "$workspace_file" "$scheme"
  done
}

ensure_safe() {
  if git status --porcelain | grep -E '^[[:space:]]*M' 2>&1 >/dev/null ; then
    echo "git repo is not clean."
    exit 1
  fi
}

ensure_safe

for workspace_file in "${workspace_files[@]}"; do
  build_workspace "$workspace_file"
done

# not so dangerous after ensure_safe
git checkout .
