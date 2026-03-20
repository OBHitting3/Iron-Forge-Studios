# Cursor Recon Prompt

## What This Is
Karl (OBHitting3) is doing a full audit of his dev environment. He's got 8 GitHub repos, fragments everywhere, and needs to know exactly what Cursor can see and has been doing. Nothing is broken or hacked — he just moved fast and needs to map the mess.

## Where To Paste This
Open Cursor. Hit `Cmd+L` (Mac) or `Ctrl+L` (Windows/Linux) to open the AI chat panel. Paste everything below the line into that chat. Let it run.

---

I need you to do a full recon of everything you can see and access from this Cursor installation. I'm auditing my entire dev setup — nothing is wrong, I just need to know what's where. Go through every single item below and report what you find. If you can't access something, say so — don't skip it.

## 1. Workspaces and Projects
- List every workspace or project you currently have open.
- List every project in your "Recent" list — the stuff that shows up when I hit File > Open Recent.
- For each one, show the full folder path.

## 2. Cursor Rules
- Check for `.cursorrules` files in the current workspace and any other workspace you can reach.
- If any exist, show me the full contents of each one.
- Also check for `.cursor/` directories and list what's inside them.

## 3. Branches Across All Repos
- For every git repo you can see, list ALL branches (local and remote).
- Flag any branches that have "cursor" in the name or look like they were auto-created.
- Show which branch is currently checked out in each repo.

## 4. AI Models and Agents
- What AI models are currently configured in this Cursor installation? (GPT-4, Claude, etc.)
- Which one is the default?
- Are there any custom model configurations or API keys set up?
- List any agent configurations — background agents, custom agents, anything.

## 5. Background Agent Runs
- List ALL background agent runs — completed, in progress, failed, everything.
- For each one, show: when it ran, what repo/branch it touched, what it was asked to do, and whether it succeeded.
- This is important — I need the full history.

## 6. Extensions
- List every extension installed in this Cursor instance.
- For each one, show: name, version, whether it's enabled or disabled.
- Flag any AI-related extensions specifically (Copilot, Claude, Codeium, anything like that).

## 7. User Profiles and Accounts
- What user account is logged into Cursor right now?
- Is there a Cursor Pro/subscription associated with it?
- Check if there are multiple profiles or accounts configured.
- What GitHub account is connected? What email is associated with it?

## 8. Git Access
- List every repo you have git access to — both local clones and remote connections.
- For each repo: show the remote URL, the current branch, and whether there are uncommitted changes.
- Check if there are multiple git identities configured (different name/email combos in different repos).

## 9. API Keys and Integrations
- Check Cursor settings for any configured API keys (OpenAI, Anthropic, etc.).
- Don't show the full keys — just tell me which services have keys configured and the first/last 4 characters.
- List any other integrations (Jira, Linear, Notion, etc.) if configured.

## 10. Full Settings Dump
- Dump the entire contents of Cursor's `settings.json` file.
- If there's both a user-level and workspace-level settings file, show both.
- Flag anything that looks custom or non-default.

## 11. Recent Activity Timeline
- Show me a timeline of recent activity in Cursor — files opened, commands run, conversations with AI, commits made.
- Go back as far as you can.
- I'm especially interested in the October 2025 through March 2026 timeframe.

## How To Format Your Response

Structure your response exactly like this:

```
=== CURSOR RECON REPORT ===
Date: [today's date]
Machine: [computer name/OS]

--- WORKSPACES & PROJECTS ---
[findings]

--- CURSOR RULES ---
[findings]

--- BRANCHES ---
[findings]

--- AI MODELS & AGENTS ---
[findings]

--- BACKGROUND AGENT RUNS ---
[findings]

--- EXTENSIONS ---
[findings]

--- USER PROFILES & ACCOUNTS ---
[findings]

--- GIT ACCESS ---
[findings]

--- API KEYS & INTEGRATIONS ---
[findings]

--- SETTINGS DUMP ---
[findings]

--- RECENT ACTIVITY TIMELINE ---
[findings]

--- THINGS I COULDN'T ACCESS ---
[list anything you were blocked from checking]

--- RED FLAGS OR ODDITIES ---
[anything that looks weird, duplicated, or worth investigating]
```

After you generate the report, save it to a file called `cursor-recon-report.md` in the current workspace so I can grab it later.
