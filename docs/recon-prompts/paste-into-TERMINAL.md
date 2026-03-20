# Terminal Recon Commands

## What This Is
Karl (OBHitting3) is doing a full audit of his dev environment. This file is a list of commands you run in your terminal yourself. No AI needed — just copy, paste, run, and read the output.

## How To Use This
1. Open your terminal (Terminal app on Mac, or the built-in terminal in any editor).
2. Copy each block of commands and paste it in.
3. The output gets saved to a file called `terminal-recon-report.txt` on your Desktop.
4. Each section appends to that file, so run them in order and you'll have one big report at the end.

## Before You Start
Pick where the report goes. This assumes your Desktop. If you want it somewhere else, change the path in the very first command.

```bash
# Set the report file location — change this if you want it somewhere else
RECON_FILE="$HOME/Desktop/terminal-recon-report.txt"
echo "=== TERMINAL RECON REPORT ===" > "$RECON_FILE"
echo "Date: $(date)" >> "$RECON_FILE"
echo "Machine: $(uname -a)" >> "$RECON_FILE"
echo "User: $(whoami)" >> "$RECON_FILE"
echo "" >> "$RECON_FILE"
```

---

## 1. All GitHub Repos for OBHitting3
This uses the GitHub CLI (`gh`). If you don't have it installed, run `brew install gh` (Mac) or check https://cli.github.com first.

```bash
echo "--- GITHUB REPOS ---" >> "$RECON_FILE"
gh repo list OBHitting3 --limit 50 --json name,url,defaultBranch,isPrivate,updatedAt 2>> "$RECON_FILE" >> "$RECON_FILE"
echo "" >> "$RECON_FILE"
```

## 2. All Branches in Each Repo
This clones nothing — it just peeks at the remote branches for each repo.

```bash
echo "--- BRANCHES PER REPO ---" >> "$RECON_FILE"
for repo in $(gh repo list OBHitting3 --limit 50 --json name -q '.[].name'); do
  echo "" >> "$RECON_FILE"
  echo "REPO: $repo" >> "$RECON_FILE"
  echo "Remote branches:" >> "$RECON_FILE"
  git ls-remote --heads "https://github.com/OBHitting3/$repo" 2>/dev/null | awk '{print "  " $2}' | sed 's|refs/heads/||' >> "$RECON_FILE"
done
echo "" >> "$RECON_FILE"
```

## 3. Git Config for Each Local Repo
This finds every git repo on your machine and shows who git thinks you are in each one.

```bash
echo "--- GIT CONFIGS (LOCAL REPOS) ---" >> "$RECON_FILE"
find "$HOME" -maxdepth 4 -name ".git" -type d 2>/dev/null | while read gitdir; do
  repo_path="$(dirname "$gitdir")"
  echo "" >> "$RECON_FILE"
  echo "Repo: $repo_path" >> "$RECON_FILE"
  echo "  user.name: $(git -C "$repo_path" config user.name 2>/dev/null || echo 'not set')" >> "$RECON_FILE"
  echo "  user.email: $(git -C "$repo_path" config user.email 2>/dev/null || echo 'not set')" >> "$RECON_FILE"
  echo "  remote.origin.url: $(git -C "$repo_path" config remote.origin.url 2>/dev/null || echo 'no remote')" >> "$RECON_FILE"
  echo "  current branch: $(git -C "$repo_path" branch --show-current 2>/dev/null || echo 'unknown')" >> "$RECON_FILE"
done
echo "" >> "$RECON_FILE"
```

## 4. SSH Keys
Shows what SSH keys exist and what accounts they might belong to.

```bash
echo "--- SSH KEYS ---" >> "$RECON_FILE"
echo "Keys found in ~/.ssh/:" >> "$RECON_FILE"
ls -la "$HOME/.ssh/" 2>/dev/null >> "$RECON_FILE"
echo "" >> "$RECON_FILE"
echo "SSH config file:" >> "$RECON_FILE"
cat "$HOME/.ssh/config" 2>/dev/null >> "$RECON_FILE" || echo "  No SSH config file found" >> "$RECON_FILE"
echo "" >> "$RECON_FILE"
echo "Testing GitHub SSH connection:" >> "$RECON_FILE"
ssh -T git@github.com 2>&1 >> "$RECON_FILE"
echo "" >> "$RECON_FILE"
```

