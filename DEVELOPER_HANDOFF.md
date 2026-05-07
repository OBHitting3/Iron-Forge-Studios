# Palm Springs Paradise: Steal the Oasis — Developer Handoff

**Date:** May 7, 2026
**Repository:** `Iron-Forge-Studios` (branch: `claude/palm-springs-game-foundation-BFruU`)
**Codebase:** 34 Lua files, ~7,800 lines
**Status:** Feature-complete scaffold. Syncs into Roblox Studio via Rojo. All game systems implemented in code; needs art assets, real Robux IDs, and playtesting before public launch.

---

## 1. What This Is

A collectible-tycoon-steal hybrid for Roblox. Players explore a stylized Palm Springs desert (2048x2048 studs, 7 themed zones, 100 players/server), hatch eggs to discover 50 desert-themed collectible icons, earn passive income, build mid-century oasis plots, steal from other players via a lockpicking minigame, and trade on a cross-server marketplace.

**Core loop:** Spawn -> Free eggs -> Hatch at Hot Springs -> Passive income -> Build oasis -> Heist/Get heisted -> Trade -> Leaderboards

---

## 2. How to Deploy

Full instructions are in `SETUP.md`. Quick version:

```bash
# 1. Install Rojo (v7.4.4)
foreman install          # reads foreman.toml

# 2. Start the sync server
rojo serve default.project.json

# 3. In Roblox Studio:
#    - Open a new baseplate
#    - Open the Rojo plugin -> click "Connect"
#    - All 34 scripts sync into the place automatically
#    - Press F5 to play-test
```

You should see all 9 services initialize in the output console with checkmarks.

---

## 3. Project Structure

```
Iron-Forge-Studios/
├── default.project.json            # Rojo config — maps src/ to Roblox services
├── foreman.toml                    # Toolchain (Rojo 7.4.4, Selene, StyLua)
├── SETUP.md                        # Deployment guide
├── src/
│   ├── ARCHITECTURE.md             # Technical architecture doc
│   ├── ReplicatedStorage/          # Shared code (client + server can access)
│   │   └── Modules/
│   │       ├── Shared/
│   │       │   ├── Constants.lua       # ALL tuning values, zone defs, pass/product IDs
│   │       │   ├── Remotes.lua         # Central RemoteEvent/RemoteFunction registry (~30 remotes)
│   │       │   ├── Signal.lua          # Custom event system (Connect/Fire/Wait)
│   │       │   └── Util.lua            # DeepCopy, WeightedRandom, FormatNumber, etc.
│   │       └── Data/
│   │           ├── PlayerDataTemplate.lua   # Player save schema (everything a player owns)
│   │           ├── IconDatabase.lua         # 50 collectible icons with rarity/category/descriptions
│   │           └── FurnitureDatabase.lua    # 52 furniture items across 11 categories
│   │
│   ├── ServerScriptService/        # Server-only code
│   │   ├── GameInit.server.lua     # Server bootstrap — inits all 9 services in order
│   │   ├── Services/
│   │   │   ├── DataService.lua         # DataStore v2, session locking, auto-save (60s), retry
│   │   │   ├── WorldService.lua        # Procedural world generation (7 zones, terrain, props, skybox)
│   │   │   ├── EggService.lua          # Egg hatching, weighted rarity rolls, evolution, passive income
│   │   │   ├── HeistService.lua        # Heist flow, lockpick minigame, vault, anti-grief protections
│   │   │   ├── PlotService.lua         # 100 plots (10x10 grid), furniture placement, display pedestals
│   │   │   ├── TradeService.lua        # P2P trade sessions, cross-server marketplace
│   │   │   ├── MonetizationService.lua # Game passes, dev products, receipt processing, Premium
│   │   │   ├── LeaderboardService.lua  # 4 OrderedDataStore leaderboards with physical in-world boards
│   │   │   └── SettingsService.lua     # Client settings validation & persistence
│   │   └── Modules/
│   │       └── RateLimiter.lua         # Per-player sliding-window rate limiter
│   │
│   ├── StarterPlayerScripts/       # Client code (runs on each player's machine)
│   │   ├── ClientInit.client.lua   # Client bootstrap — loads all controllers + components
│   │   ├── Controllers/
│   │   │   ├── DataController.lua      # Client-side data cache + change signals
│   │   │   ├── EggController.lua       # Hatch/evolve request wrappers
│   │   │   ├── HeistController.lua     # Heist flow, lockpick input capture
│   │   │   ├── PlotController.lua      # Build mode, furniture preview, grid snapping
│   │   │   ├── TradeController.lua     # Trade session wrappers
│   │   │   └── UIController.lua        # Master UI manager (HUD, action bar, notifications, keybinds)
│   │   ├── Components/
│   │   │   ├── VFXController.lua       # Particle effects (hatch burst, evolve sparkle, steal cam)
│   │   │   └── SoundController.lua     # Sound library + automatic playback hooks
│   │   └── UI/
│   │       ├── UIHelpers.lua           # Shared theme, builder functions, panel open/close tweens
│   │       ├── EggHatchUI.lua          # Egg tier cards, hatch button, result overlay
│   │       ├── InventoryUI.lua         # 3 tabs: Icons / Collection Book / Vault
│   │       ├── HeistUI.lua             # Target picker, countdown, lockpick arrows, steal cam
│   │       ├── TradeUI.lua             # Trade request popup, two-sided offer window
│   │       ├── BuildUI.lua             # Furniture catalog, category sidebar, placement preview
│   │       ├── LeaderboardUI.lua       # 4-tab leaderboard viewer
│   │       └── SettingsUI.lua          # Volume sliders, notification toggles
│   │
│   ├── StarterGui/                 # (empty — all UI is created via scripts)
│   └── ServerStorage/              # Server-only assets (add 3D models here)
```

