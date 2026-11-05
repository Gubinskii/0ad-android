$ErrorActionPreference = 'Stop'
$root = (Resolve-Path 'port0ad').Path
$android = Join-Path $root 'android'
$sdk = 'C:\Users\ThinkPad Yoga\AppData\Local\Android\Sdk'
$bt = Join-Path $sdk 'build-tools\36.0.0'
$jar = Join-Path $sdk 'platforms\android-36\android.jar'
$jdk = 'C:\Program Files\Java\jdk-21.0.12.1'
$javac = Join-Path $jdk 'bin\javac.exe'
$keytool = Join-Path $jdk 'bin\keytool.exe'
$python = 'C:\Users\ThinkPad Yoga\.dsh\dsh-runtimes\dsh-primary-runtime\dependencies\python\python.exe'

Set-Location $android
Remove-Item -Recurse -Force classes, dex, compiled.zip, unsigned.apk, aligned.apk, app.apk -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force classes, dex | Out-Null

$javaFiles = Get-ChildItem -Recurse -Filter *.java java | ForEach-Object { $_.FullName }
& $javac -source 8 -target 8 -classpath $jar -d classes $javaFiles
if ($LASTEXITCODE -ne 0) { throw "javac failed" }

$classFiles = Get-ChildItem -Recurse -Filter *.class classes | ForEach-Object { $_.FullName }
& (Join-Path $bt 'd8.bat') --lib $jar --min-api 24 --output dex $classFiles
if ($LASTEXITCODE -ne 0) { throw "d8 failed" }

& (Join-Path $bt 'aapt2.exe') compile --dir res -o compiled.zip
if ($LASTEXITCODE -ne 0) { throw "aapt2 compile failed" }

& (Join-Path $bt 'aapt2.exe') link -o unsigned.apk -I $jar --manifest AndroidManifest.xml `
  --min-sdk-version 24 --target-sdk-version 36 --version-code 1 --version-name 0.28.0-android-m0 compiled.zip
if ($LASTEXITCODE -ne 0) { throw "aapt2 link failed" }

& $python -c @"
import zipfile, pathlib, sys
apk = pathlib.Path(r'unsigned.apk')
with zipfile.ZipFile(apk, 'a', zipfile.ZIP_DEFLATED) as z:
    z.write(r'dex/classes.dex', 'classes.dex')
    lib = pathlib.Path(r'jniLibs/arm64-v8a')
    for p in sorted(lib.iterdir()):
        if p.is_file():
            z.write(p, 'lib/arm64-v8a/' + p.name)
    assets = pathlib.Path(r'assets')
    if assets.is_dir():
        for p in sorted(assets.rglob('*')):
            if p.is_file():
                z.write(p, 'assets/' + p.relative_to(assets).as_posix())
print('packed', apk.stat().st_size)
"@
if ($LASTEXITCODE -ne 0) { throw "zip step failed" }

& (Join-Path $bt 'zipalign.exe') -f -p 4 unsigned.apk aligned.apk
if ($LASTEXITCODE -ne 0) { throw "zipalign failed" }

$ks = Join-Path $android 'debug.keystore'
if (-not (Test-Path $ks)) {
  & $keytool -genkeypair -v -keystore $ks -storepass android -keypass android `
    -alias androiddebugkey -keyalg RSA -keysize 2048 -validity 10000 `
    -dname "CN=Android Debug,O=Android,C=US"
  if ($LASTEXITCODE -ne 0) { throw "keytool failed" }
}

& (Join-Path $bt 'apksigner.bat') sign --ks $ks --ks-pass pass:android --key-pass pass:android `
  --out app.apk aligned.apk
if ($LASTEXITCODE -ne 0) { throw "apksigner failed" }

Get-Item app.apk | Select-Object FullName, Length
