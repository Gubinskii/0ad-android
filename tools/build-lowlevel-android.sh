#!/bin/sh
# Cross-compiles 0 A.D.'s lowlevel library for Android arm64.
#
# Intended to run inside the Ubuntu build container with the Android NDK
# mounted at /opt (or set ANDROID_NDK). This is a milestone-0 probe, not the
# final engine build: several external libraries are not staged yet.
set -e
ROOT=$(cd "$(dirname "$0")/.." && pwd)
NDK=${ANDROID_NDK:-/opt/android-ndk-r27d}
SYS="$NDK/toolchains/llvm/prebuilt/linux-x86_64/sysroot"
BIN="$NDK/toolchains/llvm/prebuilt/linux-x86_64/bin"
CXX="$BIN/aarch64-linux-android24-clang++"
CC="$BIN/aarch64-linux-android24-clang"
AR="$BIN/llvm-ar"

cd "$ROOT/0ad-0.28.0/build/workspaces/gcc"

# PCH= is deliberate: the generated NDK makefiles otherwise feed a host-built
# PCH to clang and libc++'s locale fallback fails on va_list. Building without
# the PCH works; -std=gnu++20 is required for the same NDK/libc++ reason.
make -f lowlevel.make config=release \
  PCH= PCH_PLACEHOLDER=/dev/null \
  CC="$CC" CXX="$CXX" AR="$AR" \
  ALL_CXXFLAGS="-O2 -std=gnu++20 -fPIC -fno-rtti -fvisibility=hidden \
    -DNDEBUG -DCONFIG2_GLES=1 -DCONFIG_ENABLE_PCH=0 \
    -I../../../source -I../../../source/pch/lowlevel \
    -I../../../source/third_party/glad/include \
    -I../../../libraries/source/cxxtest-4.4 \
    -I$ROOT/third_party/fmt/include \
    -I$ROOT/third_party/boost/include \
    -I$ROOT/third_party/libpng \
    -I$ROOT/third_party/zlib \
    -I$ROOT/third_party/sdl2-src/include \
    --sysroot=$SYS" \
  ALL_CFLAGS="-O2 -fPIC -DNDEBUG -DCONFIG2_GLES=1 -DCONFIG_ENABLE_PCH=0 \
    -I../../../source --sysroot=$SYS"
