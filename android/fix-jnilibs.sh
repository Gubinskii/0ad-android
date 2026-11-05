#!/bin/sh
set -e
ROOT=$(cd "$(dirname "$0")/.." && pwd)
LIB="$ROOT/android/jniLibs/arm64-v8a"
find "$LIB" -type f -size 0 -delete
cp "$LIB/libxml2.so.16.1.4" "$LIB/libxml2.so.16"
cp "$LIB/libicuuc.so.78.3" "$LIB/libicuuc.so.78"
cp "$LIB/libicui18n.so.78.3" "$LIB/libicui18n.so.78"
cp "$LIB/libicudata.so.78.3" "$LIB/libicudata.so.78"
cp "$LIB/libz.so.1.3.2" "$LIB/libz.so.1"
ls -lh "$LIB" | head
