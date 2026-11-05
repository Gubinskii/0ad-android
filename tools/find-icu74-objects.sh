#!/bin/sh
NM=/opt/android-ndk-r27d/toolchains/llvm/prebuilt/linux-x86_64/bin/llvm-nm
for f in "$1"/*.o; do
  if $NM "$f" 2>/dev/null | grep -q icu_74; then echo "$f"; fi
done