---

## 4. Systems Overview

### 4.1 Economy — Desert Coins (DC)

| Source | Amount |
|--------|--------|
| Starting balance | 500 DC |
| Passive income (per icon) | 1–500 DC/min, multiplied by evolution tier |
| Plot visitor bonus | 1 DC per unique visitor per day |
| Premium payout | +500 DC on join |

| Sink | Cost |
|------|------|
| Desert Egg | 100 DC |
| Oasis Egg | 500 DC |
| Mirage Egg | 2,500 DC |
| Celestial Egg | 10,000 DC |
| Trade tax | 5% of DC in trade |

### 4.2 Collectible Icons (50 total)

7 rarity tiers, weighted random (total weight 10,000):

| Rarity | Weight | Drop Rate | Passive Income |
|--------|--------|-----------|----------------|
| Common | 4,500 | 45% | 1 DC/min |
| Uncommon | 2,500 | 25% | 5 DC/min |
| Rare | 1,500 | 15% | 15 DC/min |
| Epic | 800 | 8% | 40 DC/min |
| Legendary | 400 | 4% | 100 DC/min |
| Mythical | 290 | 2.9% | 150 DC/min |
| SECRET | 10 | 0.1% | 500 DC/min |

### 4.3 Evolution

Consumes duplicate icons to upgrade:

| Stage | Dupes Required | Income Multiplier |
|-------|---------------|-------------------|
| Shiny | 3 | 2x |
| Golden | 5 | 4x |
| Diamond | 10 | 8x |
| Celestial | 25 | 16x |

### 4.4 Heist System

- **Flow:** Select target -> 10s countdown -> 15s lockpick minigame (6 directional inputs) -> steal 1 displayed icon on success
- **Anti-grief:** 30min fail cooldown, 30min target cooldown, 30min newbie shield, 10 daily attempts, 5min server-hop lockout
- **Vault:** 3 free protected slots, expandable by 5 slots via Robux (199R$)

### 4.5 Building / Plots

- 100 plots in a 10x10 grid, 32x32 studs each
- 52 furniture items across 11 categories
- Grid-snap placement with bounds validation
- Display pedestals for showing off icons (marble base + point light)
- 5-star rating system from visitors
- 4 exclusive items require Oasis Architect pass

### 4.6 Trading

- Direct P2P: icons + DC, double-confirm required, 5% DC tax
- Cross-server marketplace via MessagingService
- 30s auto-expire on pending requests
- Trade history capped at 50 entries per player

### 4.7 Leaderboards

4 categories (Top Collectors, Richest, Best Heists, Top Oasis), stored in OrderedDataStores, displayed on physical in-world boards in Downtown zone, refreshed every 2 minutes.

### 4.8 Data Persistence

- DataStore v2 with session locking (prevents data loss from multi-server joins)
- Auto-save every 60 seconds + BindToClose for shutdown saves
- Retry with exponential backoff (3 attempts)
- Schema reconciliation on load (missing fields get defaults)
- Key format: `Player_{UserId}`
- DataStore name: `PalmSpringsParadise_v2` (change this for data wipes)

---

## 5. Things You Must Do Before Going Public

### 5.1 Replace Robux IDs (CRITICAL)

Every `PassId = 0` and `ProductId = 0` in `src/ReplicatedStorage/Modules/Shared/Constants.lua` must be replaced with real IDs from your Roblox Creator Dashboard.

**Game Passes to create (6):**

| Pass Name | Suggested Price | Benefits |
|-----------|----------------|----------|
| Desert VIP | 799 R$ | 2x income, VIP zone, gold name tag |
| Heist Master | 499 R$ | +3 daily heist attempts, heist radar |
| Auto-Collector | 399 R$ | Offline income up to 8hr |
| Oasis Architect | 349 R$ | Double plots, exclusive furniture |
| Speed Demon | 249 R$ | 2x walk speed, desert cart, zone teleport |
| Mega Bundle | 1,999 R$ | All passes + 10,000 DC + SECRET egg |

