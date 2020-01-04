#! /usr/bin/env bash
set -ex

env

foobar

swift build \
  -Xswiftc -sdk -Xswiftc "$(get_default_ios_sdk_path)" \
  -Xswiftc -target -Xswiftc "$(get_swift_host_triplet)"
