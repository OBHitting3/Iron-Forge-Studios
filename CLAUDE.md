# Iron Forge Studios — Mission Briefing

## Read This First

You are working for Karl. Solo founder. Self-taught since June 2025.
He doesn't know jargon — explain everything in plain English.
Short sentences. No lectures. Build first, explain after.
Never be a yes-man. If something's broken, say so.

**Do NOT start building until you read the CURRENT TASK section below.**

---

## THE CURRENT TASK

> **Nothing moves forward until the foundation is verified.**

### Step 1: Verify the database (NOT DONE)
- Migration 001 may or may not have been run on Supabase
- Migration 002 has NOT been run
- SQL files are in `projects/aire/j9-app/supabase/migrations/`
- Karl must run these in Supabase SQL Editor — Claude cannot do this
- **If Karl hasn't run the migrations yet, STOP and tell him to do that first**

### Step 2: Verify the backend works (NOT DONE)
- Backend code is in `projects/aire/j9-app/`
- Zero tests exist. Write tests BEFORE doing anything else.
- Test against the real Supabase database
- Do not build new features until existing code is proven to work

### Step 3: Deploy backend (NOT DONE)
- Deploy to Railway
- Verify it responds to API calls from the internet
- Config file exists: `projects/aire/j9-app/railway.json`

### Step 4: Deploy frontend (NOT DONE)
- Frontend code is in `projects/aire/j9-dashboard/`
- Deploy to Vercel
- Verify it loads on a phone browser
- Verify it can talk to the deployed backend

### Step 5: THEN build new features
- Not before. No exceptions.

---

## RULES

1. **One thing at a time.** Finish step 1 before starting step 2.
2. **Verify before moving on.** "Code written" is not "done." Done means tested, deployed, and working.
3. **Every feature gets a test.** No exceptions.
4. **Commit often.** Small commits, clear messages.
5. **Don't touch what's on hold.** Content Shield and Palm Springs Paradise are parked. Leave them alone.
6. **Don't rewrite CLAUDE.md with personality notes.** This file is a task list, not a journal.
7. **When Karl gets frustrated, show him what's actually built.** Don't lecture. Don't motivate. Show the thing.
8. **When Karl has a new idea mid-session, write it in the Parking Lot section at the bottom. Then get back to the current task.**

---

## WHAT EXISTS (Verified Status)

| Thing | Code Written? | Tested? | Deployed? | Works? |
|-------|:---:|:---:|:---:|:---:|
| Database schema (migration 001) | Yes | Unknown | Unknown | Unknown |
| Multi-tenant isolation (migration 002) | Yes | No | No | No |
| Backend API (14 endpoints) | Yes | No | No | Unknown |
| JWT auth middleware | Yes | No | No | Unknown |
| Frontend dashboard | Yes | No | No | Unknown |
| Login page | Yes | No | No | Unknown |
| CSV importer | Yes | No | No | Unknown |
| Tests | No | - | - | - |

**Update this table as things get verified. Change "Unknown" to "Yes" or "No" with the date.**

---

## TECH STACK (Approved, Don't Change)

- **Frontend:** Next.js 15 + Tailwind CSS + shadcn/ui
- **Backend:** Node.js + TypeScript + Express
- **Database:** Supabase (PostgreSQL)
- **Auth:** Supabase Auth
- **Hosting:** Vercel (frontend) + Railway (backend)
- **AI/Voice (later):** OpenAI + ElevenLabs + Twilio

---

## DECISION AUTHORITY

- **Claude decides:** Tech choices, architecture, file structure, implementation approach
- **Claude asks Karl:** Anything that costs money, ships to customers, deletes data, or uses real API keys
- **When in doubt, ask.** One question, not five.

---

## THE PRODUCT (What We're Building)

**J9-AiRE** — AI relationship manager for Janine Stevens, luxury realtor in Palm Springs.

The app remembers every client, tells Janine who to call, drafts messages in her voice, and never lets anyone fall through the cracks. She's paying $3,000/month. It replaces two assistants that cost her $80K-$120K/year.

Full spec: `projects/aire/HANDOFF-CLAUDE.md`
Plain English description: `projects/aire/WHAT-THIS-IS.md`
Sales playbook: `projects/aire/SELLING-THIS.md`
Complete history: `KARLS-COMPLETE-RECORD.md`

---

## PARKING LOT (Ideas — Don't Build These Now)

- **Concept Capture App:** AI that learns Karl's thinking patterns. Real product, post-Janine. (March 22, 2026)

---

## HOW TO UPDATE THIS FILE

When you finish a step:
1. Update the status table above
2. Move to the next step in CURRENT TASK
3. Commit the updated CLAUDE.md

When Karl has a new idea:
1. Add it to the PARKING LOT section
2. Get back to the current task

Do NOT add personality notes, session recaps, or "how Karl works" sections.
That stuff lives in KARLS-COMPLETE-RECORD.md if it needs to live anywhere.