**Developer Products to create (7):**

| Product Name | Suggested Price | Delivers |
|-------------|----------------|----------|
| 1,000 Desert Coins | 99 R$ | 1,000 DC |
| 5,000 Desert Coins | 399 R$ | 5,000 DC |
| Premium Egg | 149 R$ | Guaranteed Rare+ egg |
| Legendary Egg | 499 R$ | Guaranteed Legendary+ egg |
| Lucky Boost (30min) | 49 R$ | Re-roll for higher rarity |
| Heist Shield (1hr) | 79 R$ | Immune to heists |
| Vault +5 Slots | 199 R$ | +5 vault slots |

### 5.2 Replace Sound Asset IDs

`src/StarterPlayerScripts/Components/SoundController.lua` has a `SOUNDS` table with placeholder Roblox asset IDs. Upload your own audio assets to Roblox and replace every ID. Sounds needed:

- UIClick, UIOpen, UIClose
- EggHatchCommon, EggHatchRare, EggHatchLegendary, EggHatchSECRET
- EvolveSuccess
- HeistAlarm, HeistCountdown, HeistLockpick, HeistSuccess, HeistFail
- StealCamSting
- TradeRequest, TradeComplete
- PassiveIncome
- LevelUp
- AmbientDesert (looping background music)

### 5.3 Add 3D Art Assets

The code generates placeholder geometry (colored Part blocks, cylinders, etc.) for the world and furniture. For a polished game, replace these with real 3D models:

- **Furniture models**: Place in `ServerStorage/FurnitureModels/`. The 52 items are defined in `FurnitureDatabase.lua` — each has an `Id` field that should match the model name.
- **World props**: `WorldService.lua` generates palm trees, cacti, buildings, pools, turbines, etc. as code-built Parts. Replace with MeshParts or imported models.
- **Egg visuals**: `EggHatchUI.lua` draws colored oval shapes. Replace with 3D egg models or decals.
- **Icon visuals**: `InventoryUI.lua` shows colored circles with text. Add actual icon images (ImageLabels with decal IDs).

### 5.4 Enable Studio Settings

Game Settings -> Security:
- Enable Studio Access to API Services (for DataStore testing)
- Allow HTTP Requests (for MessagingService in production)

Game Settings -> Other:
- Max players: 100
- Filtering: ON (always)

### 5.5 Publish & Test DataStore

DataStores only work in published games. To test saves:
1. Publish to a private place
2. Enable API Services
3. Join via a real server (not just Studio Play)

---

## 6. Configuration Quick Reference

**All tunable values live in one file:** `src/ReplicatedStorage/Modules/Shared/Constants.lua`

This includes: zone positions/radii, egg costs, rarity weights, evolution requirements, heist timers/cooldowns, plot sizes/limits, pass prices, product prices, rate limits, DataStore settings, trade settings. Change any value here and it propagates everywhere.

**Player data schema:** `src/ReplicatedStorage/Modules/Data/PlayerDataTemplate.lua`
If you add new fields to the template, existing players get them automatically on next login (schema reconciliation in DataService).

**DataStore data wipe:** Change `Constants.DataStore.NAME` to a new value (e.g., `_v3`). All players start fresh.

---

## 7. Architecture Notes for Your Dev

### Server-Authoritative

Every economy mutation (currency, icons, trades, heists) happens server-side. The client sends requests via RemoteEvents; the server validates and responds. Never trust the client.

### Init Order Matters

`GameInit.server.lua` initializes services in this exact order:
1. DataService (must be first — all others depend on it)
2. WorldService
3. EggService
4. HeistService
5. PlotService
6. TradeService
7. MonetizationService
8. LeaderboardService
9. SettingsService

Do not reorder without understanding the dependency chain.

### Adding a New Service

1. Create `src/ServerScriptService/Services/MyService.lua` with an `Init()` function
2. Add it to the `Services` table in `GameInit.server.lua`
3. If it needs a client counterpart, create `src/StarterPlayerScripts/Controllers/MyController.lua` and add it to `ClientInit.client.lua`

### Adding a New Remote

Add it to `src/ReplicatedStorage/Modules/Shared/Remotes.lua` in either the `Events` or `Functions` table. Access from any script via `Remotes.GetEvent("name")` or `Remotes.GetFunction("name")`.

### Keybinds

| Key | Action |
|-----|--------|
| E | Hatch Eggs |
| I | Inventory |
| B | Build Mode |
| H | Heist |
| T | Trade |
| L | Leaderboard |

---

## 8. What's NOT Built Yet (Phase 3 — Future)

These were in the original spec but are not implemented:

