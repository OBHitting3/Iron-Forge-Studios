# Iron Forge Studios — Account & Identity Consolidation Plan

**Date:** March 17, 2026
**Author:** Senior Engineering Review
**Priority:** HIGH — Identity fragmentation creates access-loss risk
**Constraint:** ZERO document or data loss during execution

---

## 1. Current State (Problem)

Four separate credentials detected for Threads (likely mirrored across other services):

| # | Account | Type | Likely Usage |
|---|---------|------|-------------|
| 1 | **Divot** | Username/Password | Personal / gaming alias |
| 2 | **OB_Hitting_3** | Username/Password | Primary dev identity (GitHub, Cursor, Claude Code) |
| 3 | **contact@Ironforge.studio** | Email/Password | Business identity (Iron Forge Studios domain) |
| 4 | **ob.hitting.3.tv@gmail.com** | Email/Password | Gmail — likely recovery email, YouTube, Google services |

### Why This Is a Risk

- **Account lockout:** If you sign into Threads with the wrong identity and change a password, you may lose access to linked services (GitHub, Roblox DevForum, domain admin, etc.)
- **Repo ownership fragmentation:** GitHub repos under `OBHitting3` are tied to a specific email. Changing that email without forwarding breaks push access.
- **Investor-facing inconsistency:** `MARKET-ANALYSIS.md` references `ironforge.studio` domain. If the email behind that domain loses access, investor communications break.
- **Password manager confusion:** Four entries for one service = high chance of using stale credentials.

---

## 2. Documents That MUST Be Preserved (Do Not Touch Until Backed Up)

| Document | Location | Criticality |
|----------|----------|-------------|
| `MARKET-ANALYSIS.md` | Root — 28.7KB | **CRITICAL** — Investor-facing, confidential |
| `WEEKLY-ACTIVITY-SUMMARY.md` | Root — 7.5KB | HIGH — Operational record |
| `index.html` (Prompt Forge) | Root — 14.5KB | MEDIUM — Product demo |
| `src/` (Palm Springs Paradise) | `src/**` — 36 Luau files | **CRITICAL** — Active game codebase |
| `src/ARCHITECTURE.md` | `src/` — 4.8KB | HIGH — Technical documentation |

### Preservation Steps (Execute FIRST, Before Any Account Changes)

1. **Git backup:** Ensure all branches are pushed to remote
   ```bash
   git push -u origin --all
   ```
2. **Local backup:** Create a tarball of the entire repo
   ```bash
   tar -czf ~/Iron-Forge-Studios-backup-$(date +%Y%m%d).tar.gz .
   ```
3. **Export critical docs:** Copy `MARKET-ANALYSIS.md` and `WEEKLY-ACTIVITY-SUMMARY.md` to a separate location (cloud drive, external storage)
4. **Screenshot current GitHub settings:** Capture repo permissions, collaborators, deploy keys, and webhook configs
5. **Verify recovery email access:** Confirm you can receive email at `ob.hitting.3.tv@gmail.com` RIGHT NOW before changing anything

---

## 3. Recommended Identity Architecture

### Primary Identity: `contact@ironforge.studio`
- **Use for:** All business-facing accounts — GitHub org, investor communications, domain admin, Threads (public), LinkedIn
- **Why:** Professional, matches the brand, appears in `MARKET-ANALYSIS.md`

### Development Identity: `OB_Hitting_3` (GitHub username)
- **Use for:** GitHub commits, Cursor, Claude Code branches
- **Why:** Already owns all 8 repos, changing this would break branch history
- **Email behind it:** Should be set to `contact@ironforge.studio` in GitHub settings

### Recovery/Personal: `ob.hitting.3.tv@gmail.com`
- **Use for:** Google account (YouTube, Google Cloud), recovery email for all other accounts
- **Why:** Gmail is the most resilient recovery path

### Retire: `Divot`
- **Action:** Do NOT use for any new sign-ins
- **After consolidation:** Remove from password manager once verified that nothing critical depends on it

---

## 4. Threads-Specific Resolution

For the sign-in screen shown in the screenshot:

1. **Select `OB_Hitting_3`** (not Divot) — this is your public dev identity
2. After signing in, go to Threads Settings → Account → Linked Accounts
3. Verify which Instagram account is linked (this determines your Threads identity)
4. If you want the business brand, link it to the Instagram tied to `contact@ironforge.studio`
5. **Do NOT delete the other Threads accounts yet** — first audit what content/followers exist on each

---

## 5. Execution Order (Safe Sequence)

```
Phase 1: BACKUP (no changes to any accounts)
  ├─ Step 1: Push all git branches to remote
  ├─ Step 2: Create local tarball backup
  ├─ Step 3: Export critical docs to cloud storage
  └─ Step 4: Screenshot all account settings

Phase 2: VERIFY ACCESS (test, don't change)
  ├─ Step 5: Confirm login to GitHub as OBHitting3
  ├─ Step 6: Confirm email receipt at contact@ironforge.studio
  ├─ Step 7: Confirm email receipt at ob.hitting.3.tv@gmail.com
  └─ Step 8: Confirm domain admin access for ironforge.studio

Phase 3: CONSOLIDATE (one change at a time)
  ├─ Step 9: Set GitHub primary email → contact@ironforge.studio
  ├─ Step 10: Set GitHub recovery email → ob.hitting.3.tv@gmail.com
  ├─ Step 11: Sign into Threads with chosen identity
  ├─ Step 12: Update password manager — one entry per service
  └─ Step 13: Remove stale Divot entries from password manager

Phase 4: VERIFY (confirm nothing broke)
  ├─ Step 14: git push a test commit to verify GitHub access
  ├─ Step 15: Verify Cursor/Claude Code still authenticate
  ├─ Step 16: Verify ironforge.studio domain email still works
  └─ Step 17: Verify Threads profile shows correct identity
```

---

## 6. Rollback Plan

If anything breaks during consolidation:

- **GitHub access lost:** Use `ob.hitting.3.tv@gmail.com` as recovery to reset password
- **Domain email lost:** Access domain registrar directly (likely through Gmail account) to fix DNS/MX records
- **Threads locked out:** Instagram recovery flow using the Gmail account
- **Repo data lost:** Restore from tarball backup created in Phase 1

---

## 7. Post-Consolidation Checklist

- [ ] Only ONE credential per service in password manager
- [ ] `contact@ironforge.studio` is primary email on all business accounts
- [ ] `ob.hitting.3.tv@gmail.com` is recovery email everywhere
- [ ] `Divot` removed from all active services
- [ ] All repo documents verified intact (diff against backup)
- [ ] Investor materials (`MARKET-ANALYSIS.md`) still reference correct contact info
- [ ] DNS for `ironforge.studio` configured and resolving

---

*This plan prioritizes zero data loss. Every destructive step has a preceding backup step. Execute phases in order — never skip to Phase 3 without completing Phases 1 and 2.*
