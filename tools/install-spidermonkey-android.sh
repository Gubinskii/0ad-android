#!/bin/sh
# Installs the Android SpiderMonkey build into the layout expected by premake.
set -e
ROOT=$(cd "$(dirname "$0")/.." && pwd)
SM="$ROOT/0ad-0.28.0/libraries/source/spidermonkey"
SRC="$SM/mozjs-128.13.0/build-android"
NDK=${ANDROID_NDK:-/opt/android-ndk-r27d}
STRIP="$NDK/toolchains/llvm/prebuilt/linux-x86_64/bin/llvm-strip"

rm -rf "$SM/include-release"
mkdir -p "$SM/include-release" "$SM/lib"
cp -RL "$SRC/dist/include/." "$SM/include-release/"
cp -L "$SRC/dist/bin/libmozjs128-release.so" "$SM/lib/libmozjs128-release.so"
"$STRIP" --strip-unneeded "$SM/lib/libmozjs128-release.so" || true
cp -L "$SRC/aarch64-linux-android/release/libjsrust.a" "$SM/lib/libmozjs128-rust.a"
ls -lh "$SM/lib/libmozjs128-release.so" "$SM/lib/libmozjs128-rust.a"
