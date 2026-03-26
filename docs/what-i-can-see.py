"""
WHAT CLAUDE CAN SEE — Hard facts only. No guesses.
Generates: what-i-can-see.png
"""
from PIL import Image, ImageDraw, ImageFont

W, H = 1600, 2400
img = Image.new("RGB", (W, H), "#0d0d0d")
draw = ImageDraw.Draw(img)

try:
    FB = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", 28)
    FH = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", 20)
    FM = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf", 17)
    FS = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf", 14)
    FT = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", 40)
except:
    FT = FB = FH = FM = FS = ImageFont.load_default()

# Colors
BG        = "#0d0d0d"
GREEN     = "#00c853"
RED       = "#ff1744"
YELLOW    = "#ffd600"
BLUE      = "#2979ff"
ORANGE    = "#ff6d00"
GRAY      = "#616161"
WHITE     = "#ffffff"
DIMWHITE  = "#b0b0b0"
DARKCARD  = "#1a1a1a"
GREENCARD = "#0a2a0a"
REDCARD   = "#2a0a0a"
BLUECARD  = "#0a0a2a"
ORANGECARD= "#2a1500"

def rr(x, y, w, h, r, fill, outline=None, ow=1):
    draw.rounded_rectangle([x, y, x+w, y+h], radius=r, fill=fill,
                            outline=outline, width=ow)

def txt(x, y, t, color=WHITE, font=FM):
    draw.text((x, y), t, fill=color, font=font)

def section_title(x, y, label, color=YELLOW):
    draw.text((x, y), label, fill=color, font=FB)
    draw.line([(x, y+34), (W-x, y+34)], fill=color, width=1)
    return y + 44

def fact_row(x, y, w, label, value, vcolor=WHITE, verified=True):
    rr(x, y, w, 30, 4, DARKCARD)
    icon = "✓" if verified else "?"
    ic   = GREEN if verified else YELLOW
    txt(x+8,  y+6, icon,  ic,     FS)
    txt(x+28, y+6, label, DIMWHITE, FS)
    txt(x+28+len(label)*8+10, y+6, value, vcolor, FS)
    return y + 36

