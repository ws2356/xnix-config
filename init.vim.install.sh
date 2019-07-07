#!/bin/bash
destdir="${HOME}/.config/nvim"
if [ ! -d "$destdir" ] ; then
  mkdir -p "$destdir"
fi

this_dir=$(which $0)
if ! echo "$this_dir" | grep -E '^/' >/dev/null ; then
  this_dir="$(pwd)/${this_dir}"
fi
this_dir=$(dirname "$this_dir")

ln -s "${this_dir}/init.vim" "$destdir"
