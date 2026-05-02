# Windsurf Recon Prompt

## What This Is
Karl (GitHub: OBHitting3) is doing a full inventory of his dev setup. He's got 8 repos, things are scattered everywhere, and he needs to know what Windsurf specifically can see and has been doing. Nothing is broken or hacked — he just moved fast and needs to get organized.

## How To Use This
1. Open Windsurf
2. Open Cascade (the AI chat panel)
3. Paste everything below the line into Cascade
4. Let it run
5. Copy the full response and save it to a file called `windsurf-recon-report.md` in your Iron-Forge-Studios/docs/ folder so you can bring it back

---

## PASTE EVERYTHING BELOW THIS LINE INTO WINDSURF CASCADE

I need you to do a full inventory of everything you can see and access from where you're sitting. I'm cleaning up my setup — nothing is broken, I just need to know what's here. Go through each section below and report what you find. If you can't access something, say so — that's useful info too.

Format your response as a structured report with clear headers for each section.

### 1. Workspaces and Projects
- What workspace/folder am I currently in?
- What other workspaces or projects does Windsurf know about? Check recent folders, recent workspaces, or any workspace history you can access.
- Are there multiple workspaces configured?

### 2. Windsurf Rules
- Check for `.windsurfrules` files in the current workspace root and any subdirectories.
- Check for any `.windsurf/` directories.
- Check for any `rules/` or `.rules/` directories that Windsurf uses.
- If any rules files exist, show me their full contents.

### 3. Git Repos and Branches
- What git repo is the current workspace connected to?
- List ALL branches (local and remote) for every repo you can see.
- Show the remote URLs (origin, upstream, etc.) for each repo.
- What's the status of each repo — clean, dirty, uncommitted changes?

### 4. Extensions
- List every extension installed in Windsurf.
- Flag any AI-related extensions specifically (Copilot, Claude, Codeium, etc.).
- Note any extensions that overlap or conflict with Windsurf's built-in AI features.

### 5. Accounts and Login
- What account am I logged into Windsurf with?
- What Codeium account is connected (email, username, plan tier)?
- Is there more than one profile or account configured?
- What GitHub account(s) are connected?
- Are there any other service accounts linked (Google, GitLab, etc.)?

### 6. Cascade Conversation History
- List the topics or titles of my recent Cascade conversations.
- How far back does the history go?
- Are there conversations tied to different workspaces or projects?
- Were any conversations about setting up repos, configuring things, or creating projects? Summarize those briefly.

### 7. Settings and Configuration
- Dump the full contents of Windsurf's settings (the user-level settings.json or equivalent).
- Check for workspace-level settings too.
- What AI model is configured as the default?
- What features are turned on or off (autocomplete, inline suggestions, etc.)?

### 8. API Keys and Integrations
- Are there any API keys configured in Windsurf settings? (Don't show the actual key values — just tell me what services have keys set up.)
- Is Codeium using its own API key or the built-in subscription?
- Any integrations with external services configured?

### 9. File Access
- What folders and files can you currently see and access?
- Run a quick check — can you see files outside the current workspace?
- List the top-level structure of the current workspace.

### 10. Anything Else
- Anything weird, duplicated, or out of place that you notice?
- Multiple configs pointing to different things?
- Settings that look like they were auto-generated vs. manually set?
- Any sign of other AI tools having left config files behind?

Put it all in one clean report. Be thorough. If a section comes up empty, say "Nothing found" — don't skip it.
