# Execution Summary: <Plan Title>

- **Plan:** `<plan-path>`
- **Executed:** YYYY-MM-DD HH:MM - HH:MM (<duration>)
- **Status:** Success | Failed | Rolled Back
- **Phases:** N/N completed
- **Errors:** N encountered, N recovered

## Pre-Execution State

- **Git Commit:** `<pre_exec_commit>`
- **Skills Commit:** `<pre_exec_skill_commit>` (if applicable)
- **Rollback Command:** `git reset --hard <pre_exec_commit>`

## Timeline

| Time | Phase/Step | Event | Details |
|------|------------|-------|---------|
| HH:MM:SS | Pre-Flight | Start | Validation checks |
| HH:MM:SS | Pre-Flight | Complete | All checks passed |
| HH:MM:SS | Phase 1 | Start | <Phase Name> |
| HH:MM:SS | Step 1.1 | Complete | <Report summary> |
| ... | ... | ... | ... |

## Errors Encountered

| Step | Error | Recovery |
|------|-------|----------|
| 1.2 | command_failed: npm install | Created package.json and retried |

(Or: "None")

## Files Modified

| File | Action | Details |
|------|--------|---------|
| `src/config.ts` | edited | 15 lines changed |
| `README.md` | created | 1024 bytes |
| `/path/to/original/` | deleted | 350 files |

## Git Operations

| Time | Operation | Details |
|------|-----------|---------|
| HH:MM:SS | commit | `abc123` - "feat: implement feature X" |

(Or: "None")

## Log File

Full execution log: `<log-filename>.jsonl`

---

- **Generated:** YYYY-MM-DD HH:MM:SS
- **Log Events:** N total
