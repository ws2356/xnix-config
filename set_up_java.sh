USE_JDK_VERSION=${USE_JDK_VERSION:=11}
if POSSIBLE_JAVA_HOME="$(/usr/libexec/java_home -v $USE_JDK_VERSION 2>/dev/null)"; then
  # Do this if you want to export JAVA_HOME
  export JAVA_HOME="$POSSIBLE_JAVA_HOME"
fi
if [ -n "$JAVA_HOME" ] ; then
  path_prepend "${JAVA_HOME}/bin"
fi
