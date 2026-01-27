---
name: skill-enhance
description: Generates and executes skill enhancement plans using declarative project configuration and validation loop protocols.
version: 1.1.0
---

# Skill Enhancement Workflow

Generate execution plans for enhancing Claude Code skills based on project-specific configuration.

## Arguments

$ARGUMENTS - Path to the approved feature backlog item (e.g., `feature-backlog-staging/my-feature-2026-01-23.md`)

## Quick Reference

| Action | Trigger |
|--------|---------|
| Generate plan | `/skill-enhance <backlog-item-path>` |
| Execute plan | "Execute the plan at `<plan-path>`" |
| List backlog items | `/skill-enhance` (no arguments) |

## Prerequisites

This skill requires a `skill-dev-config.yaml` file in the project root. If missing, the skill will:

1. Display a clear error message
2. Explain what the config is for
3. Point to the template location: `~/.claude/skills/skill-enhance/assets/templates/skill-dev-config.yaml`
4. **Stop** - do not proceed without config

## If No Arguments Provided

If `$ARGUMENTS` is empty:

1. **Read `skill-dev-config.yaml`** from project root
2. **Locate feature backlog** using `project_structure.feature_backlog` path
3. **List available items** - files with `status: approved` or `status: captured`
   - **EXCLUDE** terminal status: `implemented`, `deferred`, `rejected`
   - **EXCLUDE** files with `x-` prefix (archived items)
4. **Present options** - numbered list with titles and status
5. **Ask for selection** - "Which feature backlog item should I create an enhancement plan for?"
6. **Proceed** with selected item

## Generation Workflow

### Step 0: Read Project Configuration

1. **Load `skill-dev-config.yaml`** from project root
2. **Validate required fields:**
   - `skill_name` - non-empty
   - `skill_id` - non-empty, matches directory name convention
   - `installation.installed_path` - path exists
   - `skill_files.update_order` - non-empty array
3. **If validation fails:** Report specific errors and stop
4. **Extract:**
   - Skill metadata (name, description, status)
   - Installation path for file reads
   - Update order for dependency checking
   - Project structure paths

### Step 1: Input Quality Review

Before validating frontmatter, review the backlog item's structural completeness:

1. **Read the backlog item** at the provided path
2. **Check for expected sections:**
   - [ ] `## Problem Statement` - What issue this solves
   - [ ] `## Requirements` - Explicit list of MUST/SHOULD requirements
   - [ ] `## Implementation Phases` - Phases with file targets and ordering
   - [ ] `## Acceptance Criteria` - Verifiable completion conditions
   - [ ] File references point to correct skill files
3. **If gaps found:**
   - Present summary: "This backlog item is missing: [list]"
   - Offer: "Should I suggest additions to improve it, or proceed as-is?"
   - If user wants improvements: suggest additions, wait for approval, apply edits
4. **If complete:** Proceed to Step 2

### Step 2: Validate Feature Backlog Item (Frontmatter)

1. Verify required frontmatter:
   - `doc_type: feature-backlog-item`
   - `status: approved` or `captured`
2. If status is `captured`, ask if user wants to approve it first
3. Extract key information:
   - Title
   - Problem statement
   - Core requirements
   - Proposed implementation phases

### Step 3: Read Current Skill Files

Read files from `installation.installed_path` in the order specified by `skill_files.update_order`:

```
For each file in update_order:
  - Read current content
  - Note existing structure and conventions
  - Identify modification points
```

Also read the project CLAUDE.md for structural conventions.

### Step 4: Perform Dependency Check

Compare proposed changes against existing content:

| Existing Content | Proposed Change | Conflict Status |
|------------------|-----------------|-----------------|
| (from skill files) | (from backlog) | Additive / Conflict / Breaking |

Flag potential conflicts for review before proceeding.

### Step 5: Generate Execution Plan

Create execution plan with these structural requirements:

**YAML Front Matter:**

```yaml
---
doc_type: skill-enhancement-plan
title: <Feature Title> - Skill Enhancement
created: <today YYYY-MM-DD>
status: draft
agent: dev
execution_mode: validation-loop
user_intervention: minimal
source_feature: <path to feature backlog item>
skill_config: skill-dev-config.yaml
tags:
  - skill-enhancement
  - <skill-id>
---
```

**Required Sections:**

1. **Header** - Purpose, Audience (Claude Code), User Intervention level
2. **Execution Protocol** - Include the full validation loop protocol (template below)
3. **Phase Overview** - Table of phases with file targets
4. **Problem Statement** - From feature backlog item
5. **Pre-Flight Validation** - Check skill files exist, config valid
6. **Phase 1: Dependency Check** - Always first for skill enhancements
7. **Phase 2+: Implementation** - Following `skill_files.update_order`
8. **Final Phase: Validation** - All changes consistent
9. **Rollback Procedure** - How to undo changes
10. **Dev Agent Record** - Empty, filled during execution

**Per-Step Requirements:**

- `**Autonomous:** YES/NO` marker
- Clear actions with expected outcomes
- `**Validation Checklist:**` with `- [ ]` checkboxes
- `**Report:** "STEP X.Y COMPLETE: <summary>"` format

