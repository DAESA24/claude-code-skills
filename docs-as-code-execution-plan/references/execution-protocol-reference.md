# Execution Protocol Reference

- **Purpose:** Authoritative rules for executing docs-as-code plans
- **Audience:** Claude Code (autonomous execution agent)
- **Source:** Manus context engineering principles

---

## Core Principles

### 1. Filesystem as External Memory

> "Markdown is my 'working memory' on disk."

The plan file IS your working memory. Treat it as the source of truth, not your internal context. After many tool calls, your context drifts - the file doesn't.

### 2. Attention Manipulation Through Repetition

> After ~50 tool calls, models forget original goals ("lost in the middle" effect).

**Solution:** Re-read the plan file before each phase. This brings goals back into your attention window.

### 3. Keep Failure Traces

> "Error recovery is one of the clearest signals of TRUE agentic behavior."

**Solution:** Log errors to the plan file BEFORE retrying. This builds knowledge and enables recovery.

---

## Critical Rules

### 1. Read Before Each Phase

Before starting any phase, read that phase's section in the plan file. This refreshes your goals.

### 2. Mark Checkboxes Immediately

After completing each step, edit the plan file to mark the checkbox `[x]`. Do NOT batch updates.

### 3. Log Errors Before Retrying

If an error occurs, log it to the "Errors Encountered" section IMMEDIATELY. Then attempt resolution.

### 4. Store, Don't Stuff

Large outputs go to files, not context. Keep only paths in working memory.

### 5. Update Status Progressively

Update the plan's status as you complete phases. This enables recovery from interruptions.

---

## What NOT to Do

| Anti-Pattern | Correct Behavior |
|--------------|------------------|
| Execute all phases, then mark checkboxes | Mark each checkbox immediately after step |
| Report completion verbally without editing file | Edit file FIRST, then report |
| Retry silently on error | Log error to file, then retry |
| Read plan once at start | Re-read before each phase |
| Stuff findings in context | Store in file, reference by path |
| Batch multiple steps together | Execute and validate one step at a time |
| Skip validation steps | Complete ALL validation before next step |

---

## Recovery Protocol

If execution is interrupted mid-phase:

1. Read the plan file
2. Find last checked `[x]` item
3. Resume from next unchecked `[ ]` item
4. Do NOT restart from beginning

---

## Completion Protocol

When all phases complete:

1. Fill in "Dev Agent Record" section completely
2. Update plan status to `complete` in YAML front matter
3. Archive to `docs/archives/` if applicable
4. Report final summary to user

---

## Source

Based on Manus context engineering principles:
https://manus.im/de/blog/Context-Engineering-for-AI-Agents-Lessons-from-Building-Manus
