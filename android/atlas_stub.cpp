// Atlas is disabled for the Android port. The engine still references a few
// Atlas globals from shared rendering/game-loop code, so provide neutral
// zero-filled storage instead of linking wxWidgets.
class CmdLineArgs;
class DllLoader;

void BeginAtlas(const CmdLineArgs&, const DllLoader&)
{
}

struct AtlasGameLoopStorage
{
	char data[4096];
};

static AtlasGameLoopStorage g_AtlasGameLoopStorage = {};
void* g_AtlasGameLoop = &g_AtlasGameLoopStorage;
