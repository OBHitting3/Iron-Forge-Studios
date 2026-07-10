# Repository Migration — Iron Forge Studios SSO

**Status:** In progress  
**Target repo:** [iron-forge-studios](https://github.com/obhitting3/iron-forge-studios)  
**Branch:** `cursor/monorepo-consolidation-754d`

## Migration Map

| Legacy repo | Status | New location |
|-------------|--------|--------------|
| `Content_Shield` | Migrated | `apps/content-shield/` + `apps/leadlatch/` |
| `joshua7` | **Do not migrate** — superseded by Content Shield | Archive only |
| `Gemini-discovers-Diamonds` | Partially migrated | `apps/roblox/palm-springs-life-sim/` (game only) |
| `Faceless_Shorts` | Migrated | `apps/faceless-shorts/` |
| `yt-autopilot` | **Do not migrate** — broken prototype | Archive only |
| `55-_AI_Intergration` | Migrated | `apps/ai-bridge/`, `apps/family-vault/`, `apps/karl-twin/` |
| `FreeLance` | **Do not migrate** — empty placeholder | Archive only |
| `iron-forge-studios` (old layout) | Restructured | Root `README.md`, `docs/`, `apps/` |

## What was intentionally left behind

- `joshua7` — early Flask MVP, superseded
- `yt-autopilot` — syntactically broken monolith
- `Gemini-discovers-Diamonds/content-shield/` — stub validators; canonical code is in `apps/content-shield/`
- `Gemini-discovers-Diamonds/server.js` — unrelated Express test harness
- Marketing/promo docs from Faceless_Shorts (~20 files)
- `FreeLance` — no code

## Archiving old repos (manual step on GitHub)

For each retired repo:

1. Ensure final README points to this monorepo path (see `archive/README.md`)
2. GitHub → Settings → Archive repository
3. Do not delete — preserves history and links
