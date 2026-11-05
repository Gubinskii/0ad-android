# Источники порта

Проверено 03.11.2026.

| Компонент | Источник | SHA-256 |
|---|---|---|
| 0 A.D. 0.28.0 source | [Debian pool: 0ad_0.28.0.orig.tar.xz](https://deb.debian.org/debian/pool/main/0/0ad/0ad_0.28.0.orig.tar.xz) | `27e217755ef76a922fe58dbf593d96e54b6ed2375d23f548c35619aa6bd5a42a` |
| 0 A.D. 0.28.0 data | [Debian pool: 0ad-data_0.28.0.orig.tar.xz](https://deb.debian.org/debian/pool/main/0/0ad-data/0ad-data_0.28.0.orig.tar.xz) | — (1,415,012,652 bytes) |
| fmt 9.1.0 | [fmtlib/fmt 9.1.0](https://github.com/fmtlib/fmt/releases/tag/9.1.0) | — |
| gloox 1.0.28 | [Debian pool: gloox_1.0.28.orig.tar.bz2](https://deb.debian.org/debian/pool/main/g/gloox/gloox_1.0.28.orig.tar.bz2) | — |
| Android зависимые `.so` | Termux packages (`zlib`, `libpng`, `libxml2`, `libicu`, `libcurl`, `libenet`, `miniupnpc`, `libsodium`, `openal-soft`, `libvorbis`, `libogg`, `freetype`, `openssl`, `libgnutls`, …) | — |
| Android NDK r27d | [dl.google.com/android/repository/android-ndk-r27d-linux.zip](https://dl.google.com/android/repository/android-ndk-r27d-linux.zip) | `601246087a682d1944e1e16dd85bc6e49560fe8b6d61255be2829178c8ed15d9` |
| SpiderMonkey 128.13.0 | bundled `0ad-0.28.0/libraries/source/spidermonkey/mozjs-128.13.0.tar.xz` | `6422e51b9e76586c3054127bf13f992ec2338bd2d6156dc430accfb0b5301f1d` |
| Termux SpiderMonkey patches | [tur/0ad/spidermonkey-patches](https://github.com/termux-user-repository/tur/tree/master/tur/0ad/spidermonkey-patches) | — |
| SDL2 2.30.9 headers | [libsdl-org/SDL release-2.30.9](https://github.com/libsdl-org/SDL/releases/tag/release-2.30.9) | — |
| libpng 1.6.43 headers | [pnggroup/libpng v1.6.43](https://github.com/pnggroup/libpng/releases/tag/v1.6.43) | — |
| zlib 1.3.1 headers | [madler/zlib v1.3.1](https://github.com/madler/zlib/releases/tag/v1.3.1) | — |
| fmt headers | Ubuntu 24.04 `libfmt-dev` | — |
| Boost headers | Ubuntu 24.04 `libboost-dev` | — |

Официальный исходный код и релизы:

- [0 A.D. Gitea](https://gitea.wildfiregames.com/0ad/0ad/) — тег `v0.28.0`,
  коммит `a2cae4d69f816e9e9d7eecb6bf88f762afc0c90d`.
- [0 A.D. Release 28](https://play0ad.com/new-release-0-a-d-release-28-boiorix/).
- [AndroidPort wiki](https://trac.wildfiregames.com/wiki/AndroidPort?version=5) —
  старый план, не реализация.
- [Termux 0ad build recipe](https://github.com/termux-user-repository/tur/blob/master/tur/0ad/build.sh) —
  полезный пример нативной сборки 0 A.D. под Android/Bionic (Termux + X11),
  включая патчи SpiderMonkey. Не является APK-портом.
- [Сборка 0ad-data под Android toolchain](https://karkhaz.github.io/tuscan/android/0ad-data.html) —
  исторический пример, что данные собираются, но это не движок.

## Почему Debian-архив, а не releases.wildfiregames.com

Официальный `0ad-0.28.0-unix-build.tar.xz` (165 МБ) отдавался со скоростью
~100 Б/с и не скачался. Debian-зеркало отдало тот же исходник (SHA совпал с
Termux-рецептом) за несколько минут. Это тот же upstream-код 0.28.0, не патченный
Debian-ом (`orig.tar.xz`).