- **Events system**: Coachella Festival (weekly), Desert Night Market, Sandstorm Chase
- **LiveOps**: Featured eggs, limited-time icons, seasonal content rotation
- **Analytics/Telemetry**: Player behavior tracking, A/B testing framework
- **Custom 3D assets**: Everything currently uses code-built placeholder geometry
- **Icon images**: Collectibles show as colored circles with text, not actual artwork
- **Thumbnail / marketing**: Game icon, thumbnails, description copy

---

## 9. Testing Checklist

Before launching, verify each system works end-to-end:

- [ ] Server boots with all 9 services showing checkmarks
- [ ] Player data saves and loads across sessions (publish to private place first)
- [ ] Each egg tier hatches correctly and deducts the right DC amount
- [ ] Evolution consumes correct number of dupes and applies multiplier
- [ ] Passive income ticks every 10 seconds at correct rates
- [ ] Heist flow completes: target selection -> countdown -> lockpick -> icon transfer
- [ ] Heist anti-grief: cooldowns, daily limits, newbie shield, vault protection all work
- [ ] Plot assignment on join, furniture placement, grid snapping, display pedestals
- [ ] Trading: request -> accept -> offer icons/DC -> double confirm -> transfer with 5% tax
- [ ] All 6 game passes purchased and benefits applied
- [ ] All 7 dev products purchased and delivered (check receipt idempotency)
- [ ] Leaderboard data populates and physical boards update
- [ ] Settings (volume, notifications) persist across sessions
- [ ] 100-player server doesn't hit performance issues (profile with MicroProfiler)
- [ ] DataStore session locking prevents data corruption on server-hop
- [ ] Rate limiting blocks spam (try rapid-firing hatch requests)

---

## 10. File-by-File Summary (34 Lua files)

| # | File | Lines | Purpose |
|---|------|-------|---------|
| 1 | `Constants.lua` | ~230 | Every tunable value in the game |
| 2 | `Remotes.lua` | ~70 | Creates all RemoteEvents/Functions |
| 3 | `Signal.lua` | ~80 | Custom event system |
| 4 | `Util.lua` | ~90 | Utility functions |
| 5 | `PlayerDataTemplate.lua` | ~80 | Player save schema |
| 6 | `IconDatabase.lua` | ~280 | 50 collectible icons |
| 7 | `FurnitureDatabase.lua` | ~320 | 52 furniture items |
| 8 | `GameInit.server.lua` | ~40 | Server bootstrap |
| 9 | `DataService.lua` | ~350 | DataStore v2 + session locking |
| 10 | `WorldService.lua` | ~550 | Procedural world generation |
| 11 | `EggService.lua` | ~250 | Hatching + evolution + passive income |
| 12 | `HeistService.lua` | ~350 | Full heist system |
| 13 | `PlotService.lua` | ~400 | Plots + furniture + displays |
| 14 | `TradeService.lua` | ~350 | P2P trading + marketplace |
| 15 | `MonetizationService.lua` | ~250 | Passes + products + Premium |
| 16 | `LeaderboardService.lua` | ~200 | OrderedDataStore boards |
| 17 | `SettingsService.lua` | ~80 | Settings validation |
| 18 | `RateLimiter.lua` | ~60 | Rate limiting module |
| 19 | `ClientInit.client.lua` | ~50 | Client bootstrap |
| 20 | `DataController.lua` | ~120 | Client data cache |
| 21 | `EggController.lua` | ~60 | Hatch/evolve requests |
| 22 | `HeistController.lua` | ~100 | Client heist flow |
| 23 | `PlotController.lua` | ~120 | Build mode + preview |
| 24 | `TradeController.lua` | ~120 | Trade session wrappers |
| 25 | `UIController.lua` | ~300 | Master UI + HUD + action bar |
| 26 | `VFXController.lua` | ~180 | Particle effects + camera shake |
| 27 | `SoundController.lua` | ~180 | Sound library + auto-hooks |
| 28 | `UIHelpers.lua` | ~200 | Shared UI theme + builders |
| 29 | `EggHatchUI.lua` | ~200 | Egg hatching panel |
| 30 | `InventoryUI.lua` | ~350 | Inventory/Collection/Vault |
| 31 | `HeistUI.lua` | ~300 | Heist UI panels |
| 32 | `TradeUI.lua` | ~250 | Trade window |
| 33 | `BuildUI.lua` | ~250 | Build mode catalog |
| 34 | `LeaderboardUI.lua` | ~150 | Leaderboard viewer |

---

**Bottom line:** The code is done. Your developer needs to: (1) sync into Studio via Rojo, (2) create game passes and dev products on the Creator Dashboard and plug in the real IDs, (3) replace placeholder sound IDs, (4) add real 3D models and icon artwork to replace the placeholder geometry, and (5) playtest thoroughly before going public.
