#!/usr/bin/env python3
"""
Generate a comprehensive visual system map of Karl's digital footprint.
Outputs a PNG to /home/user/Iron-Forge-Studios/docs/system-map.png
"""

import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
from matplotlib.patches import FancyBboxPatch, FancyArrowPatch
import textwrap

# ---------------------------------------------------------------------------
# Canvas setup
# ---------------------------------------------------------------------------
fig_w, fig_h = 24, 30  # inches at 100 dpi -> 2400x3000 px
fig, ax = plt.subplots(figsize=(fig_w, fig_h), dpi=100)
ax.set_xlim(0, fig_w)
ax.set_ylim(0, fig_h)
ax.axis('off')
fig.patch.set_facecolor('white')

# ---------------------------------------------------------------------------
# Color palette
# ---------------------------------------------------------------------------
COL_BG        = '#FFFFFF'
COL_HEADER_BG = '#1B2838'
COL_HEADER_FG = '#FFFFFF'
COL_GREEN     = '#2ECC71'
COL_GREEN_LT  = '#E8F8F0'
COL_YELLOW    = '#F1C40F'
COL_YELLOW_LT = '#FEF9E7'
COL_RED       = '#E74C3C'
COL_RED_LT    = '#FDEDEC'
COL_BLUE      = '#3498DB'
COL_BLUE_LT   = '#EBF5FB'
COL_PURPLE    = '#9B59B6'
COL_PURPLE_LT = '#F4ECF7'
COL_GRAY      = '#95A5A6'
COL_GRAY_LT   = '#F2F3F4'
COL_DARK      = '#2C3E50'
COL_ORANGE    = '#E67E22'
COL_ORANGE_LT = '#FDF2E9'
COL_LINE      = '#7F8C8D'
COL_RED_ARROW = '#C0392B'

# ---------------------------------------------------------------------------
# Helper: draw a rounded box with optional header
# ---------------------------------------------------------------------------
def draw_box(x, y, w, h, header=None, body_lines=None, border_color=COL_DARK,
             fill=COL_BG, header_bg=None, header_fg=COL_DARK, fontsize=8,
             header_fontsize=10, bold_header=True, alpha=1.0, radius=0.3):
    """Draw a rounded rectangle with optional colored header bar and body text."""
    box = FancyBboxPatch((x, y), w, h,
                         boxstyle=f"round,pad=0,rounding_size={radius}",
                         facecolor=fill, edgecolor=border_color,
                         linewidth=1.5, alpha=alpha, zorder=2)
    ax.add_patch(box)

    text_y = y + h  # start from top

    if header:
        hdr_h = 0.45
        hdr_box = FancyBboxPatch((x, y + h - hdr_h), w, hdr_h,
                                  boxstyle=f"round,pad=0,rounding_size={radius}",
                                  facecolor=header_bg or border_color,
                                  edgecolor=border_color,
                                  linewidth=1.5, zorder=3, clip_on=False)
        ax.add_patch(hdr_box)
        # Clip bottom corners of header by overlaying a thin rectangle
        clip_rect = mpatches.Rectangle((x, y + h - hdr_h), w, hdr_h * 0.5,
                                        facecolor=header_bg or border_color,
                                        edgecolor='none', zorder=3)
        ax.add_patch(clip_rect)
        weight = 'bold' if bold_header else 'normal'
        ax.text(x + w / 2, y + h - hdr_h / 2, header,
                ha='center', va='center', fontsize=header_fontsize,
                fontweight=weight, color=header_fg, zorder=4)
        text_y = y + h - hdr_h - 0.12

    if body_lines:
        for line in body_lines:
            text_y -= 0.30
            ax.text(x + 0.15, text_y, line, ha='left', va='top',
                    fontsize=fontsize, color=COL_DARK, zorder=4,
                    fontfamily='monospace' if line.startswith('  ') else 'sans-serif')
    return (x, y, w, h)


def draw_line(x1, y1, x2, y2, color=COL_LINE, lw=1.5, style='-', zorder=1):
    ax.plot([x1, x2], [y1, y2], color=color, linewidth=lw, linestyle=style,
            zorder=zorder, solid_capstyle='round')


def draw_arrow(x1, y1, x2, y2, color=COL_RED_ARROW, lw=2, style='->'):
    ax.annotate('', xy=(x2, y2), xytext=(x1, y1),
                arrowprops=dict(arrowstyle=style, color=color, lw=lw,
                                connectionstyle='arc3,rad=0.15'),
                zorder=5)


