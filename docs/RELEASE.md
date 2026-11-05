# Android release checklist

The current `android/app.apk` is **debug-signed**, `android:debuggable="true"` and
about 2.07 GB. Do not publish it as a production build.

## 1. Create a release key

Keep the keystore outside the repository (it is in `.gitignore`):

```bash
keytool -genkeypair -v \
  -keystore release.keystore \
  -alias zeroad \
  -keyalg RSA -keysize 4096 -validity 10000 \
  -dname "CN=0 A.D. Android port, O=Independent, C=RU"
```

Back up the keystore and passwords. All future updates must use the same key.

## 2. Disable debuggable

In `android/AndroidManifest.xml` set:

```xml
android:debuggable="false"
```

## 3. Build and sign

Reuse the debug build pipeline for the APK contents, then sign the aligned APK
with the release key:

```powershell
# produce android/aligned.apk as in build-apk.ps1, then:
apksigner sign --ks release.keystore --ks-key-alias zeroad `
  --out android/app-release.apk android/aligned.apk
apksigner verify --print-certs android/app-release.apk
```

A release build has a different signing certificate than the debug build. To
install it on a device that already has the debug APK:

1. Uninstall `org.wildfiregames.zeroAD`.
2. Install `app-release.apk`.
3. On first launch wait while `0ad-data.zip` is extracted into internal storage.

Uninstalling removes the extracted data (~3.2 GB), which is recreated on first
launch.

## 4. Store size

The APK is larger than the 2 GB per-file limit of GitHub Releases. Options:

- host it on a normal HTTP server / CDN and publish a checksum;
- split the data into a first-run download (recommended long term);
- keep only a smaller menu/test dataset in the APK.

## 5. Legal

The engine is GPLv2. If you distribute the APK you must also make the
corresponding source available (this repository) and comply with the licenses of
the bundled libraries and game data (CC BY-SA for 0 A.D. art/data).
