#!/usr/bin/env bash

set -ex

zig build-lib ./fuzz.zig -OReleaseSafe -ofmt=c
zig build-obj $(zig env | jq .lib_dir -r)/compiler_rt.zig -OReleaseSafe -ofmt=c
hfuzz-clang compiler_rt.c fuzz.c -I $(zig env | jq .lib_dir -r) -o fuzz
honggfuzz -i honggfuzz-corpus -P -- ./fuzz