# Device test — release build

Device: **Samsung Galaxy Z Flip 6 (SM-F741B)**, Android 17, 12 GB RAM.

Build: release-signed `app-release.apk` (`versionCode 36`), GUI scale 1.5,
data path from `ZEROAD_ANDROID_DATA`.

## Long match

A Skirmish match against the AI was left running while sampling every two
minutes:

| Time | Total PSS | RSS | Battery temp | Thermal status | CPU |
|---|---:|---:|---:|---|---:|
| start | 1.02 GB | 1.10 GB | 34.0 °C | 0 | 55% |
| 2 min | 1.05 GB | 1.14 GB | 35.1 °C | 0 | 75% |
| 4 min | 1.06 GB | 1.15 GB | 35.7 °C | 0 | 72% |
| 6 min | 1.09 GB | 1.17 GB | 36.1 °C | 0 | 77% |
| 8 min | 1.13 GB | 1.21 GB | 36.8 °C | 0 | — |
| 12 min | 1.24 GB | 1.33 GB | 37.7 °C | 0 | — |
| 16 min | 1.29 GB | 1.37 GB | 37.8 °C | 0 | — |
| 20 min | 1.41 GB | 1.49 GB | 38.6 °C | 1 | — |
| 24 min | 1.49 GB | 1.57 GB | 39.3 °C | 1 | — |
| 28 min | 1.51 GB | 1.59 GB | 39.6 °C | 1 | — |

The process stayed alive, no native crash, no ANR. PSS grew from 1.02 GB to
1.51 GB over 28 minutes, then nearly plateaued at the end. Thermal status went
from 0 to 1 (light throttling) at ~38.6 °C. A 30+ minute soak and a native-heap
profile are still recommended; the growth is consistent with lazy texture/AI
caches but is larger than ideal.

## Known residual log noise

Debug builds still report a handful of optional assets that exist only as
`.cached.dds` in the release data (for example some
`art/textures/skins/props/*.png` source paths), plus missing optional audio
groups. The release package has no red error overlay and the visible game is
complete. To make the log completely clean, either add the original source
textures or extend the cache loader to fall back to `.cached.dds` when the
source is absent.
