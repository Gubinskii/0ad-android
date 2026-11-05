#!/bin/sh
# Cross-compiles the glad GLES2 loader wrapper for Android arm64.
set -e
ROOT=$(cd "$(dirname "$0")/.." && pwd)
NDK=${ANDROID_NDK:-/opt/android-ndk-r27d}
SYS="$NDK/toolchains/llvm/prebuilt/linux-x86_64/sysroot"
BIN="$NDK/toolchains/llvm/prebuilt/linux-x86_64/bin"
cd "$ROOT/0ad-0.28.0/build/workspaces/gcc"
make -f gladwrapper.make config=release \
  PCH= PCH_PLACEHOLDER=/dev/null \
  CC="$BIN/aarch64-linux-android24-clang" \
  CXX="$BIN/aarch64-linux-android24-clang++" \
  AR="$BIN/llvm-ar" \
  ALL_CXXFLAGS="-O2 -std=gnu++20 -fPIC -fno-rtti -fvisibility=hidden \
    -DNDEBUG -DCONFIG2_GLES=1 -DCONFIG_ENABLE_PCH=0 \
    -I../../../source -I../../../source/third_party/glad/include \
    --sysroot=$SYS" \
  ALL_CFLAGS="-O2 -fPIC -DNDEBUG -DCONFIG2_GLES=1 -DCONFIG_ENABLE_PCH=0 \
    -I../../../source -I../../../source/third_party/glad/include \
    --sysroot=$SYS"
