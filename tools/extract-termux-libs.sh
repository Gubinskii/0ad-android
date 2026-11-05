#!/bin/sh
set -e
ROOT=$(cd "$(dirname "$0")/.." && pwd)
DEST="$ROOT/third_party/termux/root"
mkdir -p "$DEST"
for d in "$ROOT"/third_party/termux/debs/*.deb; do
  dpkg-deb -x "$d" "$DEST"
done
find "$DEST" -name '*.so*' | head -20
echo "COUNT"
find "$DEST" -name '*.so*' | wc -l
