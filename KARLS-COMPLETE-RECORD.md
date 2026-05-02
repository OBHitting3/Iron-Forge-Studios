# Karl's Complete Record — Iron Forge Studios
## Everything That Exists, What It Does, What Works, What Doesn't

**Generated:** March 22, 2026
**Purpose:** One document with EVERYTHING so Karl can see the full picture,
save it somewhere safe, and decide what stays and what goes.

---

# PART 1: THE BIG PICTURE

## What Karl Has Built (The Truth)

Karl started learning to code in June 2025. In less than a year, he:
- Founded Iron Forge Studios, Inc. (Delaware C-Corp)
- Designed a complete AI relationship platform for luxury real estate
- Got a real customer (Janine Stevens) who said yes
- Got an investor (John Pierre, $10K wired)
- Built a Roblox game prototype
- Built a content detection tool (Content Shield)
- Set up Supabase, GitHub, multiple AI tools, MCP servers

What he does NOT have yet: a deployed, working app anyone can use on their phone.

## What Exists on GitHub

### Repo 1: Iron-Forge-Studios
**URL:** github.com/OBHitting3/Iron-Forge-Studios
**Status:** This is the main repo. Everything got jammed in here.

**Branches:**
- `master` — base branch
- `claude/cleanup-document-repos-3Pi6R` — current working branch (all recent work)
- `claude/palm-springs-game-foundation-BFruU` — Roblox game scaffold
- `claude/plan-document-preservation-mr7uE` — planning branch
- `claude/review-projects-market-analysis-Uagyy` — investor market analysis
- `claude/weekly-activity-summary-nEI31` — old activity tracking

### Repo 2: Content_Shield
**URL:** github.com/OBHitting3/Content_Shield
**Status:** 27 branches. AI content detection tool. On hold.

### Other Repos
Karl may have additional repos on GitHub. To see them all:
Go to https://github.com/OBHitting3?tab=repositories

---

# PART 2: WHAT'S INSIDE IRON-FORGE-STUDIOS

## File Tree (Everything)

```
Iron-Forge-Studios/
├── CLAUDE.md                    ← Instructions for Claude AI sessions
├── README.md                    ← Overview of all projects
├── KARLS-COMPLETE-RECORD.md     ← THIS FILE
│
├── docs/
│   ├── generate-map.py          ← Script to make system map
│   ├── system-map.png           ← Visual map of all repos
│   └── recon-prompts/           ← Prompts to paste into different AI tools
│       ├── paste-into-CURSOR.md
│       ├── paste-into-TERMINAL.md
│       ├── paste-into-VSCODE.md
│       └── paste-into-WINDSURF.md
│
└── projects/
    ├── aire/                          ← THE JANINE APP (active sprint)
    │   ├── AUDIT-PACK.md              ← Full history from all AI conversations
    │   ├── DEPLOY.md                  ← How to deploy (Supabase + Railway + Vercel)
    │   ├── HANDOFF-CLAUDE.md          ← Product spec (6 modules, pricing, customer)
    │   ├── HANDOFF-SUPERGROK.md       ← SuperGrok vision (virtual twins, Roblox merge)
    │   ├── ROADMAP.md                 ← 30-day sprint plan
    │   ├── SELLING-THIS.md            ← Sales playbook for Karl
    │   ├── WHAT-THIS-IS.md            ← Plain English product description
    │   │
    │   ├── j9-app/                    ← BACKEND (Express + TypeScript)
    │   │   ├── package.json
    │   │   ├── tsconfig.json
    │   │   ├── railway.json           ← Railway deployment config
    │   │   ├── .env.example           ← Environment variable template
    │   │   ├── SETUP.md               ← Local setup instructions
    │   │   ├── src/
    │   │   │   ├── index.ts           ← App entry point (Express server)
    │   │   │   ├── api/clients.ts     ← 14 API endpoints for client management
    │   │   │   ├── config/env.ts      ← Environment variable loader
    │   │   │   ├── db/supabase.ts     ← Database connection
    │   │   │   ├── middleware/auth.ts  ← JWT authentication
    │   │   │   ├── services/memory-vault.ts ← Business logic (13 functions)
    │   │   │   ├── types/client.ts    ← TypeScript type definitions
    │   │   │   └── validation/schemas.ts ← Input validation (Zod)
    │   │   ├── supabase/migrations/
    │   │   │   ├── 001_memory_vault.sql  ← Database tables (clients, interactions, milestones, transactions)
    │   │   │   └── 002_add_agent_id.sql  ← Multi-tenant isolation (NOT YET RUN)
    │   │   ├── docs/
    │   │   │   └── MEMORY-VAULT-SPEC.md  ← Massive spec (engagement scoring, state machine)
    │   │   └── n8n-workflows/
    │   │       ├── daily-followup-check.json  ← Daily Slack alert for follow-ups
    │   │       └── milestone-alerts.json      ← Birthday/anniversary alerts
    │   │
    │   └── j9-dashboard/              ← FRONTEND (Next.js 15 + Tailwind)
    │       ├── package.json
    │       ├── tsconfig.json
    │       ├── app/
    │       │   ├── layout.tsx         ← Root layout
    │       │   ├── page.tsx           ← Home (redirects to dashboard or login)
    │       │   ├── login/page.tsx     ← Login form
    │       │   ├── globals.css        ← Styles
    │       │   ├── auth/callback/route.ts ← Auth callback
    │       │   └── dashboard/
    │       │       ├── layout.tsx     ← Dashboard wrapper (auth guard, nav)
    │       │       ├── page.tsx       ← Main dashboard (client list + follow-up banner)
    │       │       ├── settings/page.tsx ← Settings page (placeholder)
    │       │       └── clients/
    │       │           ├── [id]/page.tsx  ← Individual client profile
    │       │           └── import/page.tsx ← CSV import page
    │       ├── components/
    │       │   ├── bottom-nav.tsx     ← Mobile bottom navigation
    │       │   ├── client-list.tsx    ← Client cards with search
    │       │   ├── csv-importer.tsx   ← CSV upload wizard (4 steps)
    │       │   ├── log-interaction.tsx ← Log a call/email/text/meeting
    │       │   └── top-bar.tsx        ← Header with sign-out
    │       ├── lib/
    │       │   ├── supabase/client.ts ← Browser Supabase client
    │       │   ├── supabase/server.ts ← Server Supabase client
    │       │   └── utils.ts          ← Helper functions
    │       ├── types/client.ts        ← Frontend type definitions
    │       └── proxy.ts              ← Dev proxy for API calls
    │
    ├── content-shield/                ← CONTENT SHIELD (on hold)
    │   └── README.md                  ← Placeholder, code is in separate repo
    │
    └── palm-springs-paradise/         ← ROBLOX GAME (on hold)
        ├── README.md
        └── src/                       ← Full Lua game scaffold
            ├── ARCHITECTURE.md
            ├── server/                ← 8 server services
            ├── client/                ← 6 client controllers
            └── shared/                ← Constants, utilities, databases
```

