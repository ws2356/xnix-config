#!/bin/bash
xcrun -sdk iphoneos clang -print-search-dirs 2>&1 |\
  sed -n -E 's/^[[:space:]]*(libraries:[[:space:]]+)=(.+)[[:space:]]*$/\2/p' |\
  sed -n -E 's/([^[:space:]]+)[[:space:]]*$/\1/p'
