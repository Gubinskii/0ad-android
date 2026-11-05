#!/bin/sh
# Configures (and optionally builds) standalone SpiderMonkey 128 for Android arm64.
# Usage: build-spidermonkey-android.sh [configure|build]
set -e
ROOT=$(cd "$(dirname "$0")/.." && pwd)
SM="$ROOT/0ad-0.28.0/libraries/source/spidermonkey"
NDK=${ANDROID_NDK:-/opt/android-ndk-r27d}
TC="$NDK/toolchains/llvm/prebuilt/linux-x86_64"
export CC="$TC/bin/aarch64-linux-android24-clang"
export CXX="$TC/bin/aarch64-linux-android24-clang++"
export AR="$TC/bin/llvm-ar"
export RANLIB="$TC/bin/llvm-ranlib"
export CC_FOR_TARGET="$CC"
export CXX_FOR_TARGET="$CXX"
export AR_FOR_TARGET="$AR"
export RANLIB_FOR_TARGET="$RANLIB"
export CARGO_TARGET_AARCH64_LINUX_ANDROID_LINKER="$CC"
export BINDGEN_EXTRA_CLANG_ARGS="--sysroot=$TC/sysroot -target aarch64-linux-android24"
export MOZCONFIG="$SM/mozconfig.android"
export MOZBUILD_STATE_PATH="$SM/mozbuild-state"
export MACH_BUILD_PYTHON_NATIVE_PACKAGE_SOURCE=none
export MOZ_NOSPAM=1
export CFLAGS="-O2 -fPIC"
export CXXFLAGS="-O2 -fPIC -std=gnu++20"
cd "$SM/mozjs-128.13.0"
./mach "${1:-build}"
