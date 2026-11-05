#!/bin/sh
# Generates 0 A.D.'s Android makefiles with the bundled premake5.
set -e
ROOT=$(cd "$(dirname "$0")/.." && pwd)
cd "$ROOT/0ad-0.28.0/build/workspaces"
export PATH="$ROOT/0ad-0.28.0/libraries/source/premake-core/bin:$PATH"
./update-workspaces.sh --android --gles --with-system-premake5 "$@"
