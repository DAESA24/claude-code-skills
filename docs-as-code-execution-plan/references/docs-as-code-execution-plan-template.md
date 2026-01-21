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

---

## Execution Instructions

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

```bash
echo "=== ROLLBACK PROCEDURE ==="

# Undo operations in reverse order
# <step 1>
# <step 2>

echo "SUCCESS: Rollback complete"
```

---

## Completion Checklist

- [ ] All phases executed successfully
- [ ] All success criteria verified
- [ ] No rollback required
- [ ] Documentation updated (if applicable)

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

---

## Dev Agent Record

- **Executed By:** <agent name>
- **Execution Date:** <YYYY-MM-DD HH:MM>
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
