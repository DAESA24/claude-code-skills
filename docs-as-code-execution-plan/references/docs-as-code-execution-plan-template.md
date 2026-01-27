---
title: <Operation Name>
created: <YYYY-MM-DD>
status: draft  # draft | in-progress | complete | failed | rolled-back
agent: dev
execution_mode: docs-as-code
user_intervention: minimal  # none | minimal | moderate | heavy
tags:
  - <tag1>
  - <tag2>
---

# <Operation Name> Execution Plan

- **Purpose:** <1-sentence goal>
- **Audience:** Claude Code (autonomous execution agent)
- **User Intervention:** Only for steps marked with approval indicator
- **Plan Location:** `docs/YYYY-MM-DD-<project-slug>/YYYY-MM-DD-<project-slug>-execution-plan.md`

---

## Execution Protocol: Validation Loop (MANDATORY)

This plan follows the **validation-loop protocol**. The plan file is the operational hub - updates happen in THIS FILE, not just verbally.

### The Loop - Non-Negotiable Steps

**BEFORE each phase:**

1. Read this plan file (or the relevant phase section)
2. Refresh goals and acceptance criteria in attention window

**AFTER completing each step:**

1. Edit THIS FILE to mark the checkbox `[x]`
2. Do NOT batch checkbox updates - mark IMMEDIATELY after each step

**AFTER completing a phase:**

1. Verify all checkboxes in the phase are marked `[x]`
2. Report: "PHASE N COMPLETE: [summary]"
3. Read the next phase section before proceeding

**If an error occurs:**

1. Log the error in "Errors Encountered" section IMMEDIATELY
2. Then attempt resolution

### Recovery

If interrupted, find last `[x]` item and resume from next unchecked `[ ]` item.

---

## Execution Instructions

**Note:** Follow the Execution Protocol above. These instructions supplement the validation-loop protocol.

- Execute steps SEQUENTIALLY in exact order listed
- Complete ALL validation substeps before proceeding to next step
- If ANY validation fails, STOP immediately and report failure
- Do NOT skip validation steps
- Do NOT batch multiple steps together
- Report results after EACH step completion
- When steps contain `- [ ]` checkboxes, EDIT THIS FILE to mark them `- [x]` as each item is verified
- If parallelization annotations are present, evaluate whether to spawn sub-agents (see Pattern 7 in guide)

---

## Test Plan Summary

| Phase | Test Method | Success Indicator | Result |
|-------|-------------|-------------------|--------|
| Pre-Flight | Run bash script | All success messages | Pending |
| Phase 1 | <method> | <indicator> | Pending |
| Phase 2 | <method> | <indicator> | Pending |
| ... | ... | ... | Pending |

---

## Problem Statement

<Describe the problem being solved>

### Current State

<What exists now>

### Target State

<What should exist after execution>

---

## Errors Encountered

- (None yet - errors will be logged here during execution)

---

## Risk Assessment

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| <risk1> | Low/Medium/High | Low/Medium/High | <mitigation> |
| <risk2> | Low/Medium/High | Low/Medium/High | <mitigation> |

---

## Pre-Flight Validation

**Autonomous:** YES

