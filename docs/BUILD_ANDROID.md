# Building the Android port

This repository contains the **Android host** and the modified Pyrogenesis
sources. The 3.6 GB of game data, compiled libraries and the APK are intentionally
not committed.

## Prerequisites

- Linux x86_64 host or Docker Desktop (the build uses Linux NDK symlinks).
- Android NDK **r27d** (`/opt/android-ndk-r27d`), CMake, Ninja, GNU make,
  Python 3, Java 21.
- Android SDK build-tools 36 (`aapt2`, `d8`, `zipalign`, `apksigner`) and
  `android.jar` for API 36.
- The upstream 0 A.D. 0.28.0 source tree. The Debian `orig` tarball is:
  <https://deb.debian.org/debian/pool/main/0/0ad/0ad_0.28.0.orig.tar.xz>
  (SHA-256 `27e217755ef76a922fe58dbf593d96e54b6ed2375d23f548c35619aa6bd5a42a`).

## Restore the source tree

1. Extract upstream 0.28.0 and rename the top directory to `0ad-0.28.0/`.
2. Copy this repository's `0ad-0.28.0/source/` over the extracted source.
3. Copy `patches/system-headers.mozbuild` to
   `0ad-0.28.0/libraries/source/spidermonkey/mozjs-128.13.0/config/system-headers.mozbuild`.

The main patched files are:

- `source/ps/GameSetup/Paths.cpp` — data path from `ZEROAD_ANDROID_DATA`;
- `source/ps/GameSetup/GameSetup.cpp` — SDL/GLES setup, touch hint, error handling;
- `source/ps/TouchInput.cpp` and `.h` — Android touch gestures;
- `source/ps/VideoMode.cpp` — fixed GUI scale / landscape GLES;
- `source/graphics/TerrainTextureManager.cpp` — alphamap fallback recursion fix;
- `source/renderer/backend/gl/DeviceCommandContext.cpp` — GLES buffer upload;
- `source/renderer/ShadowMap.cpp` — Android shadow quality;
- `source/lib/secure_crt.cpp`, `source/lib/sysdep/os/unix/ufilesystem.cpp` —
  Bionic compatibility.

## Toolchain and dependencies

`tools/` contains the reproducible scripts used during development:

- `build-lowlevel-android.sh`
- `build-libraries-android.sh`
- `build-engine-android.sh`
- `build-graphics-android.sh`
- `link-pyrogenesis-android.sh`
- `install-spidermonkey-android.sh`
- `extract-termux-libs.sh`

Important: renderer changes are in `libgraphics.a`. Running only
`build-engine-android.sh` will not rebuild them; always run
`build-graphics-android.sh` for renderer/Android graphics changes.

## Data and APK

`android/LauncherActivity.java` extracts `assets/0ad-data.zip` into the app's
private files directory on first launch. The engine receives that path through
`ZEROAD_ANDROID_DATA` (set from Java), so the package name is not hard-coded in
C++.

The `assets/` and `jniLibs/` directories are generated and excluded from Git.
To rebuild the debug APK, place the required native libraries and generated
`0ad-data.zip` in those directories, then run:

```powershell
powershell -ExecutionPolicy Bypass -File android/build-apk.ps1
```

The resulting `android/app.apk` is debug-signed and suitable for local testing
only.

See [RELEASE.md](RELEASE.md) before distributing a build.
