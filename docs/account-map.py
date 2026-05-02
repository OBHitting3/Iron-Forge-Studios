"""
Karl's Account Map — Visual diagram of all accounts, services, and connections.
Run: python3 account-map.py
Output: account-map.png
"""

try:
    from PIL import Image, ImageDraw, ImageFont
except ImportError:
    import subprocess
    subprocess.check_call(["pip", "install", "Pillow"])
    from PIL import Image, ImageDraw, ImageFont

# Canvas
W, H = 1800, 2200
img = Image.new("RGB", (W, H), "#1a1a2e")
draw = ImageDraw.Draw(img)

# Try to get a decent font, fall back to default
try:
    font_title = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", 36)
    font_heading = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", 22)
    font_body = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf", 17)
    font_small = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf", 14)
except:
    font_title = ImageFont.load_default()
    font_heading = font_title
    font_body = font_title
    font_small = font_title

# Colors
RED = "#e74c3c"
ORANGE = "#e67e22"
GREEN = "#2ecc71"
BLUE = "#3498db"
PURPLE = "#9b59b6"
YELLOW = "#f1c40f"
GRAY = "#95a5a6"
DARK_GRAY = "#2c3e50"
WHITE = "#ecf0f1"
DARK_BG = "#16213e"
CARD_BG = "#0f3460"
WARN_BG = "#4a1a2e"

def draw_card(x, y, w, h, color, title, items, bg=CARD_BG):
    # Card background
    draw.rounded_rectangle([x, y, x+w, y+h], radius=12, fill=bg, outline=color, width=2)
    # Color bar at top
    draw.rounded_rectangle([x, y, x+w, y+40], radius=12, fill=color)
    draw.rectangle([x, y+28, x+w, y+40], fill=color)
    # Title
    draw.text((x+15, y+8), title, fill=WHITE, font=font_heading)
    # Items
    for i, item in enumerate(items):
        draw.text((x+15, y+50 + i*24), item, fill=WHITE, font=font_body)

def draw_arrow(x1, y1, x2, y2, color=GRAY):
    draw.line([(x1, y1), (x2, y2)], fill=color, width=2)
    # Simple arrowhead
    import math
    angle = math.atan2(y2-y1, x2-x1)
    arrow_len = 10
    draw.line([
        (x2, y2),
        (x2 - arrow_len * math.cos(angle - 0.4), y2 - arrow_len * math.sin(angle - 0.4))
    ], fill=color, width=2)
    draw.line([
        (x2, y2),
        (x2 - arrow_len * math.cos(angle + 0.4), y2 - arrow_len * math.sin(angle + 0.4))
    ], fill=color, width=2)

