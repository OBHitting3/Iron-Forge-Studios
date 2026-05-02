# Cursor Recon Prompt

## What This Is
Karl (GitHub: OBHitting3) is doing a full inventory of his dev setup. He's got 8 repos, things are scattered everywhere, and he needs to know what Cursor specifically can see and has been doing. Nothing is broken or hacked — he just moved fast and needs to get organized.

## How To Use This
1. Open Cursor
2. Open the AI chat (Cmd+L or Ctrl+L)
3. Paste everything below the line into the chat
4. Let it run
5. Copy the full response and save it to a file called `cursor-recon-report.md` in your Iron-Forge-Studios/docs/ folder so you can bring it back

---

## PASTE EVERYTHING BELOW THIS LINE INTO CURSOR

I need you to do a full inventory of everything you can see and access from where you're sitting. I'm cleaning up my setup — nothing is broken, I just need to know what's here. Go through each section below and report what you find. If you can't access something, say so — that's useful info too.

Format your response as a structured report with clear headers for each section.

### 1. Workspaces and Projects
- What workspace/folder am I currently in?
- What recent workspaces or projects have I opened in Cursor? Check the recent files/folders list.
- Are there multiple workspaces configured?

### 2. Cursor Rules
- Check for `.cursorrules` files in the current workspace root and any subdirectories.
- Check for `.cursor/` directories anywhere in the current project.
- If any rules files exist, show me their full contents.

### 3. Git Repos and Branches
- What git repo is the current workspace connected to?
- List ALL branches (local and remote) for every repo you can see.
- Specifically look for any branches with "cursor" in the name across all repos.
- Show the remote URLs (origin, upstream, etc.) for each repo.
- What's the status of each repo — clean, dirty, uncommitted changes?

### 4. AI Models and Agents
- What AI model am I currently using in Cursor (GPT-4, Claude, etc.)?
- What models are available/configured?
- Are there any custom agent configurations?
- Is there a Cursor API key configured, or am I using the built-in subscription?

### 5. Background Agents
- List ALL background agent runs — active, completed, and failed.
- For each one, show: what it was asked to do, what branch it created (if any), when it ran, and whether it succeeded.
- Are there any background agents running right now?

### 6. Extensions
- List every extension installed in Cursor.
- Flag any AI-related extensions specifically (Copilot, Claude, Codeium, etc.).
- Are any extensions disabled but still installed?

### 7. User Profiles and Accounts
- What account am I logged into Cursor with?
- Is there more than one profile configured?
- What GitHub account(s) are connected?
- Check if there's a Cursor subscription and what tier it is, if you can see that.

### 8. Settings
- Dump the full contents of my Cursor `settings.json` (the user-level one).
- Also check for workspace-level settings (`.vscode/settings.json` or `.cursor/settings.json` in the current project).
- Are there any API keys configured in settings? (Don't show the actual key values — just tell me what services have keys set up.)
- What's my configured default AI model?
- Any custom keybindings related to AI features?

### 9. Recent Activity Timeline
- Show my recent file edit history — what files have I touched recently and roughly when?
- Any recent git commits from this workspace?
- What were the last few things I asked the AI chat to do?

### 10. Anything Else
- Anything weird, duplicated, or out of place that you notice?
- Multiple configs pointing to different things?
- Any red flags about fragmentation or conflicting settings?

Put it all in one clean report. Be thorough. If a section comes up empty, say "Nothing found" — don't skip it.