---

# PART 3: THE JANINE APP — HONEST STATUS

## What's Built

| Thing | Status | Works? |
|-------|--------|--------|
| Database schema (tables) | SQL written | Migration 001 may be run on Supabase. Migration 002 is NOT run. |
| Backend API (14 endpoints) | Code written | Never tested against real database. No tests exist. |
| JWT authentication | Code written | Depends on migration 002 which hasn't been run. |
| Frontend dashboard | Code written | Never deployed. Only works on localhost. |
| Login page | Code written | Never tested with real Supabase auth. |
| Client list view | Code written | Never seen with real data. |
| Client profile page | Code written | Never seen with real data. |
| CSV importer | Code written | Never tested with a real CSV file. |
| Log interaction form | Code written | Never tested. |
| Deployment (Railway) | Config written | NOT deployed. |
| Deployment (Vercel) | Config written | NOT deployed. |
| Tests | NONE | Zero tests written. |

## What's NOT Built

- AI message drafting (OpenAI)
- Voice clone (ElevenLabs)
- Phone answering (Twilio)
- Auto-sending messages
- MLS integration
- Market reports
- n8n workflows (written but not connected)

## Known Problems

1. **Migration 002 hasn't been run** — the agent_id column doesn't exist in the database yet, so all the auth/isolation code will crash
2. **Schema mismatch was fixed but never verified** — frontend types were changed to match backend, but nobody confirmed they actually work together
3. **No tests** — zero confidence that any of this works
4. **Nothing is deployed** — no URL exists, nobody can see this app
5. **Express version mismatch** — package.json says Express 4 but type definitions are for Express 5

---

# PART 4: THE PRODUCT SPEC (What the App Should Do)

## One Sentence
J9-AiRE manages a luxury real estate agent's client relationships using AI — it remembers every client, tells the agent who to call, drafts messages in their voice, and never lets anyone fall through the cracks.

## The Customer
**Janine Stevens** — Top 1% luxury realtor in Palm Springs. 37 years in business. Represented Phil Knight (Nike), Glenn Frey (Eagles), Kyle Richards. Her two assistants "basically do nothing." She wants to slow down without losing her business.

## The 6 Modules

1. **Memory Vault** — Knows everything about every client (names, families, deals, preferences)
2. **Voice Clone** — AI writes messages in Janine's voice
3. **Paperwork Engine** — Auto-generates real estate documents
4. **Market Intelligence** — Branded market reports for her communities
5. **Legacy Playbook** — Documents her 37 years of knowledge so it doesn't retire with her
6. **Trust Dashboard** — One screen that shows her everything she needs to know today

