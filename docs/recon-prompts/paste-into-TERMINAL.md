# Terminal Recon Commands

## What This Is
Karl (GitHub: OBHitting3) is doing a full inventory of his dev setup. These are commands you run yourself in your terminal — no AI tool needed. Just open a terminal, paste the commands, and save the output.

## How To Use This
1. Open your terminal (the regular one on your Mac/PC, not inside an editor)
2. Run the commands section by section — or run the big all-in-one script at the bottom
3. The all-in-one script saves everything to `~/Iron-Forge-Studios/docs/terminal-recon-report.txt` automatically

**Easiest approach:** Copy the full script at the bottom, paste it into your terminal, and it does all the work.

---

## Section by Section (if you want to run them one at a time)

### 1. All Your GitHub Repos
This lists every repo tied to your GitHub account.
```bash
gh repo list OBHitting3 --limit 50
```

### 2. Branches in Each Repo
This checks every repo for all its branches. Shows you where work is scattered.
```bash
for repo in $(gh repo list OBHitting3 --limit 50 --json name -q '.[].name'); do
  echo "=== $repo ==="
  gh api repos/OBHitting3/$repo/branches --jq '.[].name'
  echo ""
done
```

### 3. Git Config for Each Local Repo
This finds every git repo on your machine and shows who it thinks you are.
```bash
find ~ -name ".git" -type d -maxdepth 5 2>/dev/null | while read gitdir; do
  repo_path=$(dirname "$gitdir")
  echo "=== $repo_path ==="
  git -C "$repo_path" config user.name 2>/dev/null
  git -C "$repo_path" config user.email 2>/dev/null
  git -C "$repo_path" remote -v 2>/dev/null
  echo ""
done
```

### 4. SSH Keys
This shows what SSH keys exist on your machine and who they're for.
```bash
echo "=== SSH Keys ==="
ls -la ~/.ssh/ 2>/dev/null
echo ""
echo "=== SSH Config ==="
cat ~/.ssh/config 2>/dev/null || echo "No SSH config file found"
echo ""
echo "=== Key Fingerprints ==="
for key in ~/.ssh/*.pub; do
  echo "--- $key ---"
  ssh-keygen -lf "$key" 2>/dev/null
done
```

### 5. User Accounts on This Machine
```bash
echo "=== Current User ==="
whoami
echo ""
echo "=== All Users With Home Directories ==="
ls /Users/ 2>/dev/null || ls /home/ 2>/dev/null
```

### 6. Find All .env Files
These are files that hold passwords, API keys, and secrets. Good to know where they all are.
```bash
find ~ -name ".env" -o -name ".env.local" -o -name ".env.production" -o -name ".env.development" 2>/dev/null | head -50
```

### 7. AI Tool Config Directories
This checks which AI coding tools have left config folders on your machine.
```bash
echo "=== AI Tool Configs ==="
for dir in .claude .cursor .windsurf .codeium .copilot .continue .aider .tabnine; do
  if [ -d "$HOME/$dir" ]; then
    echo "FOUND: ~/$dir"
    ls -la "$HOME/$dir" 2>/dev/null
  else
    echo "NOT FOUND: ~/$dir"
  fi
  echo ""
done
```

### 8. Editor App Config Locations
These are the bigger config folders that Cursor, Windsurf, and VS Code use.
```bash
for app_name in Cursor Windsurf Code; do
  for base in "$HOME/.config" "$HOME/Library/Application Support"; do
    if [ -d "$base/$app_name" ]; then
      echo "FOUND: $base/$app_name"
      find "$base/$app_name" -name "settings.json" -maxdepth 3 2>/dev/null
    fi
  done
done
```

### 9. Browser Profiles
Shows what browser profiles exist — useful for checking if there are multiple logins.
```bash
echo "=== Chrome Profiles ==="
ls "$HOME/Library/Application Support/Google/Chrome/" 2>/dev/null | grep -i "profile\|default" || \
ls "$HOME/.config/google-chrome/" 2>/dev/null | grep -i "profile\|default" || \
echo "No Chrome profiles found"
echo ""

echo "=== Firefox Profiles ==="
ls "$HOME/Library/Application Support/Firefox/Profiles/" 2>/dev/null || \
ls "$HOME/.mozilla/firefox/" 2>/dev/null || \
echo "No Firefox profiles found"
echo ""

echo "=== Edge Profiles ==="
ls "$HOME/Library/Application Support/Microsoft Edge/" 2>/dev/null | grep -i "profile\|default" || \
ls "$HOME/.config/microsoft-edge/" 2>/dev/null | grep -i "profile\|default" || \
echo "No Edge profiles found"
```

### 10. Global Packages
What tools are installed system-wide.
```bash
echo "=== npm Global Packages ==="
npm list -g --depth=0 2>/dev/null
echo ""
echo "=== pip/pip3 Packages ==="
pip3 list 2>/dev/null || pip list 2>/dev/null || echo "No pip found"
echo ""
echo "=== Homebrew Packages (Mac only) ==="
brew list 2>/dev/null || echo "No Homebrew found"
```

### 11. Docker
```bash
echo "=== Docker Containers ==="
docker ps -a 2>/dev/null || echo "Docker not running or not installed"
echo ""
echo "=== Docker Images ==="
docker images 2>/dev/null || echo "Docker not running or not installed"
```

