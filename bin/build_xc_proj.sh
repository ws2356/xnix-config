#!/bin/bash
set -e

# 从argument或stdin读取参数
designated_workspace=${1:-}
designated_scheme=${2:-}
if [ -z "$designated_workspace" ] && [ -z "$designated_scheme" ] ; then
  read -t 1 -r designated_workspace designated_scheme || true
fi

# 去掉/便于比较
designated_workspace=${designated_workspace%/}

if [ -n "$designated_workspace" ] ; then
  designated_workspace=$(basename "$designated_workspace")
fi

echo "designated_workspace: $designated_workspace, designated_scheme: $designated_scheme"

declare -a workspace_files

IFS_=$IFS
IFS=$'\n' workspace_files=(`find . -maxdepth 1 -name '*.xcworkspace'`)
IFS=$IFS_

clean_scheme() {
  local workspace_file=${1%/}
  local workspace_filename
  workspace_filename=$(basename "$workspace_file")
  local scheme=${2}
  echo "Cleaning workspace: $workspace_file scheme: $scheme"
  xcodebuild clean -workspace "$workspace_file" -scheme "$scheme" || true
}

build_scheme() {
  local workspace_file=${1%/}
  local workspace_filename
  workspace_filename=$(basename "$workspace_file")
  local scheme=${2}
  echo "Building workspace: $workspace_file scheme: $scheme"
  xcodebuild -workspace "$workspace_file" -scheme "$scheme" | \
    xcpretty --report json-compilation-database  --output "compile_commands_${scheme}.json"
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
    xcodebuild clean -workspace "$workspace_file" -scheme "$scheme" || true
    clean_scheme "$workspace_file" "$scheme"
  done

  for scheme in "${schemes[@]}"; do
    build_scheme "$workspace_file" "$scheme"
  done
}

for workspace_file in "${workspace_files[@]}"; do
  build_workspace "$workspace_file"
done
