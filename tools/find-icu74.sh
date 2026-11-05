#!/bin/sh
NM=/opt/android-ndk-r27d/toolchains/llvm/prebuilt/linux-x86_64/bin/llvm-nm
for f in "$1"/*.a; do
  c=$($NM "$f" 2>/dev/null | grep -c 'icu_74')
  if [ "$c" != 0 ]; then echo "$f $c"; fi
done
