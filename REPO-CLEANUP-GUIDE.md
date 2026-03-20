# Iron Forge Studios — Repository Inventory & Cleanup Guide

**Date:** March 20, 2026
**Owner:** OBHitting3
**Purpose:** Get clarity on every repo, decide what to keep, archive, or delete.

---

## How to Use This Document

Go through each repo below. For each one, there's a **Recommendation** and an **Action** checkbox. The recommendations are based on how much real work exists and whether the project has a clear path forward. You make the final call.

**Legend:**
- **KEEP** — Active project with real code/value. Keep developing.
- **ARCHIVE** — Has useful work but you're not actively building it. Archive on GitHub (read-only, still accessible).
- **DELETE** — Empty or redundant. Safe to remove.
- **MERGE** — Consolidate into another repo.

---

## 1. Iron-Forge-Studios (this repo)

| | |
|---|---|
| **What it is** | Your organization hub repo. Contains the Palm Springs Paradise Roblox game prototype (36 Luau files), an investor market analysis, and a weekly activity summary. |
| **Language** | Luau (Roblox), Markdown |
| **Real code?** | Yes — full game architecture with 8 server services, 6 client controllers, rate limiting, monetization system, anti-grief systems. Production-grade Rojo v7 structure. |
| **Status** | Game prototype complete. Docs current as of March 2026. |
| **Recommendation** | **KEEP** — This is your home base and has a complete game prototype. |

- [ ] Action: Keep as-is. Consider renaming or clarifying that this is both the org hub and the PSP game repo.

---

## 2. Content_Shield

| | |
|---|---|
| **What it is** | Pre-publication AI content validation platform (SaaS). Branded as "Joshua 7." Validates content before publishing — flags AI-generated text, checks authenticity, ensures compliance. |
| **Language** | Python |
| **Real code?** | Yes — full MVP with content validators, API, CLI. Security hardened (timing-safe auth, rate limiting, audit logging). 27 branches. |
| **Status** | MVP shipped and merged. Security hardening merged. Additional PRs open. |
| **Recommendation** | **KEEP** — This is one of your two strongest projects. Has a real market (see your own market analysis). MVP is done. |

- [ ] Action: Keep. Close stale PRs. Consider whether this or `joshua7` should be the primary repo (see #3).

---

## 3. joshua7

| | |
|---|---|
| **What it is** | Standalone branded version of Content Shield. |
| **Language** | Python |
| **Real code?** | Likely minimal — initialized Feb 18 as a separate branded repo. |
| **Status** | Main branch only. |
| **Recommendation** | **MERGE or DELETE** — Having two repos for the same project creates confusion. Pick one. |

- [ ] Action: If `joshua7` has unique code, merge it into `Content_Shield`. If it's just a copy or empty, delete it.

---

## 4. Gemini-discovers-Diamonds

| | |
|---|---|
| **What it is** | Roblox tycoon development platform. Contains automated tycoon studio capabilities, Iron Forge CLI tool, and various prototypes. |
| **Language** | Luau (Roblox) |
| **Real code?** | Yes — 17 branches, PR for art direction prototype, multiple feature branches for CLI and execution engine. |
| **Status** | Active development. Open issues for event-driven architecture, video tools, and Redis scaling. |
| **Recommendation** | **KEEP or ARCHIVE** — Depends on whether you're still building this alongside PSP, or if PSP replaced it. |

- [ ] Action: If PSP (in Iron-Forge-Studios) is your main Roblox game, consider archiving this unless it serves a different purpose.

---

## 5. Faceless_Shorts

| | |
|---|---|
| **What it is** | YouTube Shorts automation tool. Generates faceless YouTube Shorts content. |
| **Language** | Python |
| **Real code?** | Yes — 5 branches including Python conversion and studio backdrop generation. |
| **Status** | In development. Being converted to Python via Claude Code. |
| **Recommendation** | **KEEP or ARCHIVE** — If YouTube automation is still a priority, keep it. If not, archive. |

- [ ] Action: Decide if YouTube automation is in your current plans. If yes, keep. If not, archive (you can always unarchive later).

---

## 6. yt-autopilot

| | |
|---|---|
| **What it is** | End-to-end YouTube video generation pipeline — topic to upload in one command. |
| **Language** | Python |
| **Real code?** | Likely minimal — main branch only, initialized Feb 16. |
| **Status** | Early stage / concept. |
| **Recommendation** | **MERGE or DELETE** — If this overlaps with Faceless_Shorts, consolidate. If it's empty, delete. |

- [ ] Action: Check if this has unique code. If so, merge into Faceless_Shorts. If empty, delete.

---

## 7. 55-_AI_Intergration

| | |
|---|---|
| **What it is** | AI bridge sync functionality. TypeScript project. |
| **Language** | TypeScript |
| **Real code?** | Unknown — single development branch, no main branch. |
| **Status** | Development-only. No PRs, no main branch. |
| **Recommendation** | **ARCHIVE or DELETE** — No main branch and unclear purpose suggests this was experimental. |

- [ ] Action: Check the branch for useful code. If there's something worth saving, push it to main and archive. If not, delete.

---

## 8. FreeLance

| | |
|---|---|
| **What it is** | Freelance platform. |
| **Language** | None |
| **Real code?** | No — placeholder, no code pushed. |
| **Status** | Empty. |
| **Recommendation** | **DELETE** — Empty placeholder. You can recreate it if you ever start this project. |

- [ ] Action: Delete. No code to lose.

---

## Summary: Quick Decision Table

| # | Repo | Real Code? | Recommendation | Priority |
|---|------|-----------|----------------|----------|
| 1 | Iron-Forge-Studios | Yes (36 files) | **KEEP** | High — your main hub + PSP game |
| 2 | Content_Shield | Yes (full MVP) | **KEEP** | High — your strongest SaaS project |
| 3 | joshua7 | Minimal | **MERGE → Content_Shield or DELETE** | Low |
| 4 | Gemini-discovers-Diamonds | Yes (17 branches) | **KEEP or ARCHIVE** | Medium — you decide |
| 5 | Faceless_Shorts | Yes (5 branches) | **KEEP or ARCHIVE** | Medium — you decide |
| 6 | yt-autopilot | Minimal | **MERGE → Faceless_Shorts or DELETE** | Low |
| 7 | 55-_AI_Intergration | Unknown | **ARCHIVE or DELETE** | Low |
| 8 | FreeLance | No | **DELETE** | Low |

---

## Suggested Focus (If You Want to Stop Feeling Scattered)

If you narrow down to **2 projects max**, you'll move 10x faster:

1. **Content Shield** — Your SaaS play. MVP is done. Next step: get users.
2. **Palm Springs Paradise** — Your game play. Prototype is done. Next step: VFX/sound, then launch on Roblox.

Everything else can be archived. Archived repos aren't deleted — they're frozen. You can come back to them anytime.

---

## How to Archive a Repo on GitHub

1. Go to the repo on GitHub
2. Click **Settings** (tab at the top)
3. Scroll to the bottom → **Danger Zone**
4. Click **Archive this repository**
5. Confirm

Archived repos become read-only. All code, issues, and PRs are preserved. You can unarchive at any time.

---

*Generated March 20, 2026 — Iron Forge Studios repo cleanup guide*
