# VS Code Recon Prompt

## What This Is
Karl (GitHub: OBHitting3) is doing a full inventory of his dev setup. He's got 8 repos, things are scattered everywhere, and he needs to know what VS Code specifically can see and has been doing. Nothing is broken or hacked — he just moved fast and needs to get organized.

## How To Use This
1. Open VS Code
2. Open whatever AI chat you have in VS Code — Copilot Chat, Claude extension, or any other AI assistant
3. Paste everything below the line into that chat
4. Let it run
5. Copy the full response and save it to a file called `vscode-recon-report.md` in your Iron-Forge-Studios/docs/ folder so you can bring it back

---

## PASTE EVERYTHING BELOW THIS LINE INTO VS CODE AI CHAT

I need you to do a full inventory of everything you can see and access from where you're sitting inside VS Code. I'm cleaning up my setup — nothing is broken, I just need to know what's here. Go through each section below and report what you find. If you can't access something, say so — that's useful info too.

Format your response as a structured report with clear headers for each section.

### 1. Workspaces and Recent Folders
- What workspace/folder am I currently in?
- List all recent workspaces and folders VS Code knows about (check the Welcome tab or recent files list).
- Are there any multi-root workspaces configured (.code-workspace files)?

### 2. Installed Extensions
- List every extension installed in VS Code.
- Specifically flag these categories:
  - AI extensions (Copilot, Claude, Codeium, Cursor-related, any others)
  - Git extensions (GitLens, Git Graph, etc.)
  - Language/framework extensions
  - Anything else notable
- Are any extensions disabled but still installed?
- Are there any extensions that look duplicated or conflicting?

### 3. User Profiles
- What VS Code profiles exist on this machine?
- Which profile am I currently using?
- Do different profiles have different extensions or settings?
- List what's in each profile if there are multiple.

### 4. GitHub and Account Connections
- What GitHub account(s) are connected to VS Code?
- Is GitHub Copilot logged in? To what account?
- Are there any other accounts connected (Microsoft, GitLab, etc.)?
- Check the Accounts panel — list everything there.

### 5. Git Repos and Branches
- What git repo(s) does VS Code currently see?
- List ALL branches (local and remote) for each visible repo.
- Show the remote URLs for each repo.
- What's the status of each repo — clean, dirty, uncommitted changes?
- Check the Source Control panel for any pending changes.

### 6. Settings
- Dump the full contents of the user-level `settings.json`.
- Check for workspace-level settings — look for `.vscode/settings.json` in the current project.
- Are there any settings that reference AI tools, API keys, or external services? (Don't show actual key values — just name the services.)
- What's the configured default formatter, theme, and terminal?

### 7. .vscode Folders
- Check the current workspace for a `.vscode/` folder.
- If it exists, list everything in it (settings.json, launch.json, extensions.json, tasks.json, etc.).
- Show the contents of each file you find in there.
- If you can check other recent workspaces for .vscode folders, do that too.

### 8. AI Extension Configurations
- For each AI extension installed, report:
  - What account it's logged into
  - What model(s) are configured
  - Any custom instructions or rules files it uses
  - Whether it's active or disabled
- Check specifically for:
  - GitHub Copilot settings and status
  - Claude extension settings
  - Codeium extension settings
  - Any other AI tool configs

### 9. Terminal History
- What shell is configured as the default terminal?
- Are there any terminal profiles set up?
- Can you see recent terminal history?

### 10. Anything Else
- Anything weird, duplicated, or out of place that you notice?
- Extensions that seem to conflict with each other?
- Settings that look auto-generated vs. manually configured?
- Config files from AI tools that aren't currently installed?
- Any workspace trust settings worth noting?

Put it all in one clean report. Be thorough. If a section comes up empty, say "Nothing found" — don't skip it.
