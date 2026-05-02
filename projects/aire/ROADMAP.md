# J9-AiRE — 30-Day Sprint Roadmap
**Sprint Start:** March 19, 2026
**Ship Date:** ~April 18, 2026
**Customer #1:** Janine Stevens (top 1% luxury realtor, Palm Springs)
**Scale Target:** 10,000 real estate agents nationwide

---

## The Product (What We're Building)

A full-featured AI relationship platform for luxury real estate agents. When Janine (or any agent) gets this product, it:

- Shows all their clients on their phone with smart follow-up alerts
- Answers their phone in their voice using AI
- Sends texts and emails for them, in their voice
- Imports all their existing contacts from any CRM or spreadsheet
- Integrates with MLS for live property listings (premium add-on)
- Sends auto-personalized messages for birthdays, anniversaries, milestones
- Generates branded market reports for their farm areas
- Gives them a daily brief of who needs attention

This is a complete product. Not a demo. Not an MVP. A car with all its parts.

---

## WEEK 1 — The Foundation (March 19–27)
*Get the dashboard working on a phone screen with real client data.*

- [x] Backend API (Memory Vault) — client CRUD, interactions, milestones
- [x] Database schema (Supabase) — deployed
- [x] n8n automation workflows — daily follow-up + milestone alerts
- [ ] **Frontend scaffold** — Next.js 15 + Tailwind + shadcn/ui
- [ ] **Auth system** — Supabase Auth, one login per agent, data scoped to account
- [ ] **Client dashboard** — mobile-first list, search, engagement indicators
- [ ] **CSV import tool** — upload contacts from any spreadsheet or CRM export
- [ ] Connect frontend to backend API

---

## WEEK 2 — The Brain (March 28–April 3)
*Make it intelligent. The AI does the work.*

- [ ] AI communication drafting — OpenAI generates messages in agent's voice
- [ ] ElevenLabs voice clone — trained on agent's writing style
- [ ] Twilio phone integration — AI answers calls, takes messages, books appts
- [ ] Email + SMS sending — Resend + Twilio, agent approves before send
- [ ] Follow-up engine — system knows who to contact and when

---

## WEEK 3 — The Muscle (April 4–10)
*Power features that justify the monthly price.*

- [ ] Auto-send birthday/anniversary/milestone messages
- [ ] Dormant client alerts — 60-day silence triggers notification
- [ ] MLS integration — live listing data per agent's market area (add-on)
- [ ] Branded market reports — auto-generated, agent's logo and colors
- [ ] Interaction timeline per client — full history at a glance

---

## WEEK 4 — The Polish (April 11–18)
*Bulletproof it. Then hand it to Janine.*

- [ ] Full test suite — every feature tested, break it on purpose and fix it
- [ ] Mobile optimization pass — every screen perfect on iPhone
- [ ] Multi-tenant validation — data isolation between agents confirmed
- [ ] Janine onboarding — import her contacts, configure her voice, walk through
- [ ] Launch — product is live, Janine is using it

---

## Pricing

| Tier | Price | What's Included |
|------|-------|----------------|
| **Essential** | $1,500/mo | Memory Vault + Dashboard + Import |
| **Signature** | $3,000/mo | Everything + AI Voice + Auto-messaging |
| **Legacy** | $5,000/mo | Everything + MLS + Market Reports + Priority Support |

Janine is on **Signature** ($3,000/mo).

---

## Tech Stack

| Layer | Tool | Why |
|-------|------|-----|
| Frontend | Next.js 15 + Tailwind + shadcn/ui | Industry standard SaaS stack; mobile-first; massive ecosystem |
| Backend | Node.js + TypeScript + Express | Already built; clean API |
| Database | Supabase (PostgreSQL) | Scales to 10K+ agents; built-in auth; RLS for data isolation |
| Auth | Supabase Auth | Zero extra infra; multi-tenant ready |
| Hosting | Vercel (FE) + Railway (BE) | Vercel pairs with Next.js; Railway is simple and reliable |
| AI/Voice | OpenAI + ElevenLabs | Best voice cloning available; OpenAI for intelligent drafting |
| Phone | Twilio | Industry standard; every real phone system uses it |
| Email/SMS | Resend + Twilio | Resend is modern, reliable; Twilio handles SMS |

---

## Decision Log

| Date | Decision | Reason |
|------|----------|--------|
| Mar 21, 2026 | Next.js 15 for frontend | SaaS industry standard; Zillow/Redfin-class tooling |
| Mar 21, 2026 | Supabase Auth for login | Already using Supabase DB; zero extra infra |
| Mar 21, 2026 | shadcn/ui for components | Saves 2 weeks of UI work; accessible; premium look |
| Mar 21, 2026 | ElevenLabs for voice | Best voice cloning on market; used by enterprise comms platforms |
| Mar 21, 2026 | Resend over SendGrid | Modern API; better deliverability; built by ex-SendGrid team |
