# J9-AiRE — Deploy Guide

This gets the app live on the internet in about 20 minutes. You need three
accounts: Supabase (database), Railway (backend), and Vercel (frontend). All
three have free tiers that work fine for getting started.

---

## Step 1: Supabase (The Database) — 5 minutes

You may already have this set up. If so, skip to the migration step.

1. Go to https://supabase.com and sign in
2. Open your project (or create one called `j9-aire`)
3. Go to **SQL Editor** (left sidebar)
4. Paste the contents of `j9-app/supabase/migrations/001_memory_vault.sql` and click **Run**
5. Then paste the contents of `j9-app/supabase/migrations/002_add_agent_id.sql` and click **Run**
6. Go to **Settings → API** and copy these three values (you'll need them next):
   - Project URL (looks like `https://abc123.supabase.co`)
   - `anon` public key
   - `service_role` secret key

### Create a Login for Janine (or yourself for testing)

1. Go to **Authentication → Users** in Supabase
2. Click **Add User** → **Create New User**
3. Enter an email and password
4. That's the login for the dashboard

---

## Step 2: Railway (The Backend API) — 5 minutes

1. Go to https://railway.com and sign in with GitHub
2. Click **New Project → Deploy from GitHub Repo**
3. Select the `Iron-Forge-Studios` repo
4. Railway will ask which directory — set **Root Directory** to `projects/aire/j9-app`
5. Go to the **Variables** tab and add these:

   | Variable | Value |
   |----------|-------|
   | `SUPABASE_URL` | Your Supabase Project URL from Step 1 |
   | `SUPABASE_ANON_KEY` | Your anon key from Step 1 |
   | `SUPABASE_SERVICE_KEY` | Your service_role key from Step 1 |
   | `NODE_ENV` | `production` |

6. Railway auto-detects Node.js and runs `npm run build && npm start`
7. Once deployed, go to **Settings → Networking → Generate Domain**
8. Copy your Railway URL (looks like `https://j9-aire-production-abc123.up.railway.app`)
9. Test it: visit `https://your-railway-url/api/health` — you should see `{"ok":true}`

---

## Step 3: Vercel (The Frontend Dashboard) — 5 minutes

1. Go to https://vercel.com and sign in with GitHub
2. Click **Add New → Project → Import** your `Iron-Forge-Studios` repo
3. Set **Root Directory** to `projects/aire/j9-dashboard`
4. In **Environment Variables**, add:

   | Variable | Value |
   |----------|-------|
   | `NEXT_PUBLIC_SUPABASE_URL` | Your Supabase Project URL from Step 1 |
   | `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Your anon key from Step 1 |
   | `NEXT_PUBLIC_API_URL` | Your Railway URL from Step 2 |

5. Click **Deploy**
6. Vercel gives you a URL (looks like `https://j9-dashboard-abc123.vercel.app`)

---

## Step 4: Connect Supabase Auth to Vercel — 2 minutes

1. Go to Supabase → **Authentication → URL Configuration**
2. Set **Site URL** to your Vercel URL from Step 3
3. Add your Vercel URL to **Redirect URLs** (add both with and without trailing slash)

---

## Step 5: Test It

1. Open your Vercel URL on your phone
2. Log in with the email/password you created in Step 1
3. You should see the empty dashboard with an "Import" button
4. Import a CSV of contacts
5. Tap a client → you should see their full profile
6. Tap "Log Interaction" → fill it out → save
7. Go back to dashboard → the interaction count should update

---

## If Something Goes Wrong

**"I see a blank page"**
→ Check that all three Vercel environment variables are set correctly. Redeploy after changing them.

**"I can't log in"**
→ Make sure you created a user in Supabase Authentication, and that the Site URL matches your Vercel URL.

**"Clients aren't loading"**
→ Check that the Railway backend is running (visit /api/health). Check that NEXT_PUBLIC_API_URL points to the Railway URL.

**"Import worked but I see no clients"**
→ The agent_id filtering means clients must be associated with your user. Make sure migration 002 has been run and you're logged in.

---

## Environment Variables Cheat Sheet

### Backend (Railway)
```
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=eyJhbGci...
SUPABASE_SERVICE_KEY=eyJhbGci...
NODE_ENV=production
```

### Frontend (Vercel)
```
NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGci...
NEXT_PUBLIC_API_URL=https://your-railway-url.up.railway.app
```
