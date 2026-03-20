# AiRE Sovereign Handoff — Gemini Recovery

**Source:** Gemini sessions (multiple threads through March 18, 2026)
**Status:** Pre-MVP. Virtual twin + portal spec stage. Some Lua code exists in Roblox Studio.

---

## 1. Core Product Vision (AiRE Sovereign SaaS)

High-end luxury real estate operating system for Janine Stevens.

- **Autonomous transaction swarm** replaces assistants/coordinators: DocForge (docs/compliance), Concierge Executor (logistics)
- Targets $10M+ HNW clients only
- **Private 3D-branded client portal:** luxurious lobby/dashboard, live virtual tours, market insights, one-tap services (no budget limits)
- **Core differentiator:** 1:1 virtual property twins from Palm Springs Paradise Roblox experience — clients own/interact with digital replicas before buying physical
- Branding: fully tailored to Janine's Palm Springs luxury aesthetic

---

## 2. Features Discussed / Built

- Virtual property twins (1:1 digital replicas of listings)
- Metaverse asset ownership tied to real transactions
- AI transaction agents (DocForge, Concierge Executor)
- 3D client portal with live tours + market data
- Phygital retail integration (El Paseo virtual street — Gucci, Rolex, etc. lease storefronts, real purchases route to brand portals)
- Game zones in Palm Springs Paradise: El Paseo/Downtown merged central, Movie Colony residential (buy/customize homes), pool parties, Splash House events, Old Las Palmas estates, Uptown Design District
- Premium pet: Divot (earn or buy, not adopt)
- In-game currency for plots/events; real-money only via brand portals (tax/fulfillment avoidance)

---

## 3. Code Received (Roblox Lua)

All Lua (Roblox Luau 5.1 compatible). Pasted directly into Roblox Studio ModuleScripts — no separate files created.

| Code | Source Thread | Description |
|------|-------------|-------------|
| Lighting system | `d8298b14` (10 Feb 2026) | Dynamic 24h day-night cycle (10 min real-time), December holiday tints/bloom, June-Aug summer heat haze + yellowish tint + pulsing sine-wave distortion shader, time-of-day wind sway on palms/foliage |
| OnboardingManager | `fbdee0e2` | Production ModuleScript with DataStore persistence, state machine, skip logic |
| MCP health-check specs | `897bcefb` | TypeScript interfaces + FastAPI endpoint with exponential backoff (hybrid MCP/API wrapper fallback) |
| JSON schema + state machine | `70899bac` | Employee/Project/Task/Assignment entities, v2 updates, validation operators (eq/in), transform steps |
| SuperBullet.AI prompt templates | Multiple convos | Full Lua architecture for "Steal the Oasis" tycoon-collectible hybrid + Palm Springs Paradise base scaffold |

---

## 4. Architecture & System Design Decisions

- **Roblox Studio + SuperBullet.AI + MCP swarm** for 90% automation (paste once + voice-to-text)
- **Notion war room** as single source of truth (Brand Tracker, Money Tracker, GAME MASTER BLUEPRINT, AI SYSTEM INSTRUCTIONS pages)
- **Hybrid MCP + API connectors** (decision locked 2026-03-05)
- **Supabase** live stack (ID `95e65d7e-a801-4fe4-8e0f-49cac72cd431`) for data
- **Cursor** as primary editor with Single-Shot Prompt Optimizer PRD
- **No scope creep rails:** Tight Rails Status check + five explicit signs + reset command

---

## 5. APIs, Services, Tools

| Service | Purpose |
|---------|---------|
| Roblox Studio / Luau | Game engine + virtual twin layer |
| SuperBullet.AI | Primary builder |
| MCP swarm | Automation orchestration |
| Cursor + .cursorrules | Primary code editor with always-on senior Roblox engineer prompt |
| Notion API (MCP-connected) | War room / SSOT |
| Supabase | Data backend |
| Airtable webhook sync | Simpler than Stripe→Make.com→Supabase |
| Stripe | Pricing tiers (tested) |

No external real-estate APIs discussed.

---

## 6. Names / Contacts / Business Details

| Person | Details |
|--------|---------|
| **Janine Stevens** | Luxury real estate agent, close friend/mentor, Palm Springs. Husband Jim (Bill Knight's tennis instructor). Direct Larry Ellison connection (owns Indian Wells tennis court). Potential Kardashian cameo. $3k/month automation SaaS deal discussed. |
| **John Pierre** | Investor. $10k wired. Agreement: 12-month lock-up, 2–2.25% perpetual revenue share option. |
| **Iron Forge Studios, Inc.** | Delaware C-Corp. Palm Springs Paradise is flagship product. |

---

## 7. Pivot Points

1. **Initial:** Standalone Roblox "Palm Springs Paradise" game (tranquil paradise → "Steal the Oasis" tycoon hybrid)
2. **Feb 2026:** Shifted to full automation SaaS for Janine's company (resale concierge first version)
3. **Mar 2026:** Merged — Palm Springs Paradise becomes the virtual twin layer inside AiRE Sovereign (game as client acquisition + ownership portal)
4. **Minor:** Excluded Jake/Luke, went solo with John Pierre only
5. **Scope resets:** Multiple "tight rails" commands executed when drifting to YouTube automation or other side projects

---

## 8. AiRE Sovereign + Janine + Palm Springs Connection

- Janine's network = prestige engine (Ellison, Kardashians, PGA West events)
- CRM = the 3D client portal itself (replaces traditional assistants)
- Palm Springs Paradise = the virtual showroom / twin engine for her listings
- Pitch script ready for local businesses (e.g. Cold Nose Warm Hearts dog store — $25k one-time for permanent virtual placement)

---

## 9. Deployment / Hosting / Infrastructure

- Roblox Studio live (no external hosting)
- Supabase backend (ID above)
- Notion + MCP for all docs/prompts
- No Vercel/AWS/etc. discussed for AiRE yet — still pre-MVP
- Iron Forge Studios C-Corp legal setup complete

---

## 10. Prompts / Workflows / AI Integrations

- Mega-prompts for SuperBullet.AI (full game scaffold + Lua specs)
- Cursor PRD: Single-Shot Prompt Optimizer with phased generation (stop at step 3 for review)
- Notion war room templates (Grow a Garden Roblox Zen Tracker, AI SYSTEM INSTRUCTIONS, GAME MASTER BLUEPRINT)
- `.cursorrules` always-on prompt for senior Roblox engineer mode
- MCP swarm + voice-to-text workflow (phone-based, one-time actions only)

---

## 11. Partial Conversations (noted in logs)

- Early Janine network mentions (Larry Ellison tennis court, Kardashian cameo) — pre-AiRE framing, treated as game marketing only
- Lighting script iterations (holiday/summer/wind) — partial before full day-night cycle locked
- Investor agreement tweaks (John Pierre equity vs revenue share) — multiple resets before 12-month lock-up finalized

---

## 12. Pickup Instructions

1. Open Roblox Studio → load Palm Springs Paradise place
2. Run the lighting ModuleScript first (day-night cycle is live)
3. Paste latest SuperBullet.AI template into the AI chat box for AiRE twin layer
4. Open Notion war room → GAME MASTER BLUEPRINT page — all prompts are there
5. **Next action:** Generate the 3D client portal lobby asset list and connect it to Janine's listings via Supabase