def section_title(x, y, text, fontsize=14, color=COL_DARK):
    ax.text(x, y, text, fontsize=fontsize, fontweight='bold', color=color,
            va='center', ha='left', zorder=5)


def legend_dot(x, y, color, label, fontsize=9):
    ax.plot(x, y, 'o', color=color, markersize=10, zorder=5)
    ax.text(x + 0.25, y, label, fontsize=fontsize, va='center', color=COL_DARK, zorder=5)


# =========================================================================
# TITLE BAR
# =========================================================================
title_box = FancyBboxPatch((0.5, fig_h - 1.4), fig_w - 1.0, 1.1,
                            boxstyle="round,pad=0,rounding_size=0.2",
                            facecolor=COL_HEADER_BG, edgecolor=COL_HEADER_BG,
                            linewidth=2, zorder=3)
ax.add_patch(title_box)
ax.text(fig_w / 2, fig_h - 0.65, "IRON FORGE STUDIOS — SYSTEM MAP",
        ha='center', va='center', fontsize=22, fontweight='bold',
        color=COL_HEADER_FG, zorder=4)
ax.text(fig_w / 2, fig_h - 1.1, "Karl's Complete Digital Footprint  •  Generated 2026-03-20",
        ha='center', va='center', fontsize=11, color='#BDC3C7', zorder=4)

# =========================================================================
# LEGEND
# =========================================================================
ly = fig_h - 2.1
legend_dot(1.0, ly, COL_GREEN, "KEEP", 9)
legend_dot(3.2, ly, COL_YELLOW, "ARCHIVE / YOUR CALL", 9)
legend_dot(6.8, ly, COL_RED, "DELETE", 9)
ax.text(9.5, ly, "Red dashed arrows = duplication problems",
        fontsize=9, va='center', color=COL_RED_ARROW, zorder=5)

# =========================================================================
# GITHUB ACCOUNT NODE (top center)
# =========================================================================
gh_x, gh_y, gh_w, gh_h = 8.5, fig_h - 4.0, 7.0, 1.2
draw_box(gh_x, gh_y, gh_w, gh_h,
         header="GitHub: OBHitting3",
         body_lines=["8 repositories  •  2 AI tools  •  ~50 branches total"],
         border_color=COL_DARK, fill='#EAF2F8',
         header_bg=COL_DARK, header_fg=COL_HEADER_FG,
         header_fontsize=13, fontsize=10)

# Center bottom of GitHub box
gh_cx = gh_x + gh_w / 2
gh_bot = gh_y

# =========================================================================
# REPO CARDS — Row 1 (the two KEEP repos)
# =========================================================================
row1_y = fig_h - 9.8
card_w = 10.5
card_gap = 1.0

# --- Iron-Forge-Studios ---
ifs_x = 1.0
ifs_h = 4.8
draw_box(ifs_x, row1_y, card_w, ifs_h,
         header="1. Iron-Forge-Studios  [KEEP]",
         body_lines=[
             "Home base repo — everything lives here",
             "",
             "Branches (6):",
             "  master",
             "  claude/cleanup-document-repos-3Pi6R",
             "  claude/weekly-activity-summary-nEI31",
             "  claude/palm-springs-game-foundation-BFruU",
             "  claude/plan-document-preservation-mr7uE",
             "  claude/review-projects-market-analysis-Uagyy",
             "",
             "Pull Requests:",
             "  #1 Prompt Forge  #2 PSP game",
             "  #3 Market analysis  #4 Cleanup",
             "",
             "Contains:",
             "  projects/palm-springs-paradise/",
             "  projects/content-shield/",
             "  website/   docs/",
         ],
         border_color=COL_GREEN, fill=COL_GREEN_LT,
         header_bg=COL_GREEN, header_fg='white',
         header_fontsize=11, fontsize=8.5)
draw_line(gh_cx - 3.5, gh_bot, ifs_x + card_w / 2, row1_y + ifs_h, COL_GREEN, 2)

# --- Content_Shield ---
cs_x = ifs_x + card_w + card_gap + 1.0
cs_h = 4.0
draw_box(cs_x, row1_y + 0.8, card_w, cs_h,
         header="2. Content_Shield  [KEEP]",
         body_lines=[
             "Most complete project — AI content validation",
             "",
             "27 branches (26 cursor/ + main)",
             "",
             "Features built:",
             "  Full MVP",
             "  Security hardening",
             "  LeadLatch SaaS integration",
             "",
             "Pull Requests: #1 through #5",
         ],
         border_color=COL_GREEN, fill=COL_GREEN_LT,
         header_bg=COL_GREEN, header_fg='white',
         header_fontsize=11, fontsize=8.5)
draw_line(gh_cx + 3.5, gh_bot, cs_x + card_w / 2, row1_y + cs_h + 0.8, COL_GREEN, 2)

# =========================================================================
# REPO CARDS — Row 2 (archive / your-call)
# =========================================================================
row2_y = fig_h - 14.2
card_w2 = 7.5

# --- Gemini-discovers-Diamonds ---
gdd_x = 1.0
gdd_h = 3.2
draw_box(gdd_x, row2_y, card_w2, gdd_h,
         header="4. Gemini-discovers-Diamonds  [ARCHIVE]",
         body_lines=[
             "Old Roblox work, 17 branches",
             "Overlaps w/ Palm Springs Paradise",
             "Has cursor/ branches",
             "",
             "Recommendation: Archive it.",
             "Content folded into IFS repo.",
         ],
         border_color=COL_YELLOW, fill=COL_YELLOW_LT,
         header_bg=COL_YELLOW, header_fg=COL_DARK,
         header_fontsize=10, fontsize=8.5)
draw_line(gh_cx - 5, gh_bot, gdd_x + card_w2 / 2, row2_y + gdd_h, COL_YELLOW, 1.5)

# --- Faceless_Shorts ---
fs_x = gdd_x + card_w2 + card_gap
fs_h = 3.0
draw_box(fs_x, row2_y + 0.2, card_w2, fs_h,
         header="5. Faceless_Shorts  [YOUR CALL]",
         body_lines=[
             "YouTube Shorts automation",
             "5 branches (main, claude/, cursor/)",
             "Partially built",
             "",
             "Not sprint-related.",
             "Archive or keep for later.",
         ],
         border_color=COL_YELLOW, fill=COL_YELLOW_LT,
         header_bg=COL_YELLOW, header_fg=COL_DARK,
         header_fontsize=10, fontsize=8.5)
draw_line(gh_cx - 2, gh_bot, fs_x + card_w2 / 2, row2_y + fs_h + 0.2, COL_YELLOW, 1.5)

# =========================================================================
# REPO CARDS — Row 2 cont. (DELETE repos)
# =========================================================================
# --- joshua7 ---
j7_x = fs_x + card_w2 + card_gap
j7_h = 2.2
draw_box(j7_x, row2_y + 0.8, 7.0, j7_h,
         header="3. joshua7  [DELETE]",
         body_lines=[
             "Empty duplicate of Content_Shield",
             "Created Feb 18",
             "No unique content.",
         ],
         border_color=COL_RED, fill=COL_RED_LT,
         header_bg=COL_RED, header_fg='white',
         header_fontsize=10, fontsize=8.5)
draw_line(gh_cx + 4, gh_bot, j7_x + 3.5, row2_y + j7_h + 0.8, COL_RED, 1.5)

# =========================================================================
# REPO CARDS — Row 3 (more DELETE repos)
# =========================================================================
row3_y = fig_h - 17.6
small_w = 5.5

# --- yt-autopilot ---
yt_x = 1.0
yt_h = 1.8
draw_box(yt_x, row3_y, small_w, yt_h,
         header="6. yt-autopilot  [DELETE]",
         body_lines=[
             "Empty YouTube tool",
             "main branch only",
         ],
         border_color=COL_RED, fill=COL_RED_LT,
         header_bg=COL_RED, header_fg='white',
         header_fontsize=10, fontsize=8.5)
draw_line(gh_cx - 6, gh_bot, yt_x + small_w / 2, row3_y + yt_h, COL_LINE, 1)

# --- 55-_AI_Intergration ---
ai_x = yt_x + small_w + card_gap
ai_h = 1.8
draw_box(ai_x, row3_y, small_w + 1.5, ai_h,
         header="7. 55-_AI_Intergration  [DELETE]",
         body_lines=[
             "Unknown experiment",
             "1 branch: claude/upgrade-ai-bridge-sync-JqMHc",
         ],
         border_color=COL_RED, fill=COL_RED_LT,
         header_bg=COL_RED, header_fg='white',
         header_fontsize=10, fontsize=8.5)