**Execution Protocol Template (MANDATORY - include verbatim in generated plans):**

The following protocol section MUST be included in every generated execution plan, immediately after the Header section. This ensures the protocol is in Claude's attention window during execution, not buried in a reference file.

````markdown
## Execution Protocol: Validation Loop (MANDATORY)

This plan follows the **validation-loop protocol**. The plan file is the operational hub - updates happen in THIS FILE, not just verbally.

### Core Principles (from Manus Context Engineering)

1. **Filesystem as External Memory** - This file is Claude's "working memory on disk"
2. **Attention Manipulation** - Re-reading goals keeps them in attention window after many tool calls
3. **Keep Failure Traces** - Errors logged here build knowledge, don't hide them

### The Loop - Non-Negotiable Steps

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

### Example Execution Flow

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

### What NOT to Do

| Anti-Pattern | Correct Behavior |
|--------------|------------------|
| Execute all phases, then mark checkboxes | Mark each checkbox immediately after step |
| Report completion verbally without editing file | Edit file FIRST, then report |
| Retry silently on error | Log error to file, then retry |
| Read plan once at start | Re-read before each phase |
| Stuff findings in context | Store in file, reference by path |

### Recovery Protocol

If execution is interrupted mid-phase:

1. Read this plan file
2. Find last checked `[x]` item
3. Resume from next unchecked `[ ]` item
4. Do NOT restart from beginning

### Completion Protocol

When all phases complete:

1. Fill in "Dev Agent Record" section completely
2. Archive source feature backlog item:
   - Set `status: implemented` in frontmatter
   - Add `implemented_date: [today]` in frontmatter
   - Rename file with `x-` prefix
   - Create `_feature-backlog-staging/archive/` if it doesn't exist
   - Move renamed file to `_feature-backlog-staging/archive/`
3. Archive this enhancement plan:
   - Update YAML front matter `status: complete`
   - Rename file with `x-` prefix
   - Create `docs/archive/` if it doesn't exist
   - Move renamed plan to `docs/archive/`
4. Report final summary to user
````

### Step 6: Save Execution Plan

1. Determine filename: `YYYY-MM-DD-<topic>-skill-enhancement-plan.md`
2. Get save path from `project_structure.execution_plans`
3. Check for existing files (add `-v2` version suffix if needed)
4. Save the plan

### Step 7: Update Feature Backlog Item

1. Add `execution_plan: <path>/<filename>` to frontmatter
2. If status was `captured`, update to `approved` with `approved_date`
3. Do NOT change to `implemented` - that happens after execution

### Step 8: Report Summary

Report:
- Execution plan location
- Number of phases
- Any dependency conflicts found
- Feature backlog updated with `execution_plan` reference
- Next step: "Review the plan, then say 'Execute the plan at `<path>`'"

## Execution Protocol

When executing a generated skill enhancement plan, follow the **validation loop protocol**. This is critical - the plan file is a living document, not read-only instructions.

### Core Principles

1. **Read Before Decide** - Read the plan section before each phase
2. **Update After Act** - Edit the plan file to mark `[x]` after each step
3. **Log Errors** - Record errors in the plan's "Errors Encountered" section
4. **Plan is Operational Hub** - Updates happen in the file, not just verbally

### Execution Behavior

**Before each phase:**
- Read the relevant section of the execution plan
- Refresh goals and acceptance criteria in context

**After completing each step:**
- Edit the plan file to mark `[x]` on completed checkboxes
- Update validation checklists in the plan
- Report completion in chat

**At completion:**
- Fill in the "Dev Agent Record" section
- Archive the source feature backlog item:
  - Set `status: implemented` and `implemented_date: <today>`
  - Rename with `x-` prefix
  - Create `_feature-backlog-staging/archive/` if needed
  - Move to archive subdirectory
- Archive this enhancement plan:
  - Update status to `complete` in YAML front matter
  - Rename with `x-` prefix
  - Create `docs/archive/` if needed
  - Move to archive subdirectory

See `reference.md` for detailed protocol and `examples.md` for worked example.

## Error Handling

### Missing Config

```
ERROR: No skill-dev-config.yaml found in project root.

This skill requires a configuration file that declares:
- Skill metadata (name, ID, status)
- Installation path for the global skill
- File update order for dependency checking
- Project structure paths

Template location:
  ~/.claude/skills/skill-enhance/assets/templates/skill-dev-config.yaml

Copy the template to your project root and customize it.
```

### Invalid Config

Report specific validation errors:
- Which required field is missing
- What the expected value format is
- Path to template for reference

### Circular Dependency

If working in `skill-enhance-dev/` itself:

```
NOTE: This project is for developing the skill-enhance skill itself.
Using /skill-enhance here would create a circular dependency.

For self-enhancement, manually follow the workflow steps or use
the feature-backlog-staging workflow directly.
```

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.1.0 | 2026-01-26 | Enhanced validation loop protocol: Generated plans now include full protocol inline (Manus principles, non-negotiable steps, anti-patterns table, recovery/completion protocols) |
| 1.0.0 | 2026-01-23 | Initial release with generation workflow, execution protocol, and config-based project structure |
