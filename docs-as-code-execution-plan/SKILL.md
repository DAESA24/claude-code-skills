---
name: docs-as-code-execution-plan
description: This skill automates the docs-as-code LLM execution pattern for complex, multi-step tasks. Use this skill when creating execution plans for development projects (upgrades, migrations, feature implementations, automation setup), when executing existing execution plans, or when archiving completed plans with lessons learned. Trigger phrases include "create a docs-as-code execution plan", "help me plan this change using a docs-as-code execution plan", "create a docs-as-code plan", "execute this plan" (in context of a docs-as-code plan), or "archive this execution plan" (in context of a docs-as-code plan). (user)
---

# Docs-as-Code Execution Plan Skill

This skill implements the docs-as-code pattern for creating and executing automation plans for complex, multi-step tasks.

## When to Use This Skill

- Creating execution plans for complex changes (upgrades, migrations, feature implementations)
- Executing existing docs-as-code plans autonomously
- Archiving completed plans with lessons learned
- Converting ad-hoc development work into repeatable patterns

## Core Principles

The docs-as-code pattern follows five critical principles:

1. **Pre-Written Scripts** - Write complete bash scripts, not instructions. The LLM executes, doesn't improvise.
2. **Read-Once Architecture** - Include all context upfront. No file exploration during execution.
3. **Explicit Success Criteria** - Every step has programmatically verifiable success conditions.
4. **Minimal Approval Points** - Require approval only for destructive/irreversible operations (marked with a warning indicator).
5. **Built-In Validation** - Check, Execute, Verify pattern for every critical operation.

## Workflow Modes

### Mode 1: Create Execution Plan

To create a new execution plan:

1. **Gather Requirements**
   - Understand the infrastructure change goal
   - Identify current state and target state
   - List all systems/services affected
   - Identify potential risks and rollback needs

2. **Generate Plan Structure**
   - Use the template in `references/docs-as-code-execution-plan-template.md`
   - Fill YAML front matter with project metadata
   - Add Execution Instructions section
   - Define phases (typically 5-10 for complex changes)
   - Write pre-flight validation script
   - Write bash scripts for each phase
   - Add Validation Checklist with checkboxes per step
   - Add Report marker per step
   - Include phase validation step at end of each phase
   - Add Agent Execution Notes section
   - Include rollback procedure

3. **Save Plan**
   - Generate project slug from task description (2-4 kebab-case words)
   - Create project subdirectory: `docs/YYYY-MM-DD-<project-slug>/`
   - Save plan to: `docs/YYYY-MM-DD-<project-slug>/YYYY-MM-DD-<project-slug>-execution-plan.md`
   - Follow the file naming convention (see below)

4. **Post-Draft Parallelization Review**

   Before finalizing the plan, evaluate parallelization potential:

   a. Review Pattern 7 decision criteria in the guide
   b. Assess: Are there 2+ independent tasks in any phase?
   c. Document decision in the plan's Agent Execution Notes section:
      - If parallelizing: Add annotations per the guide, populate parallelization fields
      - If not parallelizing: Add "**Parallelization Assessment:** Not viable - [brief reason]"
   d. Remove unused HTML comment blocks from the plan

   **Required output:** The plan must contain either parallelization annotations OR an explicit "not viable" note in Agent Execution Notes. Plans without this assessment are incomplete.

## File Naming Convention

All execution plans use project subdirectories with consistent naming:

### Directory Pattern

```
docs/YYYY-MM-DD-<project-slug>/
```

### File Patterns

```
YYYY-MM-DD-<project-slug>-execution-plan.md
YYYY-MM-DD-<project-slug>-execution-log.jsonl
YYYY-MM-DD-<project-slug>-execution-summary.md
```

### Rules

