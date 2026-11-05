# Native Android port — статус

Это отдельный проект от `zeroad-mobile` (там была самостоятельная RTS по мотивам).
Здесь — **настоящий порт 0 A.D./Pyrogenesis**: исходники v0.28.0, Android NDK,
кросс-компиляция движка и будущий APK.

**Статус: APK v37 — Android texture quality ограничена medium (экономия памяти), cache-loader использует `.cached.dds` при отсутствии source.**

## Что уже сделано

| Шаг | Результат |
|---|---|
| Исходники | `0ad-0.28.0/` — официальный релиз 0.28.0 (Debian orig tar, SHA зафиксирован в `sources.md` ниже) |
| NDK | Android NDK **r27d**, Linux x86_64, в Docker-томе `0ad-ndk` |
| Premake | `premake5` собран из `libraries/source/premake-core` |
| Android-конфигурация | сгенерированы makefile'ы с `--android --gles --without-atlas`; цель — `binaries/system/libpyrogenesis.so` |
| `lowlevel` | **68/68 объектов**, `liblowlevel.a` — 2,05 МБ, aarch64 |
| `gladwrapper` | `libgladwrapper.a` — 159 КБ, GLES2+EGL loader, aarch64 |
| `tinygettext` | `libtinygettext.a` — 373 КБ, aarch64; iconv через `SDL_iconv` |
| `mocks_real` | `libmocks_real.a` — 1,6 КБ, aarch64 |
| `network` | `libnetwork.a` — **14/14 объектов**, 2,47 МБ, aarch64 |
| `scriptinterface` | `libscriptinterface.a` — **10/10 объектов**, 1,35 МБ, aarch64 |
| `simulation2` | `libsimulation2.a` — **111/111 объектов**, 12,19 МБ, aarch64 |
| `lobby` | `liblobby.a` — **8/8 объектов**, 1,10 МБ, aarch64 |
| `engine` | `libengine.a` — **92/92 объектов**, 11,05 МБ, aarch64 |
| `gui` | `libgui.a` — **46/46 объектов**, 5,59 МБ, aarch64 |
| `graphics` | `libgraphics.a` — **125/125 объектов**, 15,59 МБ, aarch64 |
| **SDL2 2.30.9** | `libSDL2.so` — **6,2 МБ**, aarch64; NEEDED: `libGLESv2`, `libGLESv1_CM`, `libOpenSLES`, `libandroid`, `liblog` |
| **gloox 1.0.28** | `libgloox.so` — 1,46 МБ, aarch64 (без TLS/сжатия) |
| **`libpyrogenesis.so`** | **8,8 МБ**, AArch64, экспортирует `pyrogenesis_main`; 26 NEEDED-библиотек |
| **SpiderMonkey 128.13.0** | `libmozjs128-release.so` — **16 МБ**, `libmozjs128-rust.a` — 47 МБ, `include-release/`, aarch64 |
| **APK** | `android/app-release.apk` — **2,07 ГБ**, versionCode **37**, release-signed; `android/app.apk` — debug; полный набор графики/карт/анимаций/audio |
| **Путь данных** | `PyrogenesisActivity` задаёт `ZEROAD_ANDROID_DATA`; `Paths.cpp` читает env, fallback — старый путь |
| **Сборка** | `build-engine-android.sh` не пересобирает `libgraphics.a`; для правок рендера нужен `build-graphics-android.sh`, иначе APK линкуется со старым кодом |
| **Меню** | главное меню и Match Setup открываются на Flip 6; скриншоты `android/v11.png`, `android/v12.png` |
| **UI** | `gui.scale` принудительно **2.0** после чтения user.cfg; splash отключён; landscape зафиксирован |
| **Карты** | `maps.zip` (354 МБ карт), `terrain.zip` (848 МБ terrain/water/sky) и alphamaps |
| **Данные** | полный `0ad-data` (3,6 ГБ) распакован; в APK menu-набор 167 МБ (`mod.zip`, `public.zip`, config) |
| Заголовки | Boost, fmt 9, SDL2 2.30.9, libpng, zlib, libxml2, ICU 78, curl, enet, miniupnpc, cxxtest |