```bash
echo "=== PRE-FLIGHT CHECKS ==="

# Git Safety Check (Pattern 8)
echo "--- Git Safety Check ---"

if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "⚠️ WARNING: Not a git repository"
    echo "   No automatic rollback point available"
    echo "   Proceed with caution or initialize git first"
    # Note: Plan execution continues but rollback will be manual
else
    # Check for uncommitted changes
    if ! git diff --quiet HEAD 2>/dev/null || ! git diff --cached --quiet 2>/dev/null; then
        echo "⚠️ UNCOMMITTED CHANGES DETECTED"
        echo ""
        git status --short
        echo ""
        echo "Recommended: Create a commit before proceeding"
        echo "Options:"
        echo "  1. Run: git add -A && git commit -m 'chore: pre-execution snapshot'"
        echo "  2. Run: git stash"
        echo "  3. Abort and handle manually"
        echo ""
        echo "🚨 USER ACTION REQUIRED - choose an option before continuing"
        exit 1
    fi

    # Record rollback point
    PRE_EXEC_COMMIT=$(git rev-parse HEAD)
    echo "✅ Rollback point: $PRE_EXEC_COMMIT"
fi
echo ""

# Skills Submodule Check (for skill enhancement plans)
# Only run if plan modifies files in ~/.claude/skills/
SKILLS_DIR="$HOME/.claude/skills"
if [ -d "$SKILLS_DIR/.git" ] || [ -f "$SKILLS_DIR/.git" ]; then
    echo "--- Skills Submodule Git Check ---"
    cd "$SKILLS_DIR"

    if ! git diff --quiet HEAD 2>/dev/null || ! git diff --cached --quiet 2>/dev/null; then
        echo "⚠️ UNCOMMITTED CHANGES IN SKILLS SUBMODULE"
        echo ""
        git status --short
        echo ""
        echo "Recommended: Create a commit before proceeding"
        echo "Options:"
        echo "  1. Run: git add -A && git commit -m 'chore: pre-execution snapshot'"
        echo "  2. Run: git stash"
        echo "  3. Abort and handle manually"
        echo ""
        echo "🚨 USER ACTION REQUIRED - choose an option before continuing"
        exit 1
    fi

    PRE_EXEC_SKILL_COMMIT=$(git rev-parse HEAD)
    echo "✅ Skills submodule rollback point: $PRE_EXEC_SKILL_COMMIT"
    cd - > /dev/null
fi
echo ""

# Initialize execution log (Pattern 10)
echo "--- Initialize Execution Log ---"
LOG_DIR="docs/YYYY-MM-DD-<project-slug>"
LOG_FILE="$LOG_DIR/YYYY-MM-DD-<project-slug>-execution-log.jsonl"

# Create log directory if needed
mkdir -p "$LOG_DIR"

# Write execution_start event
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
cat >> "$LOG_FILE" <<EOF
{"event":"execution_start","ts":"$TIMESTAMP","plan_path":"$LOG_DIR/YYYY-MM-DD-<project-slug>-execution-plan.md","plan_title":"<Operation Name>","pre_exec_commit":"$PRE_EXEC_COMMIT","pre_exec_skill_commit":"${PRE_EXEC_SKILL_COMMIT:-null}"}
EOF

echo "✅ Execution log initialized at $LOG_FILE"
echo ""

# Define paths
# <define all paths used in the plan>

# Check 1: <prerequisite>
if [ <condition> ]; then
    echo "SUCCESS: <check passed>"
else
    echo "ERROR: <check failed>"
    exit 1
fi

# Check 2: <prerequisite>
# ...

echo ""
echo "SUCCESS: Pre-flight checks passed"
echo "========================================"
```

**Success Criteria:**

- <list verifiable conditions>

---

## Phase 1: <Phase Name>

**Autonomous:** YES
<!-- Optional parallelization fields (remove if not using sub-agents):
**Dependencies:** None | Depends on: X.Y
**Parallelizable:** YES | NO
-->

```bash
echo ""
echo "=== PHASE 1: <PHASE NAME> ==="
echo ""

# <implementation>

echo ""
echo "SUCCESS: Phase 1 Complete - <summary>"
echo "========================================"
```

**Log Events to Emit:**

```bash
# Emit at phase start
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
echo "{\"event\":\"phase_start\",\"ts\":\"$TIMESTAMP\",\"phase\":N,\"name\":\"<Phase Name>\",\"autonomous\":true}" >> "$LOG_FILE"

# Emit after each tool call (example for bash)
echo "{\"event\":\"tool_call\",\"ts\":\"$TIMESTAMP\",\"tool\":\"Bash\",\"command\":\"<cmd>\",\"exit_code\":$?,\"duration_ms\":<ms>}" >> "$LOG_FILE"

# Emit at phase completion
echo "{\"event\":\"phase_complete\",\"ts\":\"$TIMESTAMP\",\"phase\":N,\"report\":\"PHASE N COMPLETE: <summary>\"}" >> "$LOG_FILE"
```

**Expected Results:** (optional)

- <measurable outcome>

<!-- Optional for parallelizable steps:
**Output Artifacts:**
- File: `<path/to/output>`

**Orchestrator Verification:**
```bash
# Commands orchestrator runs to validate sub-agent work
[ -f "<path/to/output>" ] && echo "✅ Output exists"
```
-->

**Validation Checklist:**

- [ ] <verifiable condition>
- [ ] <verifiable condition>

**Instruction:** Mark each checkbox in this file as validation is confirmed.