# ── TITLE ──────────────────────────────────────────────────────────────────
rr(0, 0, W, 90, 0, "#111111")
txt(W//2 - 340, 10,  "WHAT CLAUDE CAN SEE RIGHT NOW", YELLOW, FT)
txt(W//2 - 280, 58,  "Hard facts from this terminal only. Nothing guessed.", GRAY, FM)

y = 110

# ══════════════════════════════════════════════════════════════════════════
# SECTION 1 — GIT REPO (100% verified)
# ══════════════════════════════════════════════════════════════════════════
y = section_title(40, y, "1.  GIT REPOSITORY  (I can see this directly)", GREEN)

rr(40, y, W-80, 220, 8, GREENCARD, GREEN, 1)
txt(60, y+10, "VERIFIED — I am sitting inside this repo right now.", GREEN, FH)

facts = [
    ("Repo name:",      "Iron-Forge-Studios",                     WHITE,  True),
    ("GitHub account:", "OBHitting3",                              ORANGE, True),
    ("Remote URL:",     "github.com/OBHitting3/Iron-Forge-Studios", WHITE, True),
    ("Current branch:", "claude/cleanup-document-repos-3Pi6R",     WHITE,  True),
    ("Other branch:",   "master",                                   WHITE,  True),
    ("Total commits:",  "30  (Feb 28 – Mar 26, 2026)",             WHITE,  True),
    ("2nd repo known:", "github.com/OBHitting3/Content_Shield  (27 branches — mentioned in files)", DIMWHITE, False),
    ("More repos?:",    "UNKNOWN — cannot see your GitHub account from here", YELLOW, False),
]
fy = y + 46
for label, val, vc, ver in facts:
    fact_row(60, fy, W-120, label, val, vc, ver)
    fy += 36
y = fy + 20

# ══════════════════════════════════════════════════════════════════════════
# SECTION 2 — FILES IN THIS REPO
# ══════════════════════════════════════════════════════════════════════════
y = section_title(40, y, "2.  FILES I CAN READ  (inside this repo)", GREEN)

col1_x, col2_x = 60, W//2 + 20
col_w = W//2 - 80

rr(col1_x, y, col_w, 340, 8, DARKCARD, GRAY, 1)
txt(col1_x+12, y+8, "BACKEND  (projects/aire/j9-app/)", GREEN, FH)
backend = [
    "src/index.ts          — Express server entry",
    "src/api/clients.ts    — 14 API endpoints",
    "src/middleware/auth.ts — JWT auth",
    "src/services/memory-vault.ts — DB logic",
    "src/config/env.ts     — env vars",
    "src/db/supabase.ts    — DB connection",
    "src/types/client.ts   — TypeScript types",
    "src/validation/schemas.ts — Zod validators",
    "supabase/migrations/001_memory_vault.sql",
    "supabase/migrations/002_add_agent_id.sql",
    "railway.json          — deploy config",
    ".env.example          — env template",
    "package.json          — Express 4 + TS 5",
]
for i, line in enumerate(backend):
    txt(col1_x+12, y+38+i*20, line, DIMWHITE, FS)

rr(col2_x, y, col_w, 340, 8, DARKCARD, GRAY, 1)
txt(col2_x+12, y+8, "FRONTEND  (projects/aire/j9-dashboard/)", GREEN, FH)
frontend = [
    "app/page.tsx           — redirect to login/dashboard",
    "app/login/page.tsx     — login form",
    "app/dashboard/page.tsx — main dashboard",
    "app/dashboard/clients/[id]/page.tsx",
    "app/dashboard/clients/import/page.tsx",
    "components/client-list.tsx",
    "components/csv-importer.tsx",
    "components/log-interaction.tsx",
    "components/top-bar.tsx / bottom-nav.tsx",
    "lib/supabase/client.ts + server.ts",
    "package.json   — Next.js 15 + Tailwind",
    ".env.local.example — env template",
    "",
]
for i, line in enumerate(frontend):
    txt(col2_x+12, y+38+i*20, line, DIMWHITE, FS)

y += 360

rr(40, y, W-80, 100, 8, DARKCARD, GRAY, 1)
txt(60, y+8, "ON HOLD  (in repo but not being built)", GRAY, FH)
txt(60, y+38, "projects/palm-springs-paradise/  — 24 Lua files, Roblox game scaffold, never deployed", DIMWHITE, FS)
txt(60, y+62, "projects/content-shield/         — placeholder README only, real code in separate repo", DIMWHITE, FS)
y += 120

# ══════════════════════════════════════════════════════════════════════════
# SECTION 3 — ACCOUNTS I CAN PROVE EXIST
# ══════════════════════════════════════════════════════════════════════════
y = section_title(40, y, "3.  ACCOUNTS I CAN PROVE EXIST  (from files + your screenshots)", GREEN)

accounts = [
    # (service, detail, source, color)
    ("GitHub",    "OBHitting3",                         "git remote URL in this repo",            GREEN),
    ("GitLab",    "ob.hitting.3.tv",                    "Cursor screenshot you sent me",          GREEN),
    ("Supabase",  "Project ID: 95e65d7e-a801-4fe4...",  "Referenced in HANDOFF docs + SETUP.md",  GREEN),
    ("Cursor",    "Workspace: Iron Forge  (Ultra plan)", "Cursor screenshot you sent me",          GREEN),
    ("Slack",     "Connected via Cursor",                "Cursor screenshot you sent me",          GREEN),
    ("Linear",    "Project: Palm Springs Paradise",      "Cursor screenshot you sent me",          GREEN),
    ("Google",    "ob.hitting.3.tv@gmail.com",           "Phone screenshot (Manage accounts)",     GREEN),
    ("Google",    "contact@ironforge.studio",            "Phone screenshot (Manage accounts)",     GREEN),
    ("Google",    "coachellavalleyresale@gmail.com",     "Phone screenshot (Manage accounts)",     GREEN),
    ("Google One","2 TB plan  (5.24 GB used)",           "Phone screenshot (Storage manager)",     GREEN),
    ("Domain",    "ironforge.studio  — owned, email works", "You confirmed this directly",        GREEN),
]

rr(40, y, W-80, len(accounts)*32+20, 8, GREENCARD, GREEN, 1)
for i, (svc, detail, source, color) in enumerate(accounts):
    ry = y + 10 + i*32
    rr(60, ry, 140, 24, 4, "#1a3a1a")
    txt(68, ry+4, svc, GREEN, FS)
    txt(210, ry+4, detail, WHITE, FS)
    txt(210+len(detail)*8+20, ry+4, f"← {source}", GRAY, FS)

y += len(accounts)*32 + 40

# ══════════════════════════════════════════════════════════════════════════
# SECTION 4 — WHAT I CANNOT SEE
# ══════════════════════════════════════════════════════════════════════════
y = section_title(40, y, "4.  WHAT I CANNOT SEE  (blank spots on the map)", RED)

rr(40, y, W-80, 320, 8, REDCARD, RED, 1)
txt(60, y+10, "I have NO access to any of these. You have to open them and tell me — or show me a screenshot.", RED, FH)

unknowns = [
    ("Apple ID",      "Which email?  obhitting3@icloud.com is possibly still there. Dead email is gone."),
    ("Vercel",        "Does an account exist? Which email? Nothing deployed."),
    ("Railway",       "Does an account exist? Which email? Nothing deployed."),
    ("Claude Max",    "Which email is the subscription on? You might have two."),
    ("ChatGPT",       "Which email? Could be any of your 5+ emails."),
    ("Cursor billing","You mentioned ob.hitting.3.tv, karl@det33.com, contact@ironforge.studio — which one pays?"),
    ("karl@det33.com","You mentioned this email. I have never seen it in any file. What is it? What's it for?"),
    ("2nd Mac login", "You said there are 2 Mac user accounts. What are the two usernames on the Mac?"),
    ("Content_Shield","27 branches. What email owns that GitHub account? Same OBHitting3?"),
            ("Other GitHub repos","You said 8 repos. I can only confirm 2. What are the others?"),
    ("Twilio",        "Does an account exist?"),
    ("ElevenLabs",    "Does an account exist?"),
            ("Stripe",        "Was tested once. Which email? Still active?"),
            ("n8n",           "Does an account exist?"),
    ("Notion",        "Setup failed with 401. Does the account still exist?"),
]

uy = y + 50
for svc, detail in unknowns:
    rr(60, uy, 160, 22, 4, "#3a0a0a")
    txt(68, uy+3, svc, RED, FS)
    txt(230, uy+3, detail, DIMWHITE, FS)
    uy += 28

y = uy + 20

# ══════════════════════════════════════════════════════════════════════════
# SECTION 5 — WHAT'S NEXT
# ══════════════════════════════════════════════════════════════════════════
y = section_title(40, y, "5.  WHAT FILLS THE BLANK SPOTS", YELLOW)

rr(40, y, W-80, 160, 8, "#1a1a00", YELLOW, 1)
txt(60, y+10, "For each blank spot above, you either:", YELLOW, FH)
steps = [
    "A)  Show me a screenshot  →  I read it and add it to the map",
    "B)  Open the app/website, tell me what email is signed in  →  I log it",
    "C)  If you can't find it or can't log in  →  we mark it DEAD and move on",
    "",
    "You don't have to do them all at once. One at a time. We build the map together.",
    "When the map is complete, we know exactly what to keep, what to kill, and what to migrate.",
]
for i, s in enumerate(steps):
    color = WHITE if s else BG
    txt(60, y+44+i*22, s, color, FM)

y += 180

# Footer
rr(0, y, W, 60, 0, "#111111")
txt(40, y+18, "Claude can see: this repo only  |  Everything else: you show me, I map it  |  No guesses on this chart.", GRAY, FS)

img.save("/home/user/Iron-Forge-Studios/docs/what-i-can-see.png", "PNG")
print("Done → docs/what-i-can-see.png")
