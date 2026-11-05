#!/bin/sh
# Compiles the Pyrogenesis entry point (main.cpp) for Android arm64.
set -e
ROOT=$(cd "$(dirname "$0")/.." && pwd)
NDK=${ANDROID_NDK:-/opt/android-ndk-r27d}
SYS="$NDK/toolchains/llvm/prebuilt/linux-x86_64/sysroot"
BIN="$NDK/toolchains/llvm/prebuilt/linux-x86_64/bin"
OUT="$ROOT/0ad-0.28.0/build/workspaces/gcc/obj/pyrogenesis_Release/main.o"
mkdir -p "$(dirname "$OUT")"
"$BIN/aarch64-linux-android24-clang++" -O2 -std=gnu++20 -fPIC -fno-rtti \
  -fvisibility=hidden -DNDEBUG -DCONFIG2_GLES=1 -DCONFIG_ENABLE_PCH=0 \
  -DTINYGETTEXT_WITH_SDL -DCONFIG2_NVTT=0 \
  -I"$ROOT/0ad-0.28.0/source" -I"$ROOT/0ad-0.28.0/source/pch/pyrogenesis" \
  -I"$ROOT/0ad-0.28.0/libraries/source/spidermonkey/include-release" \
  -I"$ROOT/third_party/fmt/include" -I"$ROOT/third_party/boost/include" \
  -I"$ROOT/third_party/libpng" -I"$ROOT/third_party/zlib" \
  -I"$ROOT/third_party/libxml2/include/libxml2" \
  -I"$ROOT/third_party/icu/include" -I"$ROOT/third_party/curl/include" \
  -I"$ROOT/third_party/enet/include" -I"$ROOT/third_party/miniupnpc/include" \
  -I"$ROOT/third_party/gloox/include" -I"$ROOT/third_party/sodium/include" \
  -I"$ROOT/third_party/sodium/include/sodium" \
  -I"$ROOT/third_party/openal/include" -I"$ROOT/third_party/vorbis/include" \
  -I"$ROOT/third_party/ogg/include" \
  -I"$ROOT/third_party/freetype/include/freetype2" \
  -I"$ROOT/third_party/sdl2-src/include" \
  -I"$ROOT/0ad-0.28.0/source/third_party/glad/include" \
  --sysroot="$SYS" -c "$ROOT/0ad-0.28.0/source/main.cpp" -o "$OUT"
"$BIN/llvm-nm" -C "$OUT" | grep -E 'pyrogenesis_main|SDL_main' || true
