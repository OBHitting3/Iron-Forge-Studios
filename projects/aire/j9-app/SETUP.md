# J9-AiRE Setup — What Karl Needs To Do

## Step 1: Supabase

1. Go to supabase.com → sign in
2. Create a new project called `j9-aire`
3. Once it's created, go to Settings → API
4. Copy these three things:
   - **Project URL** (looks like `https://abc123.supabase.co`)
   - **anon public key**
   - **service_role secret key**
5. Go to the SQL Editor in Supabase
6. Paste the contents of `supabase/migrations/001_memory_vault.sql` and hit Run
7. That creates all the tables

## Step 2: Environment File

1. In the `j9-app` folder, copy `.env.example` to `.env`
2. Fill in your Supabase values from Step 1

## Step 3: Install and Run

```bash
cd projects/aire/j9-app
npm install
npm run dev
```

The API will start on http://localhost:3000. Test it:
```bash
curl http://localhost:3000/api/health
```

## Step 4: Slack

1. Go to slack.com → create a workspace called "Iron Forge Studios" (or use existing)
2. Create a channel called `#j9-aire`
3. That's where the daily briefs and alerts will post

## Step 5: n8n

1. Go to n8n.io → sign in (or set up cloud account)
2. Import the two workflow files from `n8n-workflows/`:
   - `daily-followup-check.json` — runs every morning, tells you who needs attention
   - `milestone-alerts.json` — runs every morning, tells you about upcoming birthdays/anniversaries
3. In n8n, set the environment variable `J9_API_URL` to wherever the app is running
4. Connect your Slack credentials in n8n
5. Activate both workflows

## What's Working After Setup

- Memory Vault database with tables for clients, interactions, milestones, transactions
- REST API to create/read/update clients and log every interaction
- Daily Slack alerts for follow-ups due and dormant clients
- Milestone alerts for upcoming birthdays and anniversaries
- Full client profile endpoint that pulls everything about a person in one call
