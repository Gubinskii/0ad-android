# Android host project

Minimal SDL2 host for `libpyrogenesis.so`.

## What is here

- `AndroidManifest.xml` — package `org.wildfiregames.zeroAD`, minSdk 24,
  targetSdk 36, landscape, GLES2.
- `PyrogenesisActivity.java` — extends SDL2 `SDLActivity`, overrides
  `getMainSharedObject()` to `libpyrogenesis.so` and `getMainFunction()` to
  `pyrogenesis_main`.
- `libmain.so` stub — `SDLActivity` loads it unconditionally; the actual
  entrypoint is `pyrogenesis_main` in `libpyrogenesis.so`.
- `jniLibs/arm64-v8a/` — `libpyrogenesis.so`, `libSDL2.so`, `libmozjs128-release.so`,
  `libgloox.so`, `libfmt.so`, and Termux/Android dependency `.so` files.
- `atlas_stub.cpp` — neutral `BeginAtlas`/`g_AtlasGameLoop` for the
  `--without-atlas` build.
- `build-apk.ps1` — aapt2/d8/apksigner build (no Gradle).

## Build / install

```powershell
powershell -ExecutionPolicy Bypass -File android/build-apk.ps1
adb install -r android/app.apk
adb shell am start -n org.wildfiregames.zeroAD/.PyrogenesisActivity
```

## Current result

`LauncherActivity` extracts the menu data from `assets/0ad-data.zip` into
`files/0ad` on first launch, then starts `PyrogenesisActivity`. The real 0 A.D.
main menu is shown on the emulator and on a Samsung Galaxy Z Flip 6.

APK v32 computes zoom from the full eye-to-ground vector (not just Y distance), so
pinch zooms in and out; every new primary touch resets the gesture state, making
box selection repeatable after any gesture.

APK v15 fixes a native crash in `CTouchInput::OnFingerMotion`: in the menu there is
no `g_Game`/camera, so finger motion now returns before dereferencing the camera.
It also forces `gui.scale=2.0` after reading the saved config, skips the welcome
splash, locks landscape, maps Back to the GUI Back button, ships `maps.zip`, fixes
the recursive `LoadAlphaMap` fallback, and replaces the unavailable GL buffer
mapping/subdata path with a staging-buffer upload. `build-graphics-android.sh`
must be run for renderer changes; `build-engine-android.sh` alone does not rebuild
`libgraphics.a`.