Проверка архитектуры:

```text
libpyrogenesis.so:      ELF64, DYN (Shared object), AArch64, exports pyrogenesis_main
libmozjs128-release.so: ELF64, DYN (Shared object), AArch64
Simulation2.o:          ELF64, REL (Relocatable), AArch64
```

Фактический запуск на эмуляторе:

```text
D/SDL: Running main function pyrogenesis_main from library libpyrogenesis.so
W/pyrogenesis: Sound: AlcInit success, using OpenAL Soft
W/pyrogenesis: FILES| Main log written to '/data/data/org.wildfiregames.zeroAD/files/0ad/logs/mainlog.html'
```

После этого на экране появляется welcome-диалог и главное меню 0 A.D.:
[menu.png](android/menu.png), [singleplayer.png](android/singleplayer.png).

## Что уже сломано и почему

| Блокер | Детали |
|---|---|
| PCH/libc++ | сгенерированный makefile подставляет PCH; libc++ NDK r27 падает на `va_list` в `bsd_locale_fallbacks.h`. Обход: `PCH=`, `-std=gnu++20` |
| Android sysdep | каталога `source/lib/sysdep/os/android` нет; premake подмешивает Linux/unix-реализации. `dir_watch_inotify.cpp` предупреждает, что `pthread_cancel` не поддерживается Bionic — это ещё не исправлено |
| Старый Android-проект | `build/android/sdl-project` — 2012 год, NDK r8, JS185; как есть не используется. Нужен новый SDL2/JS128 слой |
| `network`/JS | решено: `network`, `scriptinterface` и `simulation2` собираются с `include-release` от SpiderMonkey 128 |
| SpiderMonkey | собран под Android; пришлось применить 0 A.D. патчи + **9 Termux-патчей** и исправить коллизию `string.h`/`String.h` в `config/system-headers.mozbuild` |
| Ссылки | решено: `libpyrogenesis.so` слинкован с SDL2/gloox/Termux-зависимостями; 26 NEEDED |
| `engine`/`graphics`/`gui` | ✅ компилируются и входят в `libpyrogenesis.so` |
| `FALLTHROUGH` | в `renderer/backend/gl/Texture.cpp` нужен `FALLTHROUGH`; без PCH добавлен `tools/android_compat.h` с `-include` |
| **Пути Android** | `Paths.cpp` жёстко указывает `/data/data/org.wildfiregames.zeroAD/files/0ad`; для релиза нужен путь от JNI/Java |
| **APK** | ✅ self-contained: LauncherActivity распаковывает menu-данные в internal при первом запуске |
| Данные | для меню 167 МБ внутри APK; полный `0ad-data` 3,6 ГБ ещё не упакован |
| Рендер | ✅ GLES-контекст, меню и текст отрисовываются; звук музыки частично отсутствует (`Honor_Bound.ogg`) |
| SDL2 Java | ✅ Activity/`libmain.so`/`pyrogenesis_main` работают |
| Atlas | `--without-atlas`, но общий код ссылается на `BeginAtlas`/`g_AtlasGameLoop`; добавлен `android/atlas_stub.cpp` |
| ICU/fmt | ICU 78 и fmt 9 слинкованы; `libgraphics.a`/`FontManager` пересобраны под ICU 78 |
| Bionic libc | `ufilesystem.cpp` жёстко открывал `/system/lib/libc.so`; заменено на `dlopen("libc.so")` |
| GLES UBO | `CONFIG2_GLES` не поддерживал uniform buffers; для GLES 3 включён `GL_UNIFORM_BUFFER` |
| Error handler | `psDisplayError` вызывал `SetFullscreen` и рекурсивно падал; на Android отключено |