draw_line(gh_cx - 2, gh_bot, ai_x + (small_w + 1.5) / 2, row3_y + ai_h, COL_LINE, 1)

# --- FreeLance ---
fl_x = ai_x + small_w + 1.5 + card_gap
fl_h = 1.8
draw_box(fl_x, row3_y, small_w, fl_h,
         header="8. FreeLance  [DELETE]",
         body_lines=[
             "Completely empty",
             "No branches, no code",
         ],
         border_color=COL_RED, fill=COL_RED_LT,
         header_bg=COL_RED, header_fg='white',
         header_fontsize=10, fontsize=8.5)
draw_line(gh_cx + 5, gh_bot, fl_x + small_w / 2, row3_y + fl_h, COL_LINE, 1)

# =========================================================================
# AI TOOLS SECTION
# =========================================================================
section_title(1.0, fig_h - 18.5, "AI TOOLS IN USE", 13, COL_PURPLE)

ai_sec_y = fig_h - 21.0
ai_w = 10.0

draw_box(1.0, ai_sec_y, ai_w, 2.0,
         header="Claude Code",
         body_lines=[
             "Branches prefixed: claude/",
             "Used across Iron-Forge-Studios,",
             "Faceless_Shorts, 55-_AI_Intergration",
         ],
         border_color=COL_PURPLE, fill=COL_PURPLE_LT,
         header_bg=COL_PURPLE, header_fg='white',
         header_fontsize=11, fontsize=9)

draw_box(1.0 + ai_w + 1.5, ai_sec_y, ai_w, 2.0,
         header="Cursor (Background Agents)",
         body_lines=[
             "Branches prefixed: cursor/",
             "Used across Content_Shield,",
             "Gemini-discovers-Diamonds, Faceless_Shorts",
         ],
         border_color=COL_ORANGE, fill=COL_ORANGE_LT,
         header_bg=COL_ORANGE, header_fg='white',
         header_fontsize=11, fontsize=9)

# Red X between them
mid_ai_x = 1.0 + ai_w + 0.75
mid_ai_y = ai_sec_y + 1.0
ax.text(mid_ai_x, mid_ai_y, "X", fontsize=28, fontweight='bold',
        color=COL_RED, ha='center', va='center', zorder=6)
ax.text(mid_ai_x, mid_ai_y - 0.45, "Don't talk\nto each other",
        fontsize=8, color=COL_RED, ha='center', va='center', zorder=6)

# =========================================================================
# DUPLICATION PROBLEMS
# =========================================================================
section_title(1.0, fig_h - 21.8, "DUPLICATION PROBLEMS", 13, COL_RED_ARROW)

dup_y = fig_h - 24.6
dup_w = 21.5
draw_box(1.0, dup_y, dup_w, 2.4,
         header="Content Shield — exists in 3 places",
         body_lines=[
             "",
             "  [1] Content_Shield repo (standalone, most complete)",
             "  [2] joshua7 repo (empty duplicate — DELETE)",
             "  [3] Iron-Forge-Studios/projects/content-shield/ (partial copy)",
             "",
             "Action: Keep Content_Shield repo. Delete joshua7. Sync IFS copy.",
         ],
         border_color=COL_RED_ARROW, fill='#FDF2F2',
         header_bg=COL_RED_ARROW, header_fg='white',
         header_fontsize=11, fontsize=9)

draw_box(1.0, dup_y - 2.0, dup_w, 1.6,
         header="Palm Springs Paradise — exists in 2 places",
         body_lines=[
             "",
             "  [1] Gemini-discovers-Diamonds repo (old Roblox code)",
             "  [2] Iron-Forge-Studios/projects/palm-springs-paradise/",
             "",
             "Action: Keep IFS copy. Archive Gemini-discovers-Diamonds.",
         ],
         border_color=COL_RED_ARROW, fill='#FDF2F2',
         header_bg=COL_RED_ARROW, header_fg='white',
         header_fontsize=11, fontsize=9)

# Draw some dashed red arrows between the duplicate repos and IFS
# Content_Shield -> IFS
draw_arrow(cs_x + 2, row1_y + 0.8, ifs_x + card_w - 0.5, row1_y + 1.5,
           COL_RED_ARROW, 2.5, '->')
