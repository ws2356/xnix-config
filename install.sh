#! /usr/bin/env bash
set -eu

this_file="$(type -p "${BASH_SOURCE[0]}")"
if ! [ -e "$this_file" ] ; then
  echo "Failed to resolve file."
  exit 1
fi
if ! [[ "$this_file" =~ ^/ ]] ; then
  this_file="$(pwd)/$this_file"
fi
while [ -h "$this_file" ] ; do
    ls_res="$(ls -ld "$this_file")"
    link_target=$(expr "$ls_res" : '.*-> \(.*\)$')
    if [[ "$link_target" =~ ^/ ]] ; then
      this_file="$link_target"
    else
      this_file="$(dirname "$this_file")/$link_target"
    fi
done
this_dir="$(dirname "$this_file")"


install_file() {
  local from_file=$1
  if ! [[ "$from_file" =~ ^/ ]] ; then
    from_file="$(pwd)/$from_file"
  fi
  local to_file=$2
  backup_file "$to_file"
  if ! ln -s "$from_file" "$to_file" ; then
    echo "Failed to create symbolic link from $from_file to ${to_file}: maybe parent dir not exist or no permission to do so"
  fi
}

backup_file() {
  local ff=$1
  if ! [ -e "$ff" ] ; then
    return 0
  fi

  local backup_ff=${ff}.bak
  if ! [ -f "$backup_ff" ] ; then
    mv "$ff" "$backup_ff"
    return 0
  fi

  local suffix=1
  while [ -f "${backup_ff}.${suffix}" ] ; do
    ((suffix++))
  done

  mv "$ff" "${backup_ff}.${suffix}"
}

install_file "${this_dir}/gitconfig" "$HOME/.gitconfig"
install_file "${this_dir}/coc_config.json" "$HOME/.vim/coc-settings.json" 
install_file "${this_dir}/.vimrc" "$HOME/.vimrc" 
install_file "${this_dir}/.xvimrc" "$HOME/.xvimrc" 
install_file "${this_dir}/.bashrc" "$HOME/.bashrc" 
install_file "${this_dir}/.bash_profile" "$HOME/.bash_profile" 
install_file "${this_dir}/tigrc" "$HOME/.tigrc" 
install_file "${this_dir}/ssh/config" "$HOME/.ssh/config" 

export -f install_file
"${this_dir}/bin/xcode_snippets_restore" 2>/dev/null | {
  IFS_="$IFS"
  export IFS=""
  while read -r -a ll ; do
    IFS="$IFS_" install_file "${ll[@]}"
  done
}
