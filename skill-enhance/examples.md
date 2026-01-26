# Skill Enhancement Examples

This document shows what proper execution looks like with before/after states.

## Example: Adding Error Handling to a Skill

### Before Execution

```markdown
---
doc_type: skill-enhancement-plan
title: Add Error Handling - Skill Enhancement
created: 2026-01-20
status: draft
agent: dev
execution_mode: validation-loop
source_feature: feature-backlog-staging/error-handling-2026-01-18.md
skill_config: skill-dev-config.yaml
---

# Add Error Handling - Skill Enhancement Plan

## Execution Protocol

Follow the validation loop protocol in reference.md:
- Read each phase before starting
- Edit this file to mark [x] after each step
- Log errors in the Errors Encountered section

## Phase Overview

| Phase | Target File | Purpose |
|-------|-------------|---------|
| 1 | (analysis) | Dependency check |
| 2 | reference.md | Document error patterns |
| 3 | SKILL.md | Add error handling workflow |
| 4 | (validation) | Final consistency check |

## Pre-Flight Validation

- [ ] skill-dev-config.yaml exists and is valid
- [ ] All skill files in update_order exist
- [ ] Source feature backlog item accessible

## Phase 1: Dependency Check

- [ ] Read current SKILL.md content
- [ ] Read current reference.md content
- [ ] Identify existing error handling (if any)
- [ ] Document conflicts or gaps

**Validation Checklist:**
- [ ] No conflicting error handling exists
- [ ] Addition is purely additive

**Report:** "PHASE 1 COMPLETE: <summary>"

## Phase 2: Update reference.md

- [ ] Add "Error Handling Patterns" section
- [ ] Document common error types
- [ ] Add recovery procedures

**Validation Checklist:**
- [ ] New section follows existing formatting
- [ ] No duplicate content created
- [ ] Markdown renders correctly

**Report:** "PHASE 2 COMPLETE: <summary>"

## Phase 3: Update SKILL.md

- [ ] Add error handling to main workflow
- [ ] Add "Error Handling" section with examples
- [ ] Update description if needed

**Validation Checklist:**
- [ ] Skill still validates with skills-ref
- [ ] Error examples are realistic
- [ ] Workflow remains coherent

**Report:** "PHASE 3 COMPLETE: <summary>"

## Phase 4: Final Validation

- [ ] Run skills-ref validate
- [ ] Review all changes for consistency
- [ ] Verify no regressions

**Validation Checklist:**
- [ ] skills-ref validate passes
- [ ] All phases marked complete
- [ ] No open questions remain

**Report:** "PHASE 4 COMPLETE: All changes validated"

## Errors Encountered

(none yet)

## Dev Agent Record

- **Executed:** (pending)
- **Phases Completed:** 0/4
- **Errors:** 0
- **Notes:** (pending)
```

### After Execution

```markdown
---
doc_type: skill-enhancement-plan
title: Add Error Handling - Skill Enhancement
created: 2026-01-20
status: completed
agent: dev
execution_mode: validation-loop
source_feature: feature-backlog-staging/error-handling-2026-01-18.md
skill_config: skill-dev-config.yaml
---

# Add Error Handling - Skill Enhancement Plan

## Execution Protocol

Follow the validation loop protocol in reference.md:
- Read each phase before starting
- Edit this file to mark [x] after each step
- Log errors in the Errors Encountered section

## Phase Overview

| Phase | Target File | Purpose |
|-------|-------------|---------|
| 1 | (analysis) | Dependency check |
| 2 | reference.md | Document error patterns |
| 3 | SKILL.md | Add error handling workflow |
| 4 | (validation) | Final consistency check |

## Pre-Flight Validation

- [x] skill-dev-config.yaml exists and is valid
- [x] All skill files in update_order exist
- [x] Source feature backlog item accessible

## Phase 1: Dependency Check

- [x] Read current SKILL.md content
- [x] Read current reference.md content
- [x] Identify existing error handling (if any)
- [x] Document conflicts or gaps

**Findings:** No existing error handling section. Addition is purely additive.

**Validation Checklist:**
- [x] No conflicting error handling exists
- [x] Addition is purely additive

**Report:** "PHASE 1 COMPLETE: No conflicts found, proceeding with additive changes"

## Phase 2: Update reference.md

- [x] Add "Error Handling Patterns" section
- [x] Document common error types
- [x] Add recovery procedures

**Validation Checklist:**
- [x] New section follows existing formatting
- [x] No duplicate content created
- [x] Markdown renders correctly

**Report:** "PHASE 2 COMPLETE: Added error patterns section to reference.md"

## Phase 3: Update SKILL.md

- [x] Add error handling to main workflow
- [x] Add "Error Handling" section with examples
- [x] Update description if needed

**Validation Checklist:**
- [x] Skill still validates with skills-ref
- [x] Error examples are realistic
- [x] Workflow remains coherent

**Report:** "PHASE 3 COMPLETE: SKILL.md updated with error handling workflow"

## Phase 4: Final Validation

- [x] Run skills-ref validate
- [x] Review all changes for consistency
- [x] Verify no regressions

**Validation Checklist:**
- [x] skills-ref validate passes
- [x] All phases marked complete
- [x] No open questions remain

**Report:** "PHASE 4 COMPLETE: All changes validated, skill passes validation"

## Errors Encountered

- **Step 3.1 initial attempt:** Accidentally duplicated the workflow section. Resolution: Removed duplicate, restructured as subsection.

## Dev Agent Record

- **Executed:** 2026-01-20
- **Phases Completed:** 4/4
- **Errors:** 1 (resolved)
- **Notes:** Error handling added successfully. Minor restructuring needed in Phase 3 to avoid duplication.
```

## Key Differences: Before vs After

| Aspect | Before | After |
|--------|--------|-------|
| Status in frontmatter | `draft` | `completed` |
| Pre-flight checkboxes | `[ ]` | `[x]` |
| Phase step checkboxes | `[ ]` | `[x]` |
| Validation checklists | `[ ]` | `[x]` |
| Errors Encountered | `(none yet)` | Actual errors logged |
| Dev Agent Record | `(pending)` | Filled with execution data |

## Error Logging Pattern

When an error occurs during execution:

### In the Plan File

Add to "Errors Encountered" section:

```markdown
## Errors Encountered

- **Step 2.3 - File not found:** Expected reference.md at configured path but file missing.
  Resolution: Created file with initial structure, then proceeded.

- **Step 3.1 - Validation failed:** skills-ref reported missing description.
  Resolution: Added description to frontmatter, re-validated successfully.
```

### In Chat

Report briefly:
> "Encountered error in Step 2.3: file not found. Created missing file and continuing."

### Key Points

1. **Log immediately** - Don't wait until the end
2. **Include resolution** - How was it handled?
3. **Continue or escalate** - Minor errors: continue. Blocking errors: ask user

## Checkpoint Updates

For long executions, update the plan's Status section at natural breakpoints:

```markdown
## Status

**Currently in Phase 3** - Updating SKILL.md with new workflow sections.
Phases 1-2 complete. No blocking issues.
```

This helps if execution is interrupted - the plan shows exactly where to resume.
