HOMEBREW_PREFIX="$(brew --prefix)"
ANDROID_SDK_ROOT="${HOMEBREW_PREFIX}/share/android-sdk"
if [ -d "${ANDROID_SDK_ROOT}" ] ; then
  export ANDROID_SDK_ROOT
  export ANDROID_HOME="$ANDROID_SDK_ROOT"
elif [ -d "$HOME/Library/Android/sdk" ] ; then
  ANDROID_SDK_ROOT="/Volumes/Disk2/Library/Android/sdk"
  if [ -h "$ANDROID_SDK_ROOT" ] ; then
    ANDROID_SDK_ROOT="$(realpath "$ANDROID_SDK_ROOT")"
  fi
  export ANDROID_SDK_ROOT
  export ANDROID_HOME="$ANDROID_SDK_ROOT"
fi

if [ -n "$ANDROID_SDK_ROOT" ] ; then
  path_append "${ANDROID_SDK_ROOT}/emulator" \
    "${ANDROID_SDK_ROOT}/tools" \
    "${ANDROID_SDK_ROOT}/tools/bin" \
    "${ANDROID_SDK_ROOT}/platform-tools"
fi

export ANDROID_NDK_HOME="${HOMEBREW_PREFIX}/share/android-ndk"
if [ ! -d "${ANDROID_NDK_HOME}" ] ; then
  unset ANDROID_NDK_HOME
fi