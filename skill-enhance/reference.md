# Execution Protocol Reference

This document defines the validation loop protocol for executing skill enhancement plans. This is the canonical documentation for the protocol that gets embedded inline in generated execution plans.

## Why This Protocol Exists

Without explicit execution discipline, Claude may:

- Report completions verbally but not update the plan file
- Lose track of progress in long execution sessions
- Leave the plan in an inconsistent state
- Forget acceptance criteria mid-execution

The validation loop solves these problems by treating the plan file as "working memory on disk."

## Core Principles (from Manus Context Engineering)

These principles come from the [Manus context engineering pattern](https://manus.im/de/blog/Context-Engineering-for-AI-Agents-Lessons-from-Building-Manus):

### 1. Filesystem as External Memory

The plan file is Claude's "working memory on disk." State persists in the file, not in conversation context.

### 2. Attention Manipulation

Re-reading goals keeps them in the attention window after many tool calls. Goals drift out of context; reading brings them back.

### 3. Keep Failure Traces

Errors logged in the plan build knowledge for future executions. Don't hide errors - document them.

### 4. Plan is Operational Hub

The plan file is **not** read-only instructions. It is a living document that evolves during execution.

| Wrong Mental Model | Correct Mental Model |
|--------------------|----------------------|
| Plan = instructions I follow | Plan = state I maintain |
| Report progress in chat | Record progress in file |
| Plan is static | Plan is updated |

## The Loop - Non-Negotiable Steps

This is the core execution loop. Every phase follows this pattern.

**BEFORE each phase:**

```text
1. Read this plan file (or the relevant phase section)
2. Refresh goals and acceptance criteria in attention window
3. Confirm you understand what the phase requires
```

**DURING each phase:**

```text
1. Execute the actions listed
2. If an error occurs:
   - DO NOT silently retry
   - Log the error in "Errors Encountered" section IMMEDIATELY
   - Then attempt resolution
```

**AFTER completing each step within a phase:**

```text
1. Edit THIS FILE to mark the checkbox [x]
2. Do NOT batch checkbox updates - mark IMMEDIATELY after each step
3. This creates a recoverable state if interrupted
```

**AFTER completing a phase:**

```text
1. Verify all checkboxes in the phase are marked [x]
2. Update the Status section (if present)
3. Report: "PHASE N COMPLETE: [summary]"
4. Read the next phase section before proceeding
```

## Example Execution Flow

```text
Claude: [Reads Phase 2 section]
Claude: "Starting Phase 2: [Phase Name]"
Claude: [Executes action 1]
Claude: [Edits plan] - marks first checkbox [x]
Claude: [Executes action 2]
Claude: [Edits plan] - marks second checkbox [x]
...
Claude: [All actions complete]
Claude: [Verifies all checkboxes marked]
Claude: "PHASE 2 COMPLETE: [summary of what was done]"
Claude: [Reads Phase 3 section]
```

## What NOT to Do (Anti-Patterns)

| Anti-Pattern | Correct Behavior |
|--------------|------------------|
| Execute all phases, then mark checkboxes | Mark each checkbox immediately after step |
| Report completion verbally without editing file | Edit file FIRST, then report |
| Retry silently on error | Log error to file, then retry |
| Read plan once at start | Re-read before each phase |
| Stuff findings in context | Store in file, reference by path |

### Detailed Anti-Pattern Examples

**Verbal-Only Completion:**

- **Wrong:** "I've completed Step 3.2."
- **Right:** *[Edits plan file to mark [x]]* "Step 3.2 complete: Added workflow section."

**Batch Updates:**

- **Wrong:** *[Completes steps 3.1, 3.2, 3.3, then marks all at once]*
- **Right:** *[Mark each step immediately after completing it]*

**Skipping Validation:**

- **Wrong:** *[Makes edit, moves to next step]*
- **Right:** *[Makes edit, checks validation items, marks them, then moves on]*

## Recovery Protocol

If execution is interrupted mid-phase:

1. Read this plan file
2. Find last checked `[x]` item
3. Resume from next unchecked `[ ]` item
4. Do NOT restart from beginning

### User Pauses Execution

If user says "pause" or "stop":

1. Complete current step if safe to do so
2. Update plan with current state
3. Note in plan: "Paused at Step X.Y by user request"
4. Acknowledge in chat

### Resuming After Pause

When user says "resume" or "continue":

1. Read plan file
2. Find last completed step
3. Resume from next unchecked step
4. Continue normal execution loop

### Session Boundary

If execution spans multiple sessions:

1. Ensure plan file is up to date before session ends
2. Create handoff if appropriate (see planning-with-files skill)
3. Next session: Read plan, find current state, resume

## Completion Protocol

When all phases complete:

1. Fill in "Dev Agent Record" section completely:
   - Execution date
   - Total phases completed
   - Any errors encountered
   - Final notes

2. Update source feature backlog item:
   - Set `status: implemented`
   - Add `implemented_date: [today]`
   - Rename file with `x-` prefix

3. Report final summary to user

## Validation Checklists

Each step should have a validation checklist. These are **also** updated in the plan file.

Example in plan:

```markdown
### Step 3.2: Update SKILL.md

- [ ] Add new workflow section
- [ ] Update description to reflect changes
- [ ] Verify frontmatter unchanged

**Validation Checklist:**
- [ ] Skill still validates with skills-ref
- [ ] No duplicate sections created
- [ ] Formatting consistent with existing content
```

After completion:

```markdown
### Step 3.2: Update SKILL.md

- [x] Add new workflow section
- [x] Update description to reflect changes
- [x] Verify frontmatter unchanged

**Validation Checklist:**
- [x] Skill still validates with skills-ref
- [x] No duplicate sections created
- [x] Formatting consistent with existing content
```

## Relationship to Generated Plans

Generated execution plans include the full validation loop protocol inline. This ensures the protocol is in Claude's attention window during execution, not buried in this reference file.

This reference document serves as:
- Canonical documentation of the protocol
- Background reading for understanding the "why"
- Reference for edge cases not covered in the inline template

See: planning-with-files skill for the general pattern this protocol extends.
