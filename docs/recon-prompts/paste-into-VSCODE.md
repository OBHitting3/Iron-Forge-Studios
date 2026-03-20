# VS Code Recon Prompt

## What This Is
Karl (OBHitting3) is doing a full audit of his dev environment. He's got 8 GitHub repos, fragments everywhere, and needs to know exactly what VS Code can see and has been doing. Nothing is broken or hacked — he just moved fast and needs to map the mess.

## Where To Paste This
Open VS Code. Open the AI chat panel — this depends on what AI extension you have:
- **GitHub Copilot:** Click the chat icon in the sidebar, or hit `Ctrl+Shift+I` / `Cmd+Shift+I`
- **Claude extension:** Open its chat panel
- **Any other AI chat extension:** Open its panel

Paste everything below the line into the AI chat. Let it run.

---

I need you to do a full recon of everything you can see and access from this VS Code installation. I'm auditing my entire dev setup — nothing is wrong, I just need to know what's where. Go through every single item below and report what you find. If you can't access something, say so — don't skip it.

## 1. Workspaces and Recent Folders
- List every workspace currently open.
- List everything in File > Open Recent — every folder and file VS Code remembers.
- For each, show the full path.
- Check if there are any `.code-workspace` files and show their contents.

## 2. Installed Extensions
- List ALL installed extensions. Every single one.
- For each: name, publisher, version, enabled or disabled.
- Specifically call out all AI-related extensions: GitHub Copilot, Claude, Codeium, Cursor-related, TabNine, anything that provides AI code completion or chat.
- Are any extensions installed but disabled?

## 3. User Profiles
- How many VS Code profiles exist on this machine?
- List each profile by name.
- Which one is currently active?
- Do different profiles have different extensions installed?

## 4. GitHub Accounts
- What GitHub account(s) are connected to VS Code?
- Check the Accounts menu (bottom-left gear icon > Accounts).
- Is GitHub Copilot signed in? Under what account?
- Are there any other service accounts connected (Microsoft, etc.)?

## 5. Git Repos and Branches
- List every git repository VS Code can currently see (in the Source Control panel and any multi-root workspace).
- For each repo: full path, remote URL, current branch, all local branches, all remote branches.
- Check git config (user.name and user.email) for each repo.
- Flag any repos where the git identity doesn't match the others.

## 6. Settings Dump
- Show the full contents of the **user-level** `settings.json`.
- Show the full contents of the **workspace-level** `settings.json` if one exists.
- Flag anything that looks custom, unusual, or non-default.
- Specifically look for: AI-related settings, git settings, terminal settings, theme settings.

## 7. .vscode Folders
- Check every project/folder VS Code knows about for a `.vscode/` directory.
- For each `.vscode/` found, list everything inside it (settings.json, launch.json, extensions.json, tasks.json, etc.).
- Show the contents of each file.

## 8. AI Extension Configurations
- For **GitHub Copilot** (if installed): What account? What settings? Is it active? Chat enabled? What model?
- For **Claude** (if installed): What's configured? API key present (yes/no, don't show it)?
- For **Codeium** (if installed): What account? What settings?
- For **any other AI extension**: Same deal — what's configured?
- Check if multiple AI extensions are competing with each other (both trying to do autocomplete, etc.).

## How To Format Your Response

Structure your response exactly like this:

```
=== VS CODE RECON REPORT ===
Date: [today's date]
Machine: [computer name/OS]

--- WORKSPACES & RECENT FOLDERS ---
[findings]

--- EXTENSIONS (FULL LIST) ---
[findings]

--- AI EXTENSIONS (DETAILED) ---
[findings]

--- USER PROFILES ---
[findings]

--- GITHUB ACCOUNTS ---
[findings]

--- GIT REPOS & BRANCHES ---
[findings]

--- USER SETTINGS.JSON ---
[full contents]

--- WORKSPACE SETTINGS.JSON ---
[full contents, or "none found"]

--- .VSCODE FOLDERS ---
[findings]

--- AI EXTENSION CONFIGS ---
[findings]

--- THINGS I COULDN'T ACCESS ---
[list anything you were blocked from checking]

--- RED FLAGS OR ODDITIES ---
[anything that looks weird, duplicated, or worth investigating]
```

After you generate the report, save it to a file called `vscode-recon-report.md` in the current workspace so I can grab it later.
