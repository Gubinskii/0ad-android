#!/bin/sh
set -e
ROOT=$(cd "$(dirname "$0")/.." && pwd)
cd "$ROOT/0ad-0.28.0/libraries/source/spidermonkey/mozjs-128.13.0"
for p in ../patches-termux/*.patch; do
  echo "== $p"
  patch -p1 --forward < "$p" || true
done