**Report:** "STEP 1.N COMPLETE: <summary with key metrics>"

---

## Phase 2: <Phase Name>

**Autonomous:** YES/NO
<!-- Optional phase-level parallelization summary:
**Parallelization:** Steps X.1, X.2, X.3 can run concurrently (no dependencies)
**Sequential requirement:** Step X.4 must wait for X.1-X.3 completion
-->

<!-- If NO, include: -->
### USER APPROVAL REQUIRED

**What will happen:**

- <destructive action description>

**Safety measures:**

- Backup verified
- Rollback available

**Reversibility:** <how to undo>

Proceed? (yes/no)

```bash
# <implementation>
```

**Expected Results:** (optional)

- <measurable outcome>

**Validation Checklist:**

- [ ] <verifiable condition>
- [ ] <verifiable condition>

**Instruction:** Mark each checkbox in this file as validation is confirmed.

**Report:** "STEP 2.N COMPLETE: <summary with key metrics>"

<!--
GUIDANCE: Add a Phase Validation step at the end of each phase:

### STEP X.N: Validate Phase X Completion

**Autonomous:** YES

**Actions:**
- Compare current state to expected state
- Verify all phase objectives met

**Expected Results:**
- [List what should be true after phase completes]

**Validation Checklist:**
- [ ] All phase objectives verified

**Report:** "STEP X.N COMPLETE: Phase X validation passed"
-->

---

## Rollback Procedure

If a rollback point was captured during pre-flight:

```bash
echo "=== ROLLBACK PROCEDURE ==="

# Step 1: Git reset to pre-execution state (if available)
if [ -n "$PRE_EXEC_COMMIT" ]; then
    echo "Resetting to pre-execution commit: $PRE_EXEC_COMMIT"
    git reset --hard "$PRE_EXEC_COMMIT"
    echo "✅ Git state restored"
else
    echo "⚠️ No pre-execution commit recorded"
    echo "   Manual rollback required"
fi

# Step 1b: Git reset skills submodule (if applicable)
if [ -n "$PRE_EXEC_SKILL_COMMIT" ]; then
    echo "Resetting skills submodule to: $PRE_EXEC_SKILL_COMMIT"
    cd ~/.claude/skills
    git reset --hard "$PRE_EXEC_SKILL_COMMIT"
    echo "✅ Skills submodule restored"
    cd - > /dev/null
fi

# Step 2: Undo plan-specific operations in reverse order
# <step 1>
# <step 2>

echo "✅ Rollback complete"
```

---

## Completion Checklist

- [ ] All phases executed successfully
- [ ] All success criteria verified
- [ ] No rollback required
- [ ] Documentation updated (if applicable)
- [ ] Execution log finalized (execution_complete event written)
- [ ] Execution summary generated from log

---

## Acceptance Criteria

- [ ] <primary goal achieved>
- [ ] <secondary goal achieved>
- [ ] <no regressions introduced>

---

## Agent Execution Notes

### Critical Execution Requirements

1. <rule specific to this plan>
2. <rule specific to this plan>

### Preservation Targets

- <files/directories that must NOT change>

### Safe Modification Targets

- <files/directories the plan may alter>

### Execution Trigger

- **Trigger phrase:** "execute the <plan name>"
- **Plan location:** `<path/to/plan.md>`
- **Resume guidance:** If interrupted, re-read this file and continue from last incomplete step.

### Parallelization Assessment

<!-- Claude fills this in during plan creation -->
**Decision:** [Viable - see annotations above | Not viable]
**Rationale:** [Brief explanation of why parallelization is or isn't appropriate for this plan]

---

## Dev Agent Record

- **Executed By:** <agent name>
- **Execution Date:** <YYYY-MM-DD HH:MM>
- **Pre-Execution Commit:** <commit SHA or "N/A - not a git repo">
- **Pre-Execution Skill Commit:** <skills submodule SHA or "N/A - not applicable">
- **Duration:** <actual duration>

### Execution Notes

<Summary of execution>

### Issues Encountered

| Issue | Resolution |
|-------|------------|
| <issue> | <resolution> |

### Procedural Learnings

1. <learning for future reference>
2. <learning for future reference>

---

- **Document Status:** <status>
- **Last Updated:** <YYYY-MM-DD>
- **Related Docs:** <links>