### 12. Disk Usage
Shows where the big stuff is on your machine.
```bash
echo "=== Disk Usage by Top-Level Home Directories ==="
du -sh ~/* 2>/dev/null | sort -rh | head -20
echo ""
echo "=== Total Disk Usage ==="
df -h / 2>/dev/null
```

---

## ALL-IN-ONE SCRIPT

Copy and paste this entire block into your terminal. It runs everything above and saves the output to a file automatically.

```bash
REPORT="$HOME/Iron-Forge-Studios/docs/terminal-recon-report.txt"
mkdir -p "$(dirname "$REPORT")"

{
echo "============================================"
echo "  TERMINAL RECON REPORT"
echo "  Generated: $(date)"
echo "  User: $(whoami)"
echo "  Machine: $(hostname)"
echo "============================================"
echo ""

echo "###################################"
echo "# 1. GITHUB REPOS"
echo "###################################"
gh repo list OBHitting3 --limit 50 2>&1
echo ""

echo "###################################"
echo "# 2. BRANCHES PER REPO"
echo "###################################"
for repo in $(gh repo list OBHitting3 --limit 50 --json name -q '.[].name' 2>/dev/null); do
  echo "=== $repo ==="
  gh api repos/OBHitting3/$repo/branches --jq '.[].name' 2>&1
  echo ""
done

echo "###################################"
echo "# 3. LOCAL GIT REPOS AND CONFIG"
echo "###################################"
find ~ -name ".git" -type d -maxdepth 5 2>/dev/null | while read gitdir; do
  repo_path=$(dirname "$gitdir")
  echo "=== $repo_path ==="
  echo "User: $(git -C "$repo_path" config user.name 2>/dev/null)"
  echo "Email: $(git -C "$repo_path" config user.email 2>/dev/null)"
  git -C "$repo_path" remote -v 2>/dev/null
  echo "Status: $(git -C "$repo_path" status --short 2>/dev/null | wc -l | tr -d ' ') changed files"
  echo ""
done

echo "###################################"
echo "# 4. SSH KEYS"
echo "###################################"
ls -la ~/.ssh/ 2>/dev/null || echo "No .ssh directory found"
echo ""
cat ~/.ssh/config 2>/dev/null || echo "No SSH config file"
echo ""
for key in ~/.ssh/*.pub; do
  [ -f "$key" ] && echo "--- $key ---" && ssh-keygen -lf "$key" 2>/dev/null
done
echo ""

echo "###################################"
echo "# 5. USER ACCOUNTS"
echo "###################################"
echo "Current: $(whoami)"
ls /Users/ 2>/dev/null || ls /home/ 2>/dev/null
echo ""

echo "###################################"
echo "# 6. ENV FILES"
echo "###################################"
find ~ -maxdepth 5 \( -name ".env" -o -name ".env.*" \) -not -path "*/node_modules/*" 2>/dev/null | head -50
echo ""

echo "###################################"
echo "# 7. AI TOOL CONFIGS"
echo "###################################"
for dir in .claude .cursor .windsurf .codeium .copilot .continue .aider .tabnine; do
  if [ -d "$HOME/$dir" ]; then
    echo "FOUND: ~/$dir"
    ls "$HOME/$dir" 2>/dev/null
  else
    echo "NOT FOUND: ~/$dir"
  fi
done
echo ""

echo "###################################"
echo "# 8. EDITOR APP CONFIGS"
echo "###################################"
for app_name in Cursor Windsurf Code; do
  for base in "$HOME/.config" "$HOME/Library/Application Support"; do
    if [ -d "$base/$app_name" ]; then
      echo "FOUND: $base/$app_name"
      find "$base/$app_name" -name "settings.json" -maxdepth 3 2>/dev/null
    fi
  done
done
echo ""

echo "###################################"
echo "# 9. BROWSER PROFILES"
echo "###################################"
for browser_path in \
  "$HOME/Library/Application Support/Google/Chrome" \
  "$HOME/.config/google-chrome" \
  "$HOME/Library/Application Support/Firefox/Profiles" \
  "$HOME/.mozilla/firefox" \
  "$HOME/Library/Application Support/Microsoft Edge" \
  "$HOME/.config/microsoft-edge"; do
  if [ -d "$browser_path" ]; then
    echo "FOUND: $browser_path"
    ls "$browser_path" 2>/dev/null | grep -i "profile\|default" | head -10
  fi
done
echo ""

echo "###################################"
echo "# 10. GLOBAL PACKAGES"
echo "###################################"
echo "--- npm ---"
npm list -g --depth=0 2>/dev/null
echo ""
echo "--- pip ---"
pip3 list 2>/dev/null | head -30 || echo "No pip3"
echo ""

echo "###################################"
echo "# 11. DOCKER"
echo "###################################"
docker ps -a 2>/dev/null || echo "Docker not running or not installed"
echo ""
docker images 2>/dev/null || echo ""
echo ""

echo "###################################"
echo "# 12. DISK USAGE"
echo "###################################"
du -sh ~/* 2>/dev/null | sort -rh | head -20
echo ""
df -h / 2>/dev/null
echo ""

echo "============================================"
echo "  END OF REPORT"
echo "============================================"
} > "$REPORT" 2>&1

echo ""
echo "Done! Report saved to: $REPORT"
echo "Lines in report: $(wc -l < "$REPORT")"
echo ""
echo "Bring that file back to whatever AI tool you're working in so it can see the full picture."
```
