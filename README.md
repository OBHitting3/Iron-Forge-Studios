# Iron Forge Studios — Single Source of Truth

All Iron Forge Studios products live in this monorepo. The 8 legacy GitHub repos are being retired; do not develop in them.

## Product Map

| Product | Path | Stack | Quick start |
|---------|------|-------|-------------|
| **Content Shield** (Joshua 7) | [`apps/content-shield/`](apps/content-shield/) | Python, FastAPI | `cd apps/content-shield && pip install -e ".[dev]" && joshua7 serve` |
| **LeadLatch** | [`apps/leadlatch/`](apps/leadlatch/) | Next.js, Supabase | `cd apps/leadlatch/web && npm install && npm run dev` |
| **Faceless Shorts** | [`apps/faceless-shorts/`](apps/faceless-shorts/) | Python, MoviePy | `cd apps/faceless-shorts && pip install -r requirements.txt && python scripts/run_pipeline.py "topic"` |
| **AI Bridge Sync** | [`apps/ai-bridge/`](apps/ai-bridge/) | Next.js, TypeScript | `cd apps/ai-bridge && npm install && npm run dev` |
| **Family Vault** | [`apps/family-vault/`](apps/family-vault/) | Next.js, Ollama | `cd apps/family-vault && npm install && npm run dev` |
| **karl-twin** | [`apps/karl-twin/`](apps/karl-twin/) | Python, LangGraph | `cd apps/karl-twin && pip install -r requirements.txt` |
| **Prompt Forge** | [`apps/prompt-forge/`](apps/prompt-forge/) | Static HTML | Open `apps/prompt-forge/index.html` in a browser |
| **Roblox: Steal the Oasis** | [`apps/roblox/steal-the-oasis/`](apps/roblox/steal-the-oasis/) | Luau, Rojo v7 | `cd apps/roblox/steal-the-oasis && rojo serve` |
| **Roblox: Life Sim** | [`apps/roblox/palm-springs-life-sim/`](apps/roblox/palm-springs-life-sim/) | Luau, Rojo v7 | `cd apps/roblox/palm-springs-life-sim && rojo serve` |

## Docs

- [Portfolio analysis](docs/portfolio/MARKET-ANALYSIS.md)
- [Weekly activity summary](docs/portfolio/WEEKLY-ACTIVITY-SUMMARY.md)
- [Steal the Oasis architecture](docs/architecture/steal-the-oasis.md)
- [Repo migration guide](docs/portfolio/REPO-MIGRATION.md)

## Retired Repos

See [`archive/README.md`](archive/README.md) for the list of archived GitHub repos and where each product moved.

## Structure

```
apps/           Deployable applications (one folder per product)
docs/           Portfolio and architecture documentation
archive/        Pointers to retired repos
tooling/        Shared CI and deploy configs (future)
```
