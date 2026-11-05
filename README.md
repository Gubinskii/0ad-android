# 0 A.D. — native Android port

This directory is the **real port workspace**, separate from the fan-made mobile RTS
in `../zeroad-mobile`.

**Status: release-signed build on the Flip 6. A 28-minute AI match stayed alive
(PSS 1.51 GB, 39.6 °C, thermal status 1). The data path is dynamic.**

- [PORT_STATUS.md](PORT_STATUS.md) — what compiles, what is broken, next milestones.
- [sources.md](sources.md) — source/NDK checksums and references.
- [docs/BUILD_ANDROID.md](docs/BUILD_ANDROID.md) — restoring upstream and building.
- [docs/RELEASE.md](docs/RELEASE.md) — release signing and store-size checklist.
- [docs/TESTING.md](docs/TESTING.md) — 8-minute Flip 6 soak/memory/thermal results.
- `docs/screenshots/` — Flip 6 menu, Match Setup and in-game screenshots.
- `0ad-0.28.0/source/` — patched Pyrogenesis sources (upstream tree is fetched separately).
- `patches/system-headers.mozbuild` — SpiderMonkey header patch.
- `tools/` — reproducible cross-compile scripts.
  - `build-spidermonkey-android.sh` + `install-spidermonkey-android.sh`
  - `build-lowlevel-android.sh`, `build-gladwrapper-android.sh`
  - `build-network-android.sh`, `build-scriptinterface-android.sh`
  - `build-simulation2-android.sh`, `build-lobby-android.sh`
  - `build-engine-android.sh`, `build-gui-android.sh`, `build-graphics-android.sh`
  - `build-tinygettext-android.sh`, `build-mocks-real-android.sh`

## Built for Android arm64

- `liblowlevel.a` — 68 objects, 2.05 MB.
- `libgladwrapper.a` — GLES2/EGL loader.
- `libtinygettext.a` — translations via `SDL_iconv`.
- `libmocks_real.a`.
- `libnetwork.a` — 14 objects, 2.47 MB.
- `libscriptinterface.a` — 10 objects, 1.35 MB.
- `libsimulation2.a` — 111 objects, 12.19 MB.
- `liblobby.a` — 8 objects, 1.10 MB.
- `libengine.a` — 92 objects, 11.05 MB.
- `libgui.a` — 46 objects, 5.59 MB.
- `libgraphics.a` — 125 objects, 15.59 MB.
- `third_party/sdl2-build-android/libSDL2.so` — 6.2 MB, SDL2 2.30.9 for Android.
- `third_party/gloox/lib/libgloox.so` — 1.46 MB, gloox 1.0.28 for Android.
- `0ad-0.28.0/binaries/system/libpyrogenesis.so` — 8.8 MB, exports `pyrogenesis_main`.
- `android/app-release.apk` — 2.07 GB release-signed APK, versionCode 36; full menu,
  maps, terrain, actors, skins, materials, animations, audio and shadows.
- `android/app.apk` — local debug APK used during development.
- `android/main0.png` — main menu on the Galaxy Z Flip 6.
- `android/menu.png` — screenshot of the in-game main menu (emulator).
- `0ad-data/` — 3.6 GB extracted game data; `0ad-data-menu/` — 167 MB menu subset.
- `libraries/source/spidermonkey/lib/libmozjs128-release.so` — 16 MB.
- `libraries/source/spidermonkey/lib/libmozjs128-rust.a` — 47 MB.
- `libraries/source/spidermonkey/include-release/` — SpiderMonkey 128 headers.

All are AArch64 (`aarch64-linux-android24`) unless noted.

## Build host

Ubuntu 24.04 containers, Android NDK r27d in the Docker volume `0ad-ndk`, and the
`0ad-build` image for SpiderMonkey (`docker/Dockerfile`). The NDK and image are not in
the repository.
