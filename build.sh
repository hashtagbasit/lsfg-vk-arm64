#!/bin/bash
# Builds liblsfg-vk-arm64.so on an aarch64 Linux box.
# Needs git, cmake, ninja, clang and the Vulkan headers.
set -euo pipefail

TAG=fp16-test-2   # the lsfg-vk version decky-lsfg-vk 0.12.x ships
HERE="$(cd "$(dirname "$0")" && pwd)"
SRC="$HERE/lsfg-vk"

rm -rf "$SRC"
git clone --depth 1 --branch "$TAG" --recurse-submodules --shallow-submodules \
    https://github.com/xXJSONDeruloXx/lsfg-vk.git "$SRC"

for p in "$HERE"/patches/*.patch; do
    echo "applying $(basename "$p")"
    git -C "$SRC" apply "$p"
done

cmake -S "$SRC" -B "$SRC/build" -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ \
    -DCMAKE_SHARED_LINKER_FLAGS="-Wl,-z,nodelete"
ninja -C "$SRC/build"

cp "$SRC/build/liblsfg-vk.so" "$HERE/liblsfg-vk-arm64.so"
echo "done: $HERE/liblsfg-vk-arm64.so"
