# 0 A.D. 0.28.0 — native Android port (beta)

Release-signed APK for **arm64-v8a** Android devices.

- Engine: 0 A.D. / Pyrogenesis 0.28.0, GPLv2.
- Android: NDK r27d, SDL2 2.30.9, GLES2/3.
- Data: extracted on first launch into the app's internal storage (~3.2 GB).
- Tested on Samsung Galaxy Z Flip 6 (SM-F741B), Android 17.
- Package: `org.wildfiregames.zeroAD`, minSdk 24, targetSdk 36.
- Signing certificate: `CN=0 A.D. Android Port, O=Gubinskii, C=RU`.

## Known limitations

- Large APK (~2.07 GB); a first-run downloader is future work.
- `arm64-v8a` only.
- Some optional source textures exist only as cached DDS; a few log messages
  remain, although the game renders correctly.
- Multiplayer/lobby has not been validated.

## Source

Source, build scripts and test notes:
<https://github.com/Gubinskii/0ad-android>
