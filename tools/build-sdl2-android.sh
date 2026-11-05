#!/bin/sh
# Builds SDL2 2.30.9 for Android arm64 with the NDK CMake toolchain.
set -e
ROOT=$(cd "$(dirname "$0")/.." && pwd)
NDK=${ANDROID_NDK:-/opt/android-ndk-r27d}
cmake -S "$ROOT/third_party/sdl2-src" -B "$ROOT/third_party/sdl2-build-android" -G Ninja \
  -DCMAKE_TOOLCHAIN_FILE="$NDK/build/cmake/android.toolchain.cmake" \
  -DANDROID_ABI=arm64-v8a -DANDROID_PLATFORM=android-24 \
  -DSDL_SHARED=ON -DSDL_STATIC=OFF -DSDL_TEST=OFF -DSDL_TESTS=OFF \
  -DCMAKE_BUILD_TYPE=Release
cmake --build "$ROOT/third_party/sdl2-build-android" -j8