# joshua7 -> Content_Shield
draw_arrow(j7_x + 1, row2_y + 0.8, cs_x + card_w - 0.5, row1_y + 0.8,
           COL_RED_ARROW, 2.5, '->')
# Gemini -> IFS
draw_arrow(gdd_x + card_w2 - 0.5, row2_y + 1.0, ifs_x + 4, row1_y,
           COL_RED_ARROW, 2.5, '->')

# =========================================================================
# MISSING / GAPS
# =========================================================================
section_title(1.0, dup_y - 3.0, "MISSING / GAPS", 13, COL_ORANGE)

miss_y = dup_y - 5.2
draw_box(1.0, miss_y, 21.5, 1.8,
         header="Things That Don't Exist Yet",
         body_lines=[
             "",
             "  \u2717  No J9 / AIRE repo — the main 30-day sprint project has no home yet",
             "  \u2717  No .cursorrules file anywhere — Cursor has no project-level instructions",
             "  \u2717  No .windsurfrules file anywhere — Windsurf has no project-level instructions",
         ],
         border_color=COL_ORANGE, fill=COL_ORANGE_LT,
         header_bg=COL_ORANGE, header_fg='white',
         header_fontsize=11, fontsize=9)

# =========================================================================
# TIMELINE (horizontal bar at bottom)
# =========================================================================
section_title(1.0, miss_y - 1.0, "TIMELINE", 13, COL_DARK)

tl_y = miss_y - 2.8
tl_left = 1.5
tl_right = 22.5
tl_len = tl_right - tl_left

# Draw the main timeline bar
ax.plot([tl_left, tl_right], [tl_y, tl_y], color=COL_DARK, linewidth=3, zorder=3)

# Timeline events
events = [
    (0.00, "Feb 14", "IFS + FreeLance\ncreated", 'above'),
    (0.12, "Feb 16-18", "yt-autopilot,\nContent_Shield MVP,\njoshua7 created", 'below'),
    (0.28, "Feb 19-22", "Security work,\nRoblox prototype PRs", 'above'),
    (0.48, "Feb 28", "Activity summary,\nbranch cleanup", 'below'),
    (0.70, "Mar 10-14", "Prompt Forge,\nmarket analysis,\nPRs merged", 'above'),
    (0.88, "Mar 19-20", "CLAUDE.md created,\nrepo reorganized", 'below'),
]

for frac, date_label, desc, pos in events:
    ex = tl_left + frac * tl_len
    # Dot
    ax.plot(ex, tl_y, 'o', color=COL_BLUE, markersize=10, zorder=4)
    ax.plot(ex, tl_y, 'o', color='white', markersize=5, zorder=5)

    if pos == 'above':
        ax.plot([ex, ex], [tl_y, tl_y + 0.4], color=COL_LINE, linewidth=1, zorder=3)
        ax.text(ex, tl_y + 0.5, date_label, ha='center', va='bottom',
                fontsize=9, fontweight='bold', color=COL_DARK, zorder=5)
        ax.text(ex, tl_y + 1.0, desc, ha='center', va='bottom',
                fontsize=8, color=COL_DARK, zorder=5,
                linespacing=1.3)
    else:
        ax.plot([ex, ex], [tl_y, tl_y - 0.4], color=COL_LINE, linewidth=1, zorder=3)
        ax.text(ex, tl_y - 0.5, date_label, ha='center', va='top',
                fontsize=9, fontweight='bold', color=COL_DARK, zorder=5)
        ax.text(ex, tl_y - 0.7, desc, ha='center', va='top',
                fontsize=8, color=COL_DARK, zorder=5,
                linespacing=1.3)

# =========================================================================
# Footer
# =========================================================================
ax.text(fig_w / 2, 0.3, "Iron Forge Studios  •  OBHitting3  •  System Map v1.0",
        ha='center', va='center', fontsize=9, color=COL_GRAY, zorder=5)

# =========================================================================
# Save
# =========================================================================
plt.tight_layout(pad=0.5)
out_path = "/home/user/Iron-Forge-Studios/docs/system-map.png"
fig.savefig(out_path, dpi=100, facecolor='white', bbox_inches='tight')
plt.close()
print(f"System map saved to {out_path}")
