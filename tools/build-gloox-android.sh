#!/bin/sh
set -e
ROOT=$(cd "$(dirname "$0")/.." && pwd)
NDK=${ANDROID_NDK:-/opt/android-ndk-r27d}
BIN="$NDK/toolchains/llvm/prebuilt/linux-x86_64/bin"
SYS="$NDK/toolchains/llvm/prebuilt/linux-x86_64/sysroot"
SRC="$ROOT/third_party/gloox-src"
cd "$SRC"
./configure --host=aarch64-linux-android --build=x86_64-pc-linux-gnu \
  --prefix="$ROOT/third_party/gloox" \
  --with-gnutls=no --with-openssl=no --with-zlib=no --with-libidn=no \
  --with-tests=no --with-examples=no \
  CC="$BIN/aarch64-linux-android24-clang" \
  CXX="$BIN/aarch64-linux-android24-clang++" \
  AR="$BIN/llvm-ar" RANLIB="$BIN/llvm-ranlib" \
  CFLAGS="-O2 -fPIC --sysroot=$SYS" \
  CXXFLAGS="-O2 -fPIC -std=gnu++20 --sysroot=$SYS"
make -j8
make install
