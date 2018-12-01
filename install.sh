#! /usr/bin/env bash

set -e

if which $0 | grep -e '^/'>/dev/null ;then
  this_file=$0
else
  this_file=`pwd`/$0
fi
this_dir=`dirname "$this_file"`


install_file() {
  local from_file=$1
  local to_file=$2
  backup_file "$to_file"
  ln -s "$from_file" "$to_file"
}

backup_file() {
  local ff=$1
  if [ ! -f "$ff" ] ;then
    return 0
  fi

  local backup_ff=${ff}.bak
  if [ ! -f "$backup_ff" ] ;then
    cp "$ff" "$backup_ff"
    return 0
  fi

  local suffix=1
  while [ -f "${backup_ff}.${suffix}" ] ;do
    ((suffix++))
  done

  cp "$ff" "${backup_ff}.${suffix}"
}


gitconfig_path=$HOME/.gitconfig

install_file "${this_dir}/gitconfig" "$gitconfig_path"

