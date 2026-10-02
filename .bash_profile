resolve_link_recur() {
  local the_link=$1
  local ls_res=
  local link_target=
  while [ -h "$the_link" ] ; do
    ls_res="$(ls -ld "$the_link")"
    link_target=$(expr "$ls_res" : '.*-> \(.*\)$')
    if [ "$(echo "$link_target" | cut -c 1)" = "/" ] ; then
      the_link="$link_target"
    else
      the_link="$(dirname "$the_link")/$link_target"
    fi
  done
  printf '%s' "$the_link"
}

get_containing_dir() {
  local this_file=$1
  if ! [[ "$this_file" =~ ^/ ]] ; then
    this_file="$(pwd)/$this_file"
  fi
  this_file="$(resolve_link_recur "$this_file")"
  this_dir="$(dirname "$this_file")"
  echo "$this_dir"
}

this_dir="$(get_containing_dir "${BASH_SOURCE[0]}")"

# export HOMEBREW_NO_AUTO_UPDATE=1
HOMEBREW_AUTO_UPDATE_SECS=7200

path_append() {
  for p in "$@"; do
    case ":$PATH:" in
      *":${p}:"*) continue ;;
    esac
    export PATH="${PATH:-''}${PATH:+:}${p}"
  done
}

path_prepend() {
  for p in "$@"; do
    case ":$PATH:" in
      *":${p}:"*) continue ;;
    esac
    export PATH="${p}${PATH:+:}${PATH:-''}"
  done
}

test -f ${HOME}/secrets/env.sh && \. $_

path_append "${HOME}/bin"

# config rbenv
if type -p rbenv >/dev/null 2>&1 ; then
  path_prepend "${HOME}/.rbenv/shims"
  export RBENV_SHELL=bash
  eval "$(rbenv init -)" || echo "rbenv not install correctly."
  rbenv() {
    local command
    command="$1"
    if [ "$#" -gt 0 ]; then
      shift
    fi

    case "$command" in
    rehash|shell)
      eval "$(rbenv "sh-$command" "$@")";;
    *)
      command rbenv "$command" "$@";;
    esac
  }
fi

\. "$this_dir/set_up_java.sh"
\. "$this_dir/set_up_android.sh"

test ~/.bash_profile.local && \. "$_"

# shellcheck source=/dev/null
test -f "${HOME}/.bashrc" && \. "$_"