#!/bin/bash
test -d build && rm -rf build/*
test ! -d build && mkdir build

cmake --verbose -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
if [ -f "build/compile_commands.json" ] ; then
    if [ -f compile_commands.json ] ; then
        rm compile_commands.json
    fi
    ln -s "build/compile_commands.json" compile_commands.json
fi