# ═══════════════ TITLE ═══════════════
draw.text((W//2 - 300, 20), "KARL'S ACCOUNT MAP", fill=YELLOW, font=font_title)
draw.text((W//2 - 220, 65), "Everything that exists. All connections.", fill=GRAY, font=font_body)
draw.text((W//2 - 180, 90), "March 2026 - Before Fresh Start", fill=GRAY, font=font_small)

# ═══════════════ THE 3 IDENTITIES ═══════════════
draw.text((50, 130), "YOUR 3 IDENTITIES (This is the problem)", fill=RED, font=font_heading)

# Identity 1: OB Hitting
draw_card(50, 170, 500, 160, ORANGE,
    "OB Hitting 3 \"Casper\"",
    [
        "ob.hitting.3.tv@gmail.com",
        "DEFAULT Google account on phone",
        "Controls Chrome on both \"Macs\"",
        "Connected to: GitHub, GitLab, Cursor",
    ])

# Identity 2: Karl Detlefsen
draw_card(620, 170, 500, 160, GREEN,
    "Karl Detlefsen (Business)",
    [
        "contact@ironforge.studio",
        "Google account on phone",
        "ironforge.studio domain (owned)",
        "THIS should be the main identity",
    ])

# Identity 3: Desert Resale
draw_card(1200, 170, 500, 160, GRAY,
    "Desert Resale (Old?)",
    [
        "coachellavalleyresale@gmail.com",
        "Google account on phone",
        "Status: Unknown if still needed",
        "Recommendation: REMOVE from phone",
    ])

# ═══════════════ DEVICES ═══════════════
draw.text((50, 370), "YOUR DEVICES", fill=BLUE, font=font_heading)

draw_card(50, 410, 350, 140, BLUE,
    "iPhone",
    [
        "3 Google accounts signed in",
        "All 3 identities fighting",
        "This causes the 'twin' feeling",
    ])

draw_card(470, 410, 350, 140, BLUE,
    "Mac (ONE computer)",
    [
        "Shows as TWO in Google:",
        "  - \"Mac\"",
        "  - \"Karls-MacBook-Air\"",
        "Multiple Chrome profiles = twin",
    ])

# ═══════════════ CODE & DEV SERVICES ═══════════════
draw.text((50, 590), "CODE & DEV SERVICES (connected to OB Hitting / OBHitting3)", fill=ORANGE, font=font_heading)

draw_card(50, 630, 340, 200, ORANGE,
    "GitHub (OBHitting3)",
    [
        "Email: ob.hitting.3.tv@gmail.com",
        "Repos:",
        "  Iron-Forge-Studios",
        "  Content_Shield (27 branches)",
        "  Possibly others",
        "Status: ACTIVE",
    ])

draw_card(440, 630, 340, 200, ORANGE,
    "Cursor (Ultra Plan)",
    [
        "Workspace: \"Iron Forge\"",
        "Connected to:",
        "  GitHub: OBHitting3",
        "  GitLab: ob.hitting.3.tv",
        "  Slack",
        "  Linear: Palm Springs Paradise",
    ])

draw_card(830, 630, 340, 200, PURPLE,
    "Supabase",
    [
        "Project ID: 95e65d7e...",
        "Has database tables (maybe)",
        "Migration 001: Unknown",
        "Migration 002: NOT run",
        "Email: UNKNOWN",
        "Status: Provisioned",
    ])

draw_card(1220, 630, 340, 200, GRAY,
    "GitLab",
    [
        "Username: ob.hitting.3.tv",
        "Connected via Cursor",
        "Status: Unknown what's here",
        "",
        "Probably not needed",
    ])

# ═══════════════ HOSTING (NOT SET UP) ═══════════════
draw.text((50, 870), "HOSTING (None deployed yet)", fill=GRAY, font=font_heading)

draw_card(50, 910, 340, 140, GRAY,
    "Vercel (Frontend)",
    [
        "Account: MAY exist",
        "Email: UNKNOWN",
        "Status: NOT deployed",
    ])

draw_card(440, 910, 340, 140, GRAY,
    "Railway (Backend)",
    [
        "Account: MAY exist",
        "Email: UNKNOWN",
        "Status: NOT deployed",
    ])

draw_card(830, 910, 340, 140, GRAY,
    "Google Drive (2TB)",
    [
        "5.24 GB used of 2 TB",
        "4 GB in trash",
        "Screenshots stored here",
    ])

# ═══════════════ AI TOOLS ═══════════════
draw.text((50, 1090), "AI TOOLS", fill=PURPLE, font=font_heading)

draw_card(50, 1130, 260, 160, PURPLE,
    "Claude (Max)",
    [
        "Claude Desktop + Code",
        "Email: UNKNOWN",
        "12 MCP servers",
        "1 is BROKEN",
    ])

draw_card(360, 1130, 260, 160, PURPLE,
    "ChatGPT / OpenAI",
    [
        "Used for research",
        "Email: UNKNOWN",
        "API not connected",
    ])

draw_card(670, 1130, 260, 160, PURPLE,
    "SuperGrok",
    [
        "Used for Roblox dev",
        "Email: UNKNOWN",
        "Not active now",
    ])

draw_card(980, 1130, 260, 160, PURPLE,
    "Cursor (Editor)",
    [
        "Ultra plan",
        "Email: UNKNOWN",
        "Has .cursorrules",
    ])

# ═══════════════ MCP SERVERS ═══════════════
draw.text((50, 1330), "MCP SERVERS IN CLAUDE DESKTOP (12 installed - most unnecessary)", fill=RED, font=font_heading)

draw_card(50, 1370, 400, 240, GREEN,
    "KEEP (Actually useful)",
    [
        "Filesystem",
        "Context7",
        "Desktop Commander (maybe)",
        "PDF Tools (maybe)",
        "",
        "",
        "",
    ])

draw_card(500, 1370, 400, 240, RED,
    "REMOVE (Not needed / broken)",
    [
        "Kapture Browser - BROKEN",
        "Control Chrome",
        "Figma",
        "AWS API MCP Server",
        "Control your Mac",
        "ToolUniverse",
        "Roblox_Studio (not now)",
        "Read and Write Ap... (unknown)",
    ])

# ═══════════════ FUTURE SERVICES (NOT ACTIVE) ═══════════════
draw.text((50, 1650), "FUTURE SERVICES (Not set up yet - needed for Janine app)", fill=YELLOW, font=font_heading)

services_future = [
    ("Twilio", "Phone + SMS"),
    ("ElevenLabs", "Voice clone"),
    ("Resend", "Email sending"),
    ("Stripe", "Billing ($3K/mo)"),
    ("n8n", "Automation"),
]

for i, (name, purpose) in enumerate(services_future):
    x = 50 + i * 310
    draw_card(x, 1690, 280, 80, DARK_GRAY,
        name,
        [purpose, "Status: NOT ACTIVE"])

# ═══════════════ THE PLAN ═══════════════
draw.rounded_rectangle([50, 1820, W-50, 2160], radius=15, fill="#1a3a2e", outline=GREEN, width=3)
draw.text((80, 1840), "THE FRESH START", fill=GREEN, font=font_title)

plan_lines = [
    "1. Pick new company name + buy new domain",
    "2. Create ONE new email: you@newdomain.com",
    "3. New GitHub account (this email)",
    "4. New Supabase project (this email)",
    "5. New Vercel account (this email)",
    "6. New Railway account (this email)",
    "7. Move the good code to new repo (Claude does this)",
    "8. Deploy backend + frontend (together)",
    "9. Clean up old accounts on devices (your pace)",
    "10. ONE identity. ONE email. ONE clean setup. Done.",
]

for i, line in enumerate(plan_lines):
    color = YELLOW if i == 0 else WHITE
    draw.text((80, 1890 + i*26), line, fill=color, font=font_body)

# Save
img.save("/home/user/Iron-Forge-Studios/docs/account-map.png", "PNG")
print("Saved to /home/user/Iron-Forge-Studios/docs/account-map.png")