## Следующие вехи

1. **M1 — lowlevel целиком. ✅** `liblowlevel.a`: 68 объектов, aarch64; PNG/Zlib/Boost/fmt/SDL2/cxxtest headers застейджены. Остаётся проверить/заменить Linux-sysdep под Bionic на реальном устройстве.
2. **M2 — ядро движка. ✅** `mocks_real`, `tinygettext`, `network`, `scriptinterface`, `simulation2`, `lobby`, `engine`, `gui`, `graphics` — все объекты собраны под aarch64.
3. **M3 — SpiderMonkey 128. ✅** `libmozjs128-release.so` (16 МБ) + rust-архив (47 МБ) + headers, aarch64.
4. **M4 — окно и ввод. ✅** APK ставится, SDL создаёт GLES-окно, `pyrogenesis_main` вызывается, OpenAL инициализируется, меню отрисовывается.
5. **M5 — данные и APK. ✅ (menu).** APK собран; минимальный набор данных 307 МБ лежит в internal и достаточен для меню. Полный 3,6 ГБ набор — следующий шаг для игры.
6. **M6 — играбельность.** Производительность, полные текстуры/музыка, тач-UI, запуск матча, сохранения.

## Воспроизведение

```bash
# 1. Сгенерировать Android makefile'ы (нужен premake5 и host pkg-config)
sh tools/gen-android-workspace.sh --without-atlas

# 2. SpiderMonkey 128 (самое долгое: ~40 мин на 8 ядрах)
sh tools/build-spidermonkey-android.sh configure
sh tools/build-spidermonkey-android.sh build
sh tools/install-spidermonkey-android.sh

# 3. Библиотеки движка (в контейнере с NDK)
sh tools/build-lowlevel-android.sh
sh tools/build-gladwrapper-android.sh
sh tools/build-tinygettext-android.sh
sh tools/build-mocks-real-android.sh
sh tools/build-network-android.sh
sh tools/build-scriptinterface-android.sh
sh tools/build-simulation2-android.sh
sh tools/build-lobby-android.sh
sh tools/build-engine-android.sh
sh tools/build-gui-android.sh
sh tools/build-graphics-android.sh
sh tools/build-misc-android.sh

# 4. SDL2, gloox и финальная линковка
sh tools/build-sdl2-android.sh
sh tools/build-gloox-android.sh
sh tools/build-main-object-android.sh
sh tools/link-pyrogenesis-android.sh

# 5. APK (Windows host: aapt2/d8/apksigner из Android SDK)
powershell -ExecutionPolicy Bypass -File android/build-apk.ps1
adb install -r android/app.apk

# 6. Минимальные данные для меню (307 МБ) — в internal через run-as
adb push 0ad-data-min/binaries/data /data/local/tmp/0ad/
adb shell run-as org.wildfiregames.zeroAD mkdir -p files/0ad
adb shell run-as org.wildfiregames.zeroAD cp -r /data/local/tmp/0ad/data files/0ad/data
```

NDK и Ubuntu-контейнер не входят в репозиторий; путь к NDK задаётся `ANDROID_NDK`.
Скрипты рассчитаны на Linux-контейнер: Windows-распаковка NDK не годится из-за
символических ссылок и прав. Для SpiderMonkey нужен образ `0ad-build`
(`docker/Dockerfile`).

## Проверка на физическом устройстве

Samsung Galaxy Z Flip 6 (SM-F741B, Android 17, `PAGE_SIZE=4096`): APK ставится,
`LauncherActivity` распаковывает menu-данные, главное меню открывается.

Исправления после первых запусков на телефоне:

- **touch-краш**: `CTouchInput::OnFingerMotion` разыменовывал камеру, которой в
  меню ещё нет; добавлен guard;
