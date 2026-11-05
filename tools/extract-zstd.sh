#!/bin/sh
set -e
ROOT=$(cd "$(dirname "$0")/.." && pwd)
DEST="$ROOT/third_party/termux/root"
for f in "$ROOT"/third_party/termux/debs/zstd_*.deb "$ROOT"/third_party/termux/debs/liblz4_*.deb "$ROOT"/third_party/termux/debs/liblzma_*.deb; do
  dpkg-deb -x "$f" "$DEST"
done
find "$DEST" -name 'libzstd*' -o -name 'liblz4*' -o -name 'liblzma*'
