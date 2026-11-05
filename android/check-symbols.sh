#!/bin/sh
set -e
ROOT=$(cd "$(dirname "$0")/.." && pwd)
LIB="$ROOT/android/jniLibs/arm64-v8a"
NM=/opt/android-ndk-r27d/toolchains/llvm/prebuilt/linux-x86_64/bin/llvm-nm
cd "$LIB"
$NM -D -u libpyrogenesis.so | awk '{print $2}' | sed 's/@.*//' | sort -u > /tmp/undef.txt
for f in *.so*; do
  $NM -D --defined-only "$f" 2>/dev/null | awk 'NF>=3 {print $3}' | sed 's/@.*//'
done | sort -u > /tmp/def.txt
comm -23 /tmp/undef.txt /tmp/def.txt > /tmp/missing.txt
head -80 /tmp/missing.txt
echo COUNT
wc -l < /tmp/missing.txt
