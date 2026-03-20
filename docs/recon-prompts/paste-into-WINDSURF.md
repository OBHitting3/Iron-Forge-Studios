# Windsurf Recon Prompt

## What This Is
Karl (OBHitting3) is doing a full audit of his dev environment. He's got 8 GitHub repos, fragments everywhere, and needs to know exactly what Windsurf/Codeium can see and has been doing. Nothing is broken or hacked — he just moved fast and needs to map the mess.

## Where To Paste This
Open Windsurf. Open the Cascade AI panel (the chat sidebar). Paste everything below the line into Cascade. Let it run.

---

I need you to do a full recon of everything you can see and access from this Windsurf installation. I'm auditing my entire dev setup — nothing is wrong, I just need to know what's where. Go through every single item below and report what you find. If you can't access something, say so — don't skip it.

## 1. Workspaces
- List every workspace you currently have open.
- List every project in your recent history — anything that shows up under File > Open Recent or in the welcome screen.
- For each one, show the full folder path.

## 2. Windsurf Rules
- Check for `.windsurfrules` files in the current workspace and any workspace you can reach.
- If any exist, show me the full contents.
- Also check for any `.windsurf/` directories and list what's inside.
- Check for a global Windsurf rules file too, if that exists.

## 3. Extensions
- List every extension installed in this Windsurf instance.
- For each one: name, version, enabled or disabled.
- Flag any AI-related extensions — Copilot, Claude, anything overlapping with Codeium's built-in features.

## 4. Accounts
- What account is logged into Windsurf right now?
- What Codeium account is connected? What email? What tier (free, pro, etc.)?
- Is there a GitHub account connected? Which one?
- Are there multiple accounts or profiles configured anywhere?

## 5. Repos and Folders
- List every repo or folder you have access to from this Windsurf installation.
- For each one: full path, remote URL if it's a git repo, current branch, uncommitted changes.
- Check git config (name and email) for each repo — I want to know if different repos have different identities.

## 6. Cascade Conversation History
- List the topics/titles of ALL Cascade conversations you have stored.
- For each one: the date, a one-line summary of what was discussed, and which workspace or project it was connected to.
- Go back as far as the history allows.
- I need the full list — don't summarize or skip older ones.

## 7. Settings and Configuration
- Dump the full contents of Windsurf's settings/configuration file (the equivalent of settings.json).
- If there are user-level and workspace-level settings, show both.
- Flag anything that looks custom or non-default.

## 8. Codeium Account Settings
- Show all Codeium-specific settings and configuration.
- What language servers or features are enabled?
- Is there a Codeium API key or token stored? (Don't show the full key — just confirm yes/no and show first/last 4 characters.)
- What Codeium features are turned on (autocomplete, chat, search, etc.)?

## 9. API Keys and Integrations
- Check for any configured API keys in settings — OpenAI, Anthropic, or anything else.
- Don't show full keys — just tell me which services have keys and first/last 4 characters.
- Check for any other integrations (Jira, Linear, Notion, GitHub, etc.).

## How To Format Your Response

Structure your response exactly like this:

```
=== WINDSURF RECON REPORT ===
Date: [today's date]
Machine: [computer name/OS]

--- WORKSPACES ---
[findings]

--- WINDSURF RULES ---
[findings]

--- EXTENSIONS ---
[findings]

--- ACCOUNTS ---
[findings]

--- REPOS & FOLDERS ---
[findings]

--- CASCADE CONVERSATION HISTORY ---
[findings]

--- SETTINGS DUMP ---
[findings]

--- CODEIUM SETTINGS ---
[findings]

--- API KEYS & INTEGRATIONS ---
[findings]

--- THINGS I COULDN'T ACCESS ---
[list anything you were blocked from checking]

--- RED FLAGS OR ODDITIES ---
[anything that looks weird, duplicated, or worth investigating]
```

After you generate the report, save it to a file called `windsurf-recon-report.md` in the current workspace so I can grab it later.
