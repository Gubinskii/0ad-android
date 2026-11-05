#!/bin/sh
# Links the Pyrogenesis shared library for Android arm64 using Termux aarch64
# shared dependencies plus the locally built static engine libraries.
set -e
ROOT=$(cd "$(dirname "$0")/.." && pwd)
NDK=${ANDROID_NDK:-/opt/android-ndk-r27d}
SYS="$NDK/toolchains/llvm/prebuilt/linux-x86_64/sysroot"
BIN="$NDK/toolchains/llvm/prebuilt/linux-x86_64/bin"
SYSBIN="$ROOT/0ad-0.28.0/binaries/system"
SM="$ROOT/0ad-0.28.0/libraries/source/spidermonkey"
TL="$ROOT/third_party/termux/root/data/data/com.termux/files/usr/lib"
OUT="$SYSBIN/libpyrogenesis.so"

"$BIN/aarch64-linux-android24-clang++" -shared -o "$OUT" \
  "$ROOT/0ad-0.28.0/build/workspaces/gcc/obj/pyrogenesis_Release/main.o" \
  "$SYSBIN/atlas_stub.o" \
  -Wl,--start-group \
    "$SYSBIN/libmocks_real.a" "$SYSBIN/libnetwork.a" "$SYSBIN/librlinterface.a" \
    "$SYSBIN/libdapinterface.a" "$SYSBIN/libtinygettext.a" "$SYSBIN/liblobby.a" \
    "$SYSBIN/libsimulation2.a" "$SYSBIN/libscriptinterface.a" "$SYSBIN/libengine.a" \
    "$SYSBIN/libgraphics.a" "$SYSBIN/libgui.a" "$SYSBIN/liblowlevel.a" \
    "$SYSBIN/libgladwrapper.a" "$SYSBIN/libmongoose.a" \
  -Wl,--end-group \
  -Wl,--no-as-needed \
  -L"$SM/lib" -lmozjs128-release -lmozjs128-rust \
  -L"$ROOT/third_party/sdl2-build-android" -lSDL2 \
  -L"$ROOT/third_party/gloox/lib" -lgloox \
  -L"$ROOT/third_party/fmt9-build" -lfmt \
  -Wl,--no-as-needed \
  -L"$TL" -l:libpng16.so -l:libxml2.so.16.1.4 -l:libicuuc.so.78.3 \
  -l:libicui18n.so.78.3 -l:libicudata.so.78.3 \
  -l:libcurl.so -l:libenet.so -l:libminiupnpc.so -l:libsodium.so \
  -l:libopenal.so -l:libvorbis.so -l:libvorbisfile.so -l:libogg.so \
  -l:libfreetype.so -l:libgnutls.so -l:libidn2.so -l:libz.so.1.3.2 \
  -l:libandroid-support.so -l:libc++_shared.so \
  -Wl,-rpath-link,"$TL" -Wl,-rpath,'$ORIGIN' \
  -Wl,--allow-shlib-undefined -lm -ldl -llog
"$BIN/llvm-readelf" -h "$OUT" | grep -E 'Class|Machine|Type'