| Element | Rule |
|---------|------|
| **Case** | kebab-case (lowercase, hyphens) |
| **Date prefix** | `YYYY-MM-DD` (today's date) |
| **Project slug** | 2-4 words describing the goal |
| **Suffix** | `-execution-plan`, `-execution-log`, `-execution-summary` |
| **Versioning** | `-v2`, `-v3`, etc. only if previous version exists |

### Examples

```
2025-12-03-ollama-startup-fix-execution-plan.md
2025-12-03-ollama-startup-fix-execution-plan-v2.md
2025-12-03-database-migration-setup-execution-plan.md
2025-12-03-openmemory-mcp-integration-execution-plan.md
```

### Version Detection Logic

When creating a new plan, check for existing files with the same topic:

```bash
# Generate base filename
base_name="YYYY-MM-DD-topic-words-execution-plan"
docs_dir="docs"

# Check for existing files
existing=$(ls "$docs_dir"/${base_name}*.md 2>/dev/null)

if [ -z "$existing" ]; then
    # No existing file - use base name
    filename="${base_name}.md"
else
    # Find highest version
    highest_v=$(ls "$docs_dir"/${base_name}*.md | grep -oE 'v[0-9]+' | sort -V | tail -1)
    if [ -z "$highest_v" ]; then
        # Base exists without version - next is v2
        filename="${base_name}-v2.md"
    else
        # Increment version
        next_v=$((${highest_v#v} + 1))
        filename="${base_name}-v${next_v}.md"
    fi
fi
```

### Mode 2: Execute Existing Plan

**Before executing any plan, review `references/execution-protocol-reference.md` for the validation loop protocol.**

To execute an existing execution plan:

1. **Read the entire plan** before starting
2. **Verify git rollback point** (Pattern 8 - Pre-Execution Safety Check)
   - Check if working directory is a git repository
   - If uncommitted changes exist, offer options:
     a. Create pre-execution commit (recommended)
     b. Stash changes
     c. Abort execution
   - Record the pre-execution commit SHA for rollback reference
   - For non-git directories: warn user, require explicit confirmation to proceed
   - **For skill enhancement plans:** Also check `~/.claude/skills/` submodule and record `PRE_EXEC_SKILL_COMMIT`
3. **Check for parallelization annotations**
   - Look for `**Parallelizable:** YES` markers in steps
   - Look for phase-level `**Parallelization:**` summaries
   - If annotations present and orchestrator verification commands exist:
     a. Identify independent task groups
     b. Spawn sub-agents for concurrent execution
     c. After completion, run Orchestrator Verification commands
     d. Report consolidated results before proceeding
   - If no annotations: continue with sequential execution
4. **Follow Execution Instructions** - Execute sequentially, no batching, stop on failure
5. **Run Pre-Flight Validation** - Stop if any check fails
6. **Initialize Execution Log**
   - Create log file in same directory as plan: `<project-dir>/<date>-<slug>-execution-log.jsonl`
   - Write `execution_start` event with plan path, title, and pre-execution commit SHA
   - Log file captures: tool calls, outcomes, durations, errors, validations
7. **Execute phases in order**
   - Mark autonomous phases (`**Autonomous:** YES`) - execute without confirmation
   - Pause at approval points (warning indicator) - wait for user confirmation
   - Edit plan file to mark Validation Checklist checkboxes as items are verified
   - Emit log events during execution (phase_start, tool_call, validation, phase_complete)
8. **Report after each step** using the Report marker format
9. **Verify Validation Checklist** after each step
10. **Update plan status** in YAML front matter as phases complete
11. **Handle failures** - Run rollback if needed, document in Dev Agent Record
12. **Generate Execution Summary**
    - At completion, generate Markdown summary from log
    - Save to: `<project-dir>/<date>-<slug>-execution-summary.md`
    - Summary includes: timeline, errors, files modified, git operations

### Mode 3: Archive Completed Plan

To archive a completed execution plan:

1. **Update YAML front matter** - Set `status: complete` or `status: failed`
2. **Complete Dev Agent Record section**
   - Execution date and duration
   - Issues encountered and resolutions
   - Procedural learnings for future reference
3. **Move to archives** - `docs/archives/` folder
4. **Extract procedural learnings** to OpenMemory (if available):
   ```bash
   opm add "Learning text" --tags "procedural,infrastructure,<project>"
   ```

## Status Prefixes

Use these prefixes in bash script output for LLM parsing:

- Success indicator - Success
- Error indicator - Error (stop execution)
- Warning indicator - Warning (continue with caution)
- Info indicator - Information
- Skip indicator - Skipped (step not needed)
- Approval indicator - User approval required

## Execution Logging

During plan execution, a JSONL log captures every significant event.

### Log File Location

```
docs/YYYY-MM-DD-<project-slug>/YYYY-MM-DD-<project-slug>-execution-log.jsonl
```

### Event Types Captured

| Event | When |
|-------|------|
| `execution_start` | Before pre-flight, records rollback commit |
| `phase_start/complete` | Phase boundaries |
| `step_start/complete` | Step boundaries |
| `tool_call` | After each tool use (with duration) |
| `validation` | After each checkbox verification |
| `error` | When errors occur (with recovery action) |
| `user_approval` | When approval is requested |
| `state_change` | File/git operations |
| `execution_complete` | At end (with totals) |

### Truncation

Large outputs (>1000 chars) are truncated:
- First 500 characters
- Last 500 characters
- Marker: `"...[truncated: N chars]..."`

### Execution Summary

At completion, a Markdown summary is generated for human review:
- `<project-dir>/<date>-<slug>-execution-summary.md`
- Contains: timeline, errors, files modified, rollback reference

### Analyzing Logs

Claude can parse JSONL logs to:
- Identify patterns across executions
- Calculate average phase durations
- Find common error types
- Suggest skill improvements

Template files: `assets/templates/execution-log-template.jsonl`, `assets/templates/execution-summary-template.md`

## Windows-Specific Patterns

All scripts use Git Bash paths:
- Correct: `/c/Users/drewa/...`
- Wrong: `C:\Users\drewa\...`

For Windows-specific commands, use:
- `schtasks.exe` for Task Scheduler
- `powershell.exe -Command "..."` for PowerShell
- `taskkill /F /IM process.exe` for process termination

## Reference Materials

For detailed guidance, refer to:
- `references/docs-as-code-execution-plan-template.md` - Complete template with all sections
- `references/docs-as-code-guide.md` - Full pattern documentation

## Quality Checklist

Before executing any plan, verify:

- [ ] YAML front matter complete (title, created, status, agent, etc.)
- [ ] Pre-execution rollback point established (git commit SHA recorded or non-git confirmed)
- [ ] (If skill enhancement) Skills submodule rollback point established
- [ ] Execution Instructions section present
- [ ] Pre-flight validation script covers all prerequisites
- [ ] Each phase has `**Autonomous:** YES/NO` marker
- [ ] Each step has Validation Checklist with checkboxes
- [ ] Each step has Report marker
- [ ] Approval points only for destructive operations
- [ ] Execution Protocol section present (after header, before Execution Instructions)
- [ ] Errors Encountered section present (after Problem Statement)
- [ ] Parallelization assessment documented (annotations added OR "not viable" note in Agent Execution Notes)
- [ ] Agent Execution Notes section present
- [ ] Rollback procedure included
- [ ] Dev Agent Record section present (empty, to be filled)
- [ ] Plan saved in project subdirectory (docs/YYYY-MM-DD-<slug>/)
- [ ] (If executing) Execution log initialized
- [ ] (If executing) Execution summary generated at completion
- [ ] (If parallel) Parallelizable steps have `**Dependencies:**` annotation
- [ ] (If parallel) Parallelizable steps have `**Output Artifacts:**` section
- [ ] (If parallel) Parallelizable steps have `**Orchestrator Verification:**` commands
- [ ] (If parallel) Phases with parallel steps have parallelization summary