## 5. User Accounts on This Machine
```bash
echo "--- USER ACCOUNTS ---" >> "$RECON_FILE"
echo "Current user: $(whoami)" >> "$RECON_FILE"
echo "All users with home directories:" >> "$RECON_FILE"
ls -la /Users/ 2>/dev/null >> "$RECON_FILE" || ls -la /home/ 2>/dev/null >> "$RECON_FILE"
echo "" >> "$RECON_FILE"
```

## 6. Find All .env Files
These are config files that often hold passwords and API keys. Good to know where they all are.

```bash
echo "--- .ENV FILES ---" >> "$RECON_FILE"
find "$HOME" -maxdepth 5 -name ".env*" -not -path "*/node_modules/*" -not -path "*/.git/*" 2>/dev/null >> "$RECON_FILE"
echo "" >> "$RECON_FILE"
```

## 7. AI Tool Config Directories
Checks for config folders from every AI coding tool.

```bash
echo "--- AI TOOL CONFIGS ---" >> "$RECON_FILE"
for dir in ".claude" ".cursor" ".windsurf" ".codeium" ".copilot" ".continue" ".tabnine" ".github-copilot"; do
  echo "" >> "$RECON_FILE"
  echo "Checking ~/$dir:" >> "$RECON_FILE"
  if [ -d "$HOME/$dir" ]; then
    echo "  EXISTS" >> "$RECON_FILE"
    find "$HOME/$dir" -type f 2>/dev/null | head -20 >> "$RECON_FILE"
  else
    echo "  Not found" >> "$RECON_FILE"
  fi
done
echo "" >> "$RECON_FILE"

# Also check for AI rules files in repos
echo "AI rules files found:" >> "$RECON_FILE"
find "$HOME" -maxdepth 5 \( -name ".cursorrules" -o -name ".windsurfrules" -o -name "CLAUDE.md" -o -name ".github-copilot*" \) -not -path "*/node_modules/*" 2>/dev/null >> "$RECON_FILE"
echo "" >> "$RECON_FILE"
```

## 8. Recent File Modifications (Oct 2025 - Mar 2026)
Shows what was being worked on and when.

```bash
echo "--- RECENT FILE ACTIVITY (Oct 2025 - Mar 2026) ---" >> "$RECON_FILE"
echo "Files modified in project directories:" >> "$RECON_FILE"
find "$HOME" -maxdepth 5 \( -name "*.js" -o -name "*.ts" -o -name "*.py" -o -name "*.json" -o -name "*.md" \) \
  -not -path "*/node_modules/*" -not -path "*/.git/*" -not -path "*/dist/*" -not -path "*/.next/*" \
  -newer "$HOME" -printf "%T+ %p\n" 2>/dev/null | sort -r | head -100 >> "$RECON_FILE"
# On Mac, use this instead if the above doesn't work:
# find "$HOME" -maxdepth 5 \( -name "*.js" -o -name "*.ts" -o -name "*.py" -o -name "*.json" -o -name "*.md" \) \
#   -not -path "*/node_modules/*" -not -path "*/.git/*" \
#   -exec stat -f "%Sm %N" -t "%Y-%m-%d %H:%M" {} \; 2>/dev/null | sort -r | head -100 >> "$RECON_FILE"
echo "" >> "$RECON_FILE"
```

## 9. Browser Profiles
Shows what browser profiles exist — useful for knowing which Google/GitHub accounts are logged in where.