## Pricing

| Tier | Price | What's Included |
|------|-------|----------------|
| Essential | $1,500/mo | Memory Vault + Dashboard + Import |
| Signature | $3,000/mo | Everything + AI Voice + Auto-messaging |
| Legacy | $5,000/mo | Everything + MLS + Reports + Priority |

Janine is on Signature ($3,000/mo). Replaces two assistants ($80K-$120K/year) for $36K/year.

## Tech Stack (Approved)

| What | Tool |
|------|------|
| Frontend | Next.js 15 + Tailwind CSS + shadcn/ui |
| Backend | Node.js + TypeScript + Express |
| Database | Supabase (PostgreSQL) |
| Auth | Supabase Auth |
| Frontend hosting | Vercel |
| Backend hosting | Railway |
| AI messaging | OpenAI |
| Voice | ElevenLabs |
| Phone | Twilio |
| Email | Resend |
| SMS | Twilio |

---

# PART 5: BUSINESS DETAILS

## Iron Forge Studios, Inc.
- Delaware C-Corp
- Karl is sole founder

## Investor
- **John Pierre** — $10K wired
- 12-month lock-up
- 2-2.25% perpetual revenue share option

## Janine Stevens Contact
- Phone: 760-250-5953
- Brokerage: Bennion Deville Homes, La Quinta
- Relationship to Karl: 14-year mentorship, met at American Express Golf Tournament at PGA West
- Communities: The Hideaway, Madison Club, PGA West, Tradition, Andalusia, La Quinta Resort

## Products

| Product | Status | Location |
|---------|--------|----------|
| J9-AiRE (Janine app) | In development, nothing deployed | Iron-Forge-Studios repo |
| Content Shield (Joshua 7) | On hold | Content_Shield repo (27 branches) |
| Palm Springs Paradise | Prototype done, on hold | Iron-Forge-Studios repo + Roblox Studio |
| Prompt Forge | Built, one-page app | Was in Iron-Forge-Studios, may have been deleted |

---

# PART 6: THE ROBLOX GAME (Palm Springs Paradise)

Full Lua scaffold exists in `projects/palm-springs-paradise/src/`. Includes:
- 8 server services (data, world, eggs, heists, plots, trade, monetization, leaderboards)
- 6 client controllers
- 2048x2048 world with 7 themed zones
- Desert sunset skybox with day-night cycle
- Egg hatching system with rarity rolls
- Heist system with lockpick minigame
- Plot system (100 grid-based 32x32 plots)
- Trade system with marketplace
- 6 game passes, 7 dev products
- Full anti-cheat (server-authoritative)

**Connection to AiRE:** The SuperGrok vision was to merge PSP with AiRE — the game becomes a virtual showroom where clients can see 3D replicas of real listings before buying. This is ambitious and NOT built.

---

# PART 7: CONTENT SHIELD (Joshua 7)

AI content detection tool. Code lives in the separate `Content_Shield` repo on GitHub. Has 27 branches, which suggests a lot of experimentation happened. Currently on hold.

---

# PART 8: TOOLS AND SETUP

## What Karl Has Set Up

### AI Tools
- Claude Desktop (Max plan) with MCP servers
- Claude Code (CLI)
- Cursor (code editor)
- ChatGPT (research)
- SuperGrok (research + Roblox development)

### MCP Servers (from Claude Desktop screenshot, March 21, 2026)
| Server | Status |
|--------|--------|
| Control Chrome | Unknown |
| Filesystem | Unknown |
| Read and Write Ap... | Unknown |
| Figma | Unknown |
| AWS API MCP Server | Unknown |
| Control your Mac | Unknown |
| PDF Tools | Unknown |
| ToolUniverse | Unknown |
| Kapture Browser Automation | **FAILED — Server disconnected** |
| Desktop Commander | Unknown |
| Context7 | Unknown |
| Roblox_Studio | Unknown |

### Known Issue
Kapture Browser Automation is failed/disconnected. Other MCP servers may also have issues. Karl should go through each one and disable anything not actively needed.

### Services/Accounts
- **Supabase** — Database provisioned (project ID: 95e65d7e-a801-4fe4-8e0f-49cac72cd431)
- **GitHub** — OBHitting3 account
- **Vercel** — Account exists (not deployed)
- **Railway** — Account may exist (not deployed)
- **Twilio** — Account status unknown
- **OpenAI** — Account exists (used for ChatGPT, API status unknown)
- **ElevenLabs** — Account status unknown
- **Resend** — Account status unknown
- **Stripe** — Tested at some point

---

# PART 9: EVERY COMMIT EVER MADE (Chronological)