- **мелкое меню**: `gui.scale` поднят до **1.75** для панели 2640x1080;
- **авторазворот и артефакты**: `PyrogenesisActivity` фиксирует
  `SCREEN_ORIENTATION_LANDSCAPE` и переопределяет `setOrientationBis`, чтобы SDL
  не включал `FULL_USER`;
- **выход из подменю**: системный Back кликает нижнюю правую кнопку Back в GUI
  через `SDLActivity.onNativeMouse`.
- **мелкий UI**: user.cfg содержал `gui.scale=1.0`; теперь масштаб принудительно
  ставится в 2.0 после чтения конфига. Splash/welcome отключён, чтобы не упираться
  в его кнопку OK.
- **старт карты**: `LoadAlphaMap` рекурсия (`path != standard`) исправлена,
  alphamaps добавлены. Следующий краш — нулевой указатель GL при загрузке VBO
  миникарты (`UploadDynamicBufferRegionImpl` → `glMapBuffer/glBufferSubData`);
  теперь используется staging-буфер и `glBufferDataARB`.

APK v27: `versionCode 27`, 1,8 ГБ. GUI scale 1.5 (вертикаль 720 — Setup и меню
помещаются). `SDL_HINT_TOUCH_MOUSE_EVENTS` отключён через override, чтобы SDL не
дублировал touch как mouse drag. Tap = левый клик, long press = правый,
two-finger twist (>0.04 rad) = поворот камеры, pinch = только зум; после подъёма
второго пальца жест завершается. Тени подняты до 2048 (quality 1).

APK v28: причина выбора группы — `SDL_Event_ ev;` не был занулён, поэтому в
`ev.button.clicks` лежал мусор, часто 2. 0 A.D. трактовал тап как double-click
и выбирал все похожие юниты. Теперь `SDL_Event_ ev{}` и `clicks = 1` для левого
и правого клика.

APK v29: один палец + движение теперь рисует прямоугольник выделения
(`SDL_MOUSEBUTTONDOWN`/`SDL_MOUSEMOTION`/`SDL_MOUSEBUTTONUP` с `clicks=1`),
а панорама перенесена на два пальца, движущихся вместе. Pinch — зум, twist —
поворот. Тап по-прежнему выбирает один объект, long press — правый клик.

APK v30 вернул одно-пальцевую панораму (быстрый свайп), а рамку выделения
перенёс на «задержал 0.35 с и потянул». Порог тапа поднят до 60 px, чтобы кнопка
Menu срабатывала. Двухпальцевая панорама убрана (она конфликтовала с
зумом/поворотом), зум ограничен 15% за событие, поворот — только при twist >0.12
rad.

APK v31: рамка запускается уже после удержания **0.18 с** (0.35 было слишком
долго и срабатывало не каждый раз). Зум переведён на отношение расстояний
`newDist/oldDist`: пока дистанция меняется, выполняется только зум (в обе
стороны), поворот — только если дистанция стабильна и twist >0.12 rad.

APK v32: зум считается не через `m_PanDist`, а по вектору `focus - eye` и полной
дистанции до земли, поэтому работает и приближение, и отдаление; шаг ограничен
25% дистанции. Новый primary-finger всегда сбрасывает `m_State` в
`STATE_FIRST_TOUCH`, даже если предыдущий жест не прислал up — рамка снова
запускается после каждого касания.


## Честно

**Boot/menu milestone достигнут:** 0 A.D. запускается на эмуляторе и на
Samsung Galaxy Z Flip 6, показывает welcome-диалог и главное меню; тапы и
свайпы в меню больше не роняют приложение. Это настоящий Pyrogenesis.

В APK v32 матч играбелен: террейн, здания, юниты, HUD, миникарта и туман
работают. Тап выбирает один юнит (`clicks=1`), быстрый свайп — панорама,
задержка 0.18 с + движение — рамка выделения (состояние сбрасывается на каждом
новом касании), pinch — зум в обе стороны, twist — поворот, long press — ПКМ.
