export HOMEBREW_NO_AUTO_UPDATE=1
HOMEBREW_PREFIX=$(brew --prefix)

# shellcheck source=/dev/null
test -r "${HOME}/.bash_profile.before" && . "$_"

path_append() {
  for p in "$@"; do
    if echo "$PATH" | grep -E "(^|:)${p}(:|$)" >/dev/null ; then
      continue
    fi
    export PATH="${PATH:-''}${PATH:+:}${p}"
  done
}

path_prepend() {
  for p in "$@"; do
    if echo "$PATH" | grep -E "(^|:)${p}(:|$)" >/dev/null ; then
      continue
    fi
    export PATH="${p}${PATH:+:}${PATH:-''}"
  done
}

test -f ${HOME}/secrets/load.sh && . $_

path_append "${HOME}/bin"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# config rbenv
path_prepend "${HOME}/.rbenv/shims"
export RBENV_SHELL=bash
if command -v rbenv >/dev/null ; then
  eval "$(rbenv init -)"
fi
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

USE_JDK_VERSION=${USE_JDK_VERSION:=1.8}
if POSSIBLE_JAVA_HOME="$(/usr/libexec/java_home -v $USE_JDK_VERSION 2>/dev/null)"; then
  # Do this if you want to export JAVA_HOME
  export JAVA_HOME="$POSSIBLE_JAVA_HOME"
  path_prepend "${JAVA_HOME}/bin"
fi

export ANDROID_SDK_ROOT="${HOMEBREW_PREFIX}/share/android-sdk"
if [ -d "${ANDROID_SDK_ROOT}" ] ; then
  export ANDROID_HOME="$ANDROID_SDK_ROOT"
  path_append "${ANDROID_SDK_ROOT}/emulator" \
    "${ANDROID_SDK_ROOT}/tools" \
    "${ANDROID_SDK_ROOT}/tools/bin" \
    "${ANDROID_SDK_ROOT}/platform-tools"
else
  unset ANDROID_SDK_ROOT
fi

export ANDROID_NDK_HOME="${HOMEBREW_PREFIX}/share/android-ndk"
if [ ! -d "${ANDROID_NDK_HOME}" ] ; then
  unset ANDROID_NDK_HOME
fi

# maybe will cause bad things?
#if [ -d "${HOMEBREW_PREFIX}/opt/llvm/bin" ] ; then
#  path_prepend "${HOMEBREW_PREFIX}/opt/llvm/bin"
#  export LDFLAGS="-L${HOMEBREW_PREFIX}/opt/llvm/lib"
#  export CPPFLAGS="-I${HOMEBREW_PREFIX}/opt/llvm/include"
#fi

path_prepend "${HOME}/go/bin"

test -e ~/bin/goto_dir_of.sh && . $_

# shellcheck source=/dev/null
test -f "${HOME}/.bash_profile.after" && . "$_"
test -f "${HOME}/.bashrc" && . "$_"

# if [ -r "${HOME}/.bashrc" ] ; then
#   . "${HOME}/.bashrc"
# else
#   this_file="${BASH_SOURCE[0]}"
#   if ! echo "$this_file" | grep -E '^/' ; then
#     this_file="$(pwd)/$this_file"
#   fi
#   this_dir=$(dirname "$this_file")
#   bundled_rc="${this_dir}/.bashrc"
#   test -r "$bundled_rc" && . "$_"
# fi

if type xcrun >/dev/null 2>&1 ; then
  if sourcekit_lsp=$(xcrun --toolchain swift --find sourcekit-lsp 2>/dev/null) ; then
    export SOURCEKIT_LSP_PATH="$sourcekit_lsp"
  fi
fi
