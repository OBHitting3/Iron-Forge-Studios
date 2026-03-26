"""
REAL visual map — boxes and arrows showing what connects to what.
Not a list. A diagram.
"""
from PIL import Image, ImageDraw, ImageFont
import math

W, H = 2000, 1500
img = Image.new("RGB", (W, H), "#ffffff")
draw = ImageDraw.Draw(img)

try:
    FB = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", 20)
    FM = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf", 15)
    FS = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf", 12)
    FT = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", 32)
    FST = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf", 18)
except:
    FT = FB = FM = FS = FST = ImageFont.load_default()

# Colors
BLACK = "#000000"
WHITE = "#ffffff"
RED = "#cc0000"
GREEN = "#009900"
BLUE = "#0066cc"
ORANGE = "#cc6600"
GRAY = "#999999"
LIGHTGRAY = "#eeeeee"
LIGHTRED = "#ffdddd"
LIGHTGREEN = "#ddffdd"
LIGHTBLUE = "#ddeeff"
LIGHTORANGE = "#fff0dd"
LIGHTYELLOW = "#ffffdd"
DEADGRAY = "#dddddd"

def box(x, y, w, h, fill, outline, label, sublabel=None, sublabel2=None):
    draw.rounded_rectangle([x, y, x+w, y+h], radius=10, fill=fill, outline=outline, width=2)
    # Center the label
    bbox = draw.textbbox((0,0), label, font=FB)
    tw = bbox[2] - bbox[0]
    ly = y + 10 if sublabel else y + (h - 20) // 2
    draw.text((x + (w - tw) // 2, ly), label, fill=BLACK, font=FB)
    if sublabel:
        bbox2 = draw.textbbox((0,0), sublabel, font=FM)
        tw2 = bbox2[2] - bbox2[0]
        draw.text((x + (w - tw2) // 2, ly + 26), sublabel, fill="#444444", font=FM)
    if sublabel2:
        bbox3 = draw.textbbox((0,0), sublabel2, font=FS)
        tw3 = bbox3[2] - bbox3[0]
        draw.text((x + (w - tw3) // 2, ly + 48), sublabel2, fill=outline, font=FS)
    return (x + w//2, y + h//2)  # center point

def arrow(x1, y1, x2, y2, color="#666666", width=2, dashed=False):
    if dashed:
        # Draw dashed line
        length = math.sqrt((x2-x1)**2 + (y2-y1)**2)
        dx = (x2-x1) / length
        dy = (y2-y1) / length
        dash_len = 8
        gap_len = 6
        d = 0
        while d < length:
            sx = x1 + dx * d
            sy = y1 + dy * d
            ex = x1 + dx * min(d + dash_len, length)
            ey = y1 + dy * min(d + dash_len, length)
            draw.line([(sx, sy), (ex, ey)], fill=color, width=width)
            d += dash_len + gap_len
    else:
        draw.line([(x1, y1), (x2, y2)], fill=color, width=width)
    # Arrowhead
    angle = math.atan2(y2-y1, x2-x1)
    al = 12
    draw.polygon([
        (x2, y2),
        (x2 - al * math.cos(angle - 0.35), y2 - al * math.sin(angle - 0.35)),
        (x2 - al * math.cos(angle + 0.35), y2 - al * math.sin(angle + 0.35)),
    ], fill=color)

def label_on_arrow(x1, y1, x2, y2, text, color="#666666"):
    mx = (x1 + x2) // 2
    my = (y1 + y2) // 2
    bbox = draw.textbbox((0,0), text, font=FS)
    tw = bbox[2] - bbox[0]
    th = bbox[3] - bbox[1]
    draw.rectangle([mx - tw//2 - 4, my - th//2 - 2, mx + tw//2 + 4, my + th//2 + 2], fill=WHITE)
    draw.text((mx - tw//2, my - th//2), text, fill=color, font=FS)

# ══════════════════════════════════════════════════════════════════
# TITLE
# ══════════════════════════════════════════════════════════════════
draw.text((W//2 - 280, 15), "KARL'S ACCOUNT MAP", fill=BLACK, font=FT)
draw.text((W//2 - 250, 55), "How everything connects — and where it broke", fill=GRAY, font=FST)

# ══════════════════════════════════════════════════════════════════
# THE ROOT — APPLE ID (where it all started)
# ══════════════════════════════════════════════════════════════════

# Dead Apple ID at the very top center
apple_dead = box(820, 100, 340, 70, DEADGRAY, RED,
    "APPLE ID (DEAD)",
    "obhitting3.tv@gmail.com",
    "Deleted wrong one — LOST ACCESS")

# Draw a big X through it
draw.line([(830, 110), (1150, 160)], fill=RED, width=3)
draw.line([(830, 160), (1150, 110)], fill=RED, width=3)

# ══════════════════════════════════════════════════════════════════
# THE 3 GOOGLE ACCOUNTS (born from the Apple ID mess)
# ══════════════════════════════════════════════════════════════════

# OB Hitting — left
ob = box(80, 260, 320, 80, LIGHTORANGE, ORANGE,
    "OB Hitting 3",
    "ob.hitting.3.tv@gmail.com",
    "DEFAULT on phone — controls everything")

# Karl / Iron Forge — center
karl = box(500, 260, 320, 80, LIGHTGREEN, GREEN,
    "Karl Detlefsen",
    "contact@ironforge.studio",
    "Business email — SHOULD be primary")

# Desert Resale — right
desert = box(920, 260, 320, 80, DEADGRAY, GRAY,
    "Desert Resale",
    "coachellavalleyresale@gmail.com",
    "Old business?")

# Mystery email
det33 = box(1360, 260, 280, 80, LIGHTYELLOW, ORANGE,
    "karl@det33.com",
    "??? Unknown ???",
    "Found in Cursor — what is this?")

# Arrows from dead Apple ID down to the accounts
arrow(990, 170, 240, 260, RED, 2)
arrow(990, 170, 660, 260, RED, 2)
arrow(990, 170, 1080, 260, RED, 2, dashed=True)

label_on_arrow(990, 170, 240, 260, "lost access, made new accounts", RED)

# ══════════════════════════════════════════════════════════════════
# DEVICES — what the accounts are signed into
# ══════════════════════════════════════════════════════════════════

iphone = box(50, 440, 220, 70, LIGHTBLUE, BLUE,
    "iPhone",
    "ALL 3 accounts signed in")

mac = box(350, 440, 220, 70, LIGHTBLUE, BLUE,
    "Mac (1 computer)",
    "Shows as 2 devices in Google")

# Chrome profiles on mac
chrome1 = box(300, 560, 170, 55, LIGHTORANGE, ORANGE,
    "Chrome Profile 1",
    "\"K Work\"")

chrome2 = box(500, 560, 170, 55, LIGHTYELLOW, ORANGE,
    "Chrome Profile 2",
    "(unknown name)")

# Phone connects to all 3 google accounts
arrow(160, 340, 160, 440, ORANGE)
arrow(660, 340, 300, 440, GREEN, 2, dashed=True)
arrow(1080, 340, 230, 455, GRAY, 1, dashed=True)

# Mac connects to chrome profiles
arrow(460, 510, 385, 560, ORANGE)
arrow(460, 510, 585, 560, ORANGE)

label_on_arrow(460, 510, 585, 560, "this = the 'twin'", RED)

# ══════════════════════════════════════════════════════════════════
# DEV SERVICES — what OB Hitting connects to
# ══════════════════════════════════════════════════════════════════

github = box(50, 700, 220, 70, LIGHTORANGE, ORANGE,
    "GitHub",
    "OBHitting3")

gitlab = box(310, 700, 220, 70, LIGHTORANGE, ORANGE,
    "GitLab",
    "ob.hitting.3.tv")

cursor = box(570, 700, 220, 70, LIGHTORANGE, ORANGE,
    "Cursor (Ultra)",
    "Iron Forge workspace")

supabase = box(830, 700, 220, 70, LIGHTYELLOW, ORANGE,
    "Supabase",
    "Project: 95e65d7e...")

# OB Hitting connects down to all dev services
arrow(240, 340, 160, 700, ORANGE)
label_on_arrow(240, 340, 160, 700, "owns", ORANGE)

arrow(240, 340, 420, 700, ORANGE)
arrow(240, 340, 680, 700, ORANGE)
arrow(240, 340, 940, 700, ORANGE, 2, dashed=True)

# Cursor connects to GitHub, GitLab, Slack, Linear
cursor_cx = 680
cursor_by = 770

slack = box(570, 830, 130, 50, LIGHTBLUE, BLUE, "Slack")
linear = box(720, 830, 160, 50, LIGHTBLUE, BLUE, "Linear", "Palm Springs Paradise")

arrow(680, 770, 160, 750, BLUE)
label_on_arrow(680, 770, 160, 750, "connected", BLUE)
arrow(680, 770, 420, 750, BLUE)
arrow(680, 770, 635, 830, BLUE)
arrow(680, 770, 800, 830, BLUE)

# ══════════════════════════════════════════════════════════════════
# REPOS — what's in GitHub
# ══════════════════════════════════════════════════════════════════

repo1 = box(30, 830, 200, 60, WHITE, ORANGE,
    "Iron-Forge-Studios",
    "30 commits, 6 branches")

repo2 = box(250, 830, 200, 60, DEADGRAY, GRAY,
    "Content_Shield",
    "27 branches, on hold")

arrow(160, 770, 130, 830, ORANGE)
arrow(160, 770, 350, 830, GRAY, 1, dashed=True)

# Inside Iron-Forge-Studios
j9app = box(20, 940, 150, 50, LIGHTGREEN, GREEN, "j9-app", "Backend API")
j9dash = box(190, 940, 150, 50, LIGHTGREEN, GREEN, "j9-dashboard", "Frontend")
psp = box(360, 940, 150, 50, DEADGRAY, GRAY, "Palm Springs", "On hold")

arrow(130, 890, 95, 940, GREEN)
arrow(130, 890, 265, 940, GREEN)
arrow(130, 890, 435, 940, GRAY, 1, dashed=True)

# Supabase connects to j9-app
arrow(940, 770, 95, 960, GREEN, 2, dashed=True)
label_on_arrow(940, 770, 95, 960, "backend talks to database", GREEN)

# ══════════════════════════════════════════════════════════════════
# AI TOOLS (right side)
# ══════════════════════════════════════════════════════════════════

claude = box(1100, 440, 200, 60, LIGHTBLUE, BLUE,
    "Claude (Max)",
    "email: ???")

chatgpt = box(1340, 440, 200, 60, LIGHTBLUE, BLUE,
    "ChatGPT",
    "email: ???")

gemini = box(1100, 540, 200, 60, LIGHTBLUE, BLUE,
    "Gemini",
    "email: ???")

supergrok = box(1340, 540, 200, 60, DEADGRAY, GRAY,
    "SuperGrok",
    "email: ???")

# Question marks — don't know which account
draw.text((1130, 420), "?", fill=RED, font=FT)
draw.text((1370, 420), "?", fill=RED, font=FT)
draw.text((1130, 520), "?", fill=RED, font=FT)

# ══════════════════════════════════════════════════════════════════
# HOSTING (not deployed)
# ══════════════════════════════════════════════════════════════════

vercel = box(1100, 700, 200, 60, LIGHTRED, RED,
    "Vercel",
    "NOT DEPLOYED — email: ???")

railway = box(1340, 700, 200, 60, LIGHTRED, RED,
    "Railway",
    "NOT DEPLOYED — email: ???")

# Dashed lines showing where they SHOULD connect
arrow(265, 990, 1200, 760, GREEN, 1, dashed=True)
label_on_arrow(265, 990, 1200, 760, "should deploy here", GREEN)

arrow(95, 990, 1440, 760, GREEN, 1, dashed=True)

# ══════════════════════════════════════════════════════════════════
# MCP SERVERS
# ══════════════════════════════════════════════════════════════════

mcp = box(1100, 830, 440, 60, LIGHTYELLOW, ORANGE,
    "12 MCP Servers in Claude Desktop",
    "1 broken (Kapture) — most not needed")

arrow(1200, 500, 1200, 830, BLUE, 1, dashed=True)

# ══════════════════════════════════════════════════════════════════
# LEGEND
# ══════════════════════════════════════════════════════════════════

ly = 1050
draw.rounded_rectangle([50, ly, W-50, ly+100], radius=8, fill=LIGHTGRAY, outline=GRAY)
draw.text((70, ly+8), "LEGEND:", fill=BLACK, font=FB)

# Solid arrow
draw.line([(70, ly+45), (130, ly+45)], fill=ORANGE, width=2)
draw.polygon([(130, ly+45), (122, ly+39), (122, ly+51)], fill=ORANGE)
draw.text((140, ly+38), "= connected / owned by", fill=BLACK, font=FM)

# Dashed arrow
for dx in range(0, 60, 14):
    draw.line([(400+dx, ly+45), (400+dx+8, ly+45)], fill=GRAY, width=2)
draw.text((470, ly+38), "= unknown connection / planned", fill=BLACK, font=FM)

# Color boxes
draw.rectangle([750, ly+30, 780, ly+55], fill=LIGHTORANGE, outline=ORANGE, width=2)
draw.text((790, ly+35), "= OB Hitting account", fill=BLACK, font=FM)

draw.rectangle([1000, ly+30, 1030, ly+55], fill=LIGHTGREEN, outline=GREEN, width=2)
draw.text((1040, ly+35), "= Business / working", fill=BLACK, font=FM)

draw.rectangle([1250, ly+30, 1280, ly+55], fill=LIGHTRED, outline=RED, width=2)
draw.text((1290, ly+35), "= Not set up / broken", fill=BLACK, font=FM)

draw.rectangle([1500, ly+30, 1530, ly+55], fill=DEADGRAY, outline=GRAY, width=2)
draw.text((1540, ly+35), "= Dead / old", fill=BLACK, font=FM)

# Big red question marks for the blanks
draw.text((70, ly+65), "Big red  ?  = I don't know which email this is on. You need to tell me or show me.", fill=RED, font=FM)

img.save("/home/user/Iron-Forge-Studios/docs/account-map-visual.png", "PNG")
print("Done")
