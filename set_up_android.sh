if [[ "$OSTYPE" == "darwin"* ]]; then
    __SOFTWARE_PREFIX="$(brew --prefix)"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    __SOFTWARE_PREFIX="/usr/local"
fi

test -d "${__SOFTWARE_PREFIX}/share/android-sdk" && export ANDROID_SDK_ROOT="$_"
if [ -d "${ANDROID_SDK_ROOT:-}" ] ; then
  export ANDROID_SDK_ROOT
  export ANDROID_HOME="$ANDROID_SDK_ROOT"
elif [ -d "$HOME/Library/Android/sdk" ] ; then
  ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"
  if [ -h "$ANDROID_SDK_ROOT" ] ; then
    ANDROID_SDK_ROOT="$(realpath "$ANDROID_SDK_ROOT")"
  fi
  export ANDROID_SDK_ROOT
  export ANDROID_HOME="$ANDROID_SDK_ROOT"
fi

if [ -d "${ANDROID_SDK_ROOT:-}" ] ; then
  path_append "${ANDROID_SDK_ROOT}/emulator" \
    "${ANDROID_SDK_ROOT}/tools" \
    "${ANDROID_SDK_ROOT}/tools/bin" \
    "${ANDROID_SDK_ROOT}/platform-tools"
fi

test -d "${__SOFTWARE_PREFIX}/share/android-ndk" && export ANDROID_NDK_HOME="$_"