| Date | Author | What Was Done |
|------|--------|--------------|
| Feb 28, 2026 | Claude | Weekly activity summary (Feb 21-28) |
| Feb 28, 2026 | Claude | Updated Content Shield branch count (27) |
| Mar 10, 2026 | Claude | Built Prompt Forge (question-gated prompt builder app) |
| Mar 10, 2026 | Karl | Merged Prompt Forge PR |
| Mar 11, 2026 | Claude | Scaffolded Palm Springs Paradise Roblox game (full Lua codebase) |
| Mar 14, 2026 | Claude | Wrote investor market analysis for Content Shield + PSP |
| Mar 14, 2026 | Karl | Merged market analysis PR |
| Mar 20, 2026 | Claude | Wrote repo cleanup guide |
| Mar 20, 2026 | Claude | Rewrote cleanup guide in plain English |
| Mar 20, 2026 | Claude | Reorganized repo into projects/ structure |
| Mar 20, 2026 | Claude | Created CLAUDE.md |
| Mar 20, 2026 | Claude | Created system map and recon prompts |
| Mar 20, 2026 | Claude | Updated recon prompts |
| Mar 20, 2026 | Claude | Added AiRE audit pack (ChatGPT knowledge transfer) |
| Mar 20, 2026 | Claude | Added J9-AiRE handoff from Claude.ai |
| Mar 20, 2026 | Claude | Added AiRE Sovereign handoff from SuperGrok |
| Mar 20, 2026 | Claude | Fixed SuperGrok attribution |
| Mar 21, 2026 | Claude | Cleaned up repo (removed old docs, updated README) |
| Mar 21, 2026 | Claude | Cleaned up HANDOFF-CLAUDE.md |
| Mar 21, 2026 | Claude | Scaffolded j9-app backend (Memory Vault) |
| Mar 21, 2026 | Karl | Added Memory Vault spec |
| Mar 21, 2026 | Claude | Built j9-dashboard frontend (full Next.js app) |
| Mar 22, 2026 | Claude | Made backend deployment-ready (CORS, Railway config) |
| Mar 22, 2026 | Claude | Added auth, validation, schema fixes, interaction logging |
| Mar 22, 2026 | Claude | Wrote WHAT-THIS-IS, DEPLOY, SELLING-THIS docs |
| Mar 22, 2026 | Claude | Updated CLAUDE.md with Karl's patterns and session context |

---

# PART 10: WHAT TO DO NEXT (Karl's Decision)

## Option A: Burn It Down, Keep the Knowledge
1. Save this file somewhere safe (email it to yourself, put it in Google Docs, print it)
2. Save the spec docs that are good: HANDOFF-CLAUDE.md, WHAT-THIS-IS.md, SELLING-THIS.md, ROADMAP.md, MEMORY-VAULT-SPEC.md
3. Create a brand new repo for J9-AiRE (nothing else in it)
4. Build one piece at a time, verify each piece works before building the next
5. Archive Iron-Forge-Studios on GitHub (don't delete, just archive)

## Option B: Clean What's Here
1. Fix migration 002 (run it on Supabase)
2. Write tests for the backend
3. Deploy backend to Railway
4. Deploy frontend to Vercel
5. Verify end-to-end on phone
6. This is faster but carries forward any hidden problems

## Option C: Delete Everything
1. Don't do this. The knowledge in these docs is valuable.
2. The code might be throwaway, but the specs, the customer research, the pricing, the competitive analysis — that took real work and real thinking.
3. At minimum, save this file and the spec docs before deleting anything.

## Karl's MCP Cleanup (Do This Regardless)
1. Open Claude Desktop → Settings → Developer
2. For each MCP server: if you don't know what it does or aren't actively using it, disable it
3. Kapture Browser Automation is definitely broken — disable it
4. Keep only what you're actively using (probably: Filesystem, Context7, maybe Desktop Commander)
5. Fewer tools = fewer things that can break

---

# PART 11: THE HONEST ASSESSMENT

**What went wrong:** Claude kept building without verifying. No tests. No deployment. No proof anything works. Schema mismatches. Building features on top of a migration that hasn't been run. Telling Karl "it's fine" when it wasn't. Writing about Karl in CLAUDE.md like study notes instead of saving what Karl wanted saved.

**What's actually valuable:**
- The product spec (HANDOFF-CLAUDE.md) is solid
- The customer research is real — Janine is a real person who said yes
- The pricing model makes sense ($3K/mo replacing $80K-$120K/year in assistant costs)
- The competitive positioning is genuine (nobody else builds for winding-down agents)
- The tech stack is standard and well-supported
- The database schema is reasonable (needs verification)

**What's probably throwaway:**
- The frontend code (built too fast, never verified)
- The backend code (built too fast, never tested)
- The CLAUDE.md "patterns" section (written by Claude for Claude, not for Karl)
- The n8n workflows (never connected to anything)
- The recon prompts (one-time use, already used)

**The bottom line:** The THINKING is good. The BUILDING was sloppy. Start the build fresh with the good thinking as your foundation.
