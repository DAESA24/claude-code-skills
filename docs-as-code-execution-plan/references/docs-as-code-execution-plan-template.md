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

```bash
echo ""
echo "=== PHASE 1: <PHASE NAME> ==="
echo ""

# <implementation>

echo ""
echo "SUCCESS: Phase 1 Complete - <summary>"
echo "========================================"
```

**Success Criteria:**

- <verifiable condition>

---

## Phase 2: <Phase Name>

**Autonomous:** YES/NO

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

**Success Criteria:**

- <verifiable condition>

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
