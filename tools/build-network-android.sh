#!/bin/sh
# Cross-compiles 0 A.D.'s network static library for Android arm64.
set -e
ROOT=$(cd "$(dirname "$0")/.." && pwd)
NDK=${ANDROID_NDK:-/opt/android-ndk-r27d}
SYS="$NDK/toolchains/llvm/prebuilt/linux-x86_64/sysroot"
BIN="$NDK/toolchains/llvm/prebuilt/linux-x86_64/bin"
cd "$ROOT/0ad-0.28.0/build/workspaces/gcc"
make -f network.make config=release \
  PCH= PCH_PLACEHOLDER=/dev/null \
  CC="$BIN/aarch64-linux-android24-clang" \
  CXX="$BIN/aarch64-linux-android24-clang++" \
  AR="$BIN/llvm-ar" \
  ALL_CXXFLAGS="-O2 -std=gnu++20 -fPIC -fno-rtti -fvisibility=hidden \
    -DNDEBUG -DCONFIG2_GLES=1 -DCONFIG_ENABLE_PCH=0 \
    -I../../../source -I../../../source/pch/network \
    -I$ROOT/third_party/fmt/include -I$ROOT/third_party/boost/include \
    -I$ROOT/third_party/curl/include -I$ROOT/third_party/enet/include \
    -I$ROOT/third_party/miniupnpc/include \
    -I$ROOT/0ad-0.28.0/libraries/source/spidermonkey/include-release \
    -I$ROOT/third_party/sdl2-src/include --sysroot=$SYS" \
  ALL_CFLAGS="-O2 -fPIC -DNDEBUG -DCONFIG2_GLES=1 -DCONFIG_ENABLE_PCH=0 \
    -I../../../source -I$ROOT/third_party/curl/include \
    -I$ROOT/third_party/enet/include \
    -I$ROOT/third_party/miniupnpc/include --sysroot=$SYS"