```bash
echo "--- BROWSER PROFILES ---" >> "$RECON_FILE"

# Chrome (Mac)
echo "Chrome profiles:" >> "$RECON_FILE"
if [ -d "$HOME/Library/Application Support/Google/Chrome" ]; then
  ls -d "$HOME/Library/Application Support/Google/Chrome/"Profile* "$HOME/Library/Application Support/Google/Chrome/Default" 2>/dev/null >> "$RECON_FILE"
fi
# Chrome (Linux)
if [ -d "$HOME/.config/google-chrome" ]; then
  ls -d "$HOME/.config/google-chrome/"Profile* "$HOME/.config/google-chrome/Default" 2>/dev/null >> "$RECON_FILE"
fi

echo "" >> "$RECON_FILE"
echo "Firefox profiles:" >> "$RECON_FILE"
cat "$HOME/Library/Application Support/Firefox/profiles.ini" 2>/dev/null >> "$RECON_FILE" \
  || cat "$HOME/.mozilla/firefox/profiles.ini" 2>/dev/null >> "$RECON_FILE" \
  || echo "  Not found" >> "$RECON_FILE"

echo "" >> "$RECON_FILE"
echo "Edge profiles:" >> "$RECON_FILE"
if [ -d "$HOME/Library/Application Support/Microsoft Edge" ]; then
  ls -d "$HOME/Library/Application Support/Microsoft Edge/"Profile* "$HOME/Library/Application Support/Microsoft Edge/Default" 2>/dev/null >> "$RECON_FILE"
elif [ -d "$HOME/.config/microsoft-edge" ]; then
  ls -d "$HOME/.config/microsoft-edge/"Profile* "$HOME/.config/microsoft-edge/Default" 2>/dev/null >> "$RECON_FILE"
else
  echo "  Not found" >> "$RECON_FILE"
fi
echo "" >> "$RECON_FILE"
```

## 10. Global Packages
Shows what tools are installed system-wide.

```bash
echo "--- GLOBAL PACKAGES ---" >> "$RECON_FILE"

echo "npm global packages:" >> "$RECON_FILE"
npm list -g --depth=0 2>/dev/null >> "$RECON_FILE" || echo "  npm not found" >> "$RECON_FILE"
echo "" >> "$RECON_FILE"

echo "pip packages:" >> "$RECON_FILE"
pip list 2>/dev/null >> "$RECON_FILE" || pip3 list 2>/dev/null >> "$RECON_FILE" || echo "  pip not found" >> "$RECON_FILE"
echo "" >> "$RECON_FILE"

echo "Homebrew packages (if on Mac):" >> "$RECON_FILE"
brew list 2>/dev/null >> "$RECON_FILE" || echo "  brew not found or not on Mac" >> "$RECON_FILE"
echo "" >> "$RECON_FILE"
```

## 11. Docker
```bash
echo "--- DOCKER ---" >> "$RECON_FILE"
echo "Docker containers (running):" >> "$RECON_FILE"
docker ps 2>/dev/null >> "$RECON_FILE" || echo "  Docker not running or not installed" >> "$RECON_FILE"
echo "" >> "$RECON_FILE"
echo "Docker containers (all):" >> "$RECON_FILE"
docker ps -a 2>/dev/null >> "$RECON_FILE" || echo "  Docker not running or not installed" >> "$RECON_FILE"
echo "" >> "$RECON_FILE"
echo "Docker images:" >> "$RECON_FILE"
docker images 2>/dev/null >> "$RECON_FILE" || echo "  Docker not running or not installed" >> "$RECON_FILE"
echo "" >> "$RECON_FILE"
```

## 12. Disk Usage
Shows where the space is going. Good for finding big project folders.

```bash
echo "--- DISK USAGE ---" >> "$RECON_FILE"
echo "Top-level directories by size:" >> "$RECON_FILE"
du -sh "$HOME"/*/ 2>/dev/null | sort -rh | head -20 >> "$RECON_FILE"
echo "" >> "$RECON_FILE"
echo "Total disk usage:" >> "$RECON_FILE"
df -h 2>/dev/null >> "$RECON_FILE"
echo "" >> "$RECON_FILE"
```

## 13. Global Git Config
```bash
echo "--- GLOBAL GIT CONFIG ---" >> "$RECON_FILE"
echo "Global git config:" >> "$RECON_FILE"
git config --global --list 2>/dev/null >> "$RECON_FILE"
echo "" >> "$RECON_FILE"
echo "Git credential helpers:" >> "$RECON_FILE"
git config --global credential.helper 2>/dev/null >> "$RECON_FILE" || echo "  None configured" >> "$RECON_FILE"
echo "" >> "$RECON_FILE"
```

## Wrap It Up
```bash
echo "=== END OF RECON REPORT ===" >> "$RECON_FILE"
echo "" >> "$RECON_FILE"
echo "Report saved to: $RECON_FILE"
echo "File size: $(du -h "$RECON_FILE" | cut -f1)"
```

## After You Run Everything
The full report is at `~/Desktop/terminal-recon-report.txt`. Open it up, skim through it, and bring it back to whatever AI tool you're working with for analysis.
