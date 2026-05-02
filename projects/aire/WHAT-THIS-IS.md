# J9-AiRE — What This Is (Plain English)

## The One-Sentence Version

J9-AiRE is an app that manages a luxury real estate agent's client relationships
using AI — it remembers every client, tells the agent who to call, drafts messages
in their voice, and never lets anyone fall through the cracks.

## Who It's For

Luxury real estate agents who have 200+ high-value clients and can't keep track
of all of them manually. The first customer is Janine Stevens — a top 1% agent in
Palm Springs who has represented Nike's Phil Knight and Eagles co-founder Glenn Frey.

## What It Does Today (March 22, 2026)

1. **Client Dashboard** — Mobile-first. Shows all your clients on your phone with
   color-coded engagement indicators (green = active, yellow = warm, red = cold).

2. **Contact Import** — Upload a CSV from Google Contacts, iPhone, KVCore, Follow
   Up Boss, Top Producer, or any spreadsheet. It auto-maps the columns and imports
   everything.

3. **Client Profiles** — Tap any client to see everything: contact info, spouse,
   kids, pets, birthday, interests, property preferences, interaction history,
   milestones, and past transactions.

4. **Follow-Up Alerts** — The app knows who's overdue for contact and shows a red
   banner at the top of the dashboard.

5. **Interaction Logging** — After a call or meeting, tap "Log Interaction" on the
   client's profile. Pick the type (call/email/text/meeting/note), write a quick
   summary, and it's saved forever.

6. **Multi-Agent Security** — Each agent only sees their own clients. The login
   system verifies identity and every database query is scoped to that agent.

7. **Input Validation** — The API rejects bad data. You can't create a client
   without a name, can't log an interaction with an invalid type, can't create a
   transaction without an address.

## What It Does NOT Do Yet

- **AI messaging** — It doesn't draft messages in the agent's voice yet (Week 2)
- **Phone answering** — It doesn't answer calls yet (Week 2)
- **Auto-sending** — It doesn't automatically send birthday/anniversary messages yet (Week 3)
- **MLS integration** — It doesn't pull live listing data yet (Week 3)
- **Market reports** — It doesn't generate branded reports yet (Week 3)

## The Money

| Tier | Price | What's Included |
|------|-------|----------------|
| Essential | $1,500/mo | Dashboard + Import + Follow-up Alerts |
| Signature | $3,000/mo | Everything + AI Voice + Auto-messaging |
| Legacy | $5,000/mo | Everything + MLS + Market Reports + Priority Support |

Janine is on Signature ($3,000/mo). The product replaces two underperforming
assistants (~$80K–$120K/year combined) for $36K/year.

## The Tech (For Developers)

- **Frontend:** Next.js 16 + React 19 + Tailwind CSS (hosted on Vercel)
- **Backend:** Node.js + Express + TypeScript (hosted on Railway)
- **Database:** Supabase (PostgreSQL with Row Level Security)
- **Auth:** Supabase Auth (JWT tokens, one login per agent)
- **AI (coming):** OpenAI (message drafting) + ElevenLabs (voice cloning)
- **Phone (coming):** Twilio
- **Email/SMS (coming):** Resend + Twilio
