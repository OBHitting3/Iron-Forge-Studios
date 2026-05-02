# Palm Springs Paradise — Setup Guide

How to deploy this project to Roblox Studio.

## What you need

1. **Roblox Studio** — https://create.roblox.com/
2. **Rojo** — sync tool that maps the file tree into Studio. Install one of:
   - **Foreman** (recommended): `foreman install` from this directory
   - **Aftman**: alternative toolchain manager
   - **Manual**: download Rojo binary from https://github.com/rojo-rbx/rojo/releases (v7+)
3. **Rojo Studio Plugin** — install from the Roblox plugin marketplace, or via `rojo plugin install`

## First-time deployment (5 minutes)

```bash
# 1. From the project root, start the Rojo server
rojo serve default.project.json

# 2. In Roblox Studio:
#    - Open a new baseplate (or any blank place)
#    - Open the Rojo plugin (toolbar)
#    - Click "Connect"
#    - All scripts, services, modules sync into the place automatically
```

After connecting, you should see:
- `ServerScriptService` populated with `GameInit` + `Services/` + `Modules/`
- `ReplicatedStorage` populated with `Modules/`
- `StarterPlayer.StarterPlayerScripts` populated with `ClientInit` + `Controllers/` + `Components/` + `UI/`

## Press Play

Hit F5 (or "Play"). You should see in the output:
```
═══════════════════════════════════════════════════
  Palm Springs Paradise: Steal the Oasis
  Server Initializing...
═══════════════════════════════════════════════════
  ✓ DataService initialized (Xms)
  ✓ WorldService initialized (Xms)
  ✓ EggService initialized (Xms)
  ✓ HeistService initialized (Xms)
  ✓ PlotService initialized (Xms)
  ✓ TradeService initialized (Xms)
  ✓ MonetizationService initialized (Xms)
  ✓ LeaderboardService initialized (Xms)
  ✓ SettingsService initialized (Xms)
═══════════════════════════════════════════════════
  Server Ready!
═══════════════════════════════════════════════════
[Client] All systems ready!
```

The world will generate procedurally (7 zones, ~2048x2048 studs, plots, props, signs).

## Before going public

### 1. Set Robux IDs
Edit `src/ReplicatedStorage/Modules/Shared/Constants.lua`. Replace every `PassId = 0` and `ProductId = 0` with the IDs from your Roblox developer dashboard:

```lua
Constants.GamePasses = {
    DesertVIP = { ... PassId = 123456789 },  -- ← your real game pass ID
    ...
}
Constants.DevProducts = {
    DC1000 = { ... ProductId = 987654321 },  -- ← your real product ID
    ...
}
```

### 2. Replace placeholder sound IDs
Edit `src/StarterPlayerScripts/Components/SoundController.lua`. The `SOUNDS` table has placeholder asset IDs — replace them with your own audio assets uploaded to Roblox.

### 3. Enable required APIs in Studio
Game Settings → Security:
- ✅ Enable Studio Access to API Services (for DataStore testing)
- ✅ Allow HTTP Requests (if you add MessagingService in production)

### 4. Test DataStore
DataStores **only work in published games**, not in Studio without configuration. To test:
- Publish to a private place
- Or enable "API Services" and join via a real server (not Studio Play)

### 5. Configure place settings
- Max players: 100 (matches `Constants.MAX_PLAYERS`)
- Filtering: ON (always)
- Allowed gear types: none

## Project structure

```
default.project.json   ← Rojo config (root)
src/
├── ReplicatedStorage/    ← shared code (client + server)
├── ServerScriptService/  ← server-only logic
├── StarterPlayerScripts/ ← client controllers, UI, VFX, sounds
└── ServerStorage/        ← server-only assets
```

See `src/ARCHITECTURE.md` for the full module breakdown.

## Common issues

**"Module not found"** — Rojo isn't synced yet. Make sure the Rojo server is running and the plugin is connected.

**"DataStore can only be used in published games"** — This is expected in Studio without API services enabled. Either publish the place or enable API access in Game Settings.

**Black screen on join** — Check the Output window for client init errors. Most issues are missing requires due to a partial sync. Stop the Rojo server, restart, and reconnect.

**"X passes failed"** — All `PassId = 0` and `ProductId = 0` must be set to real IDs before pass purchases will work.

## Iterating

- Edit any `.lua` file → save → Studio updates automatically
- Test → stop → re-edit → save → test again
- For data wipes during testing: change `Constants.DataStore.NAME` to a new value (e.g. `_v3`)
