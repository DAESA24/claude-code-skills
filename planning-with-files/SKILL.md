---
name: planning-with-files
description: Transforms workflow to use Manus-style persistent markdown files for planning, progress tracking, and knowledge storage. Use when starting complex tasks, multi-step projects, research tasks, or when the user mentions planning, organizing work, tracking progress, or wants structured output.
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - TodoWrite
---

# Planning with Files

Work like Manus: Use persistent markdown files as your "working memory on disk."

## Directory Structure

All planning artifacts live in the workspace's `_planning-with-files/` directory (underscore prefix for Obsidian compatibility):

```
_planning-with-files/
├── YYYY-MM-DD-topic-slug/
│   ├── task_plan.md    # Operational hub with frontmatter
│   └── notes.md        # Research and findings
└── archive/
    └── x-YYYY-MM-DD-topic-slug/  # Completed/abandoned sessions
        ├── task_plan.md
        └── notes.md
```

### Naming Convention

Each planning session gets a subdirectory named: `YYYY-MM-DD-topic-slug`

- **Date prefix:** Year-month-day in ISO format (e.g., `2026-01-12`)
- **Topic slug:** Kebab-case description of the objective (e.g., `dark-mode-toggle`, `api-refactor`, `morning-exercise-research`)

Examples:
- `2026-01-12-dark-mode-toggle/`
- `2026-01-11-vault-cleanup-script/`
- `2026-01-10-research-context-engineering/`

## Quick Start

Before ANY complex task:

1. **Create the planning directory** in `_planning-with-files/`
2. **Create `task_plan.md`** with frontmatter and phases
3. **Update after each phase** - mark [x] and change status
4. **Read before deciding** - refresh goals in attention window
5. **Save deliverables** to the appropriate location for this workspace

## The File Pattern

| File | Location | Purpose | When to Update |
|------|----------|---------|----------------|
| `task_plan.md` | `_planning-with-files/[date-slug]/` | Track phases, decisions, frontmatter | After each phase |
| `notes.md` | `_planning-with-files/[date-slug]/` | Store findings and research | During research |

## Frontmatter Schema

### task_plan.md Frontmatter

**At creation** (minimal, low friction):

```yaml
---
created: 2026-01-12
status: in-progress
type: research | feature | bugfix | refactor | documentation | exploration
domain: # rough area of work (e.g., "vault-tooling", "web-scraping")
---
```

**At completion** (enriched):

```yaml
---
created: 2026-01-12
completed: 2026-01-12
status: completed | abandoned
outcome: success | partial | failed
type: research
domain: vault-tooling

# Added at completion
phases_planned: 4
phases_completed: 4
deliverables:
  - "feature-implementation"  # description or filename
---
```

## Core Workflow

```
Loop 1: Create directory + task_plan.md with frontmatter and phases
Loop 2: Research → save to notes.md → update task_plan.md
Loop 3: Read notes.md → execute work → update task_plan.md
Loop 4: Finalize frontmatter → deliver
```

### The Loop in Detail

**Before starting:**
```bash
mkdir _planning-with-files/YYYY-MM-DD-topic-slug/
Write task_plan.md  # With creation frontmatter
```

**Before each major action:**
```bash
Read task_plan.md  # Refresh goals in attention window
```

**After each phase:**
```bash
Edit task_plan.md  # Mark [x], update status
```

**When storing information:**
```bash
Write notes.md     # Don't stuff context, store in file
```

**At completion:**
```bash
Edit task_plan.md  # Update frontmatter: completed, outcome, phases
# Archive the plan directory
mv _planning-with-files/[date-slug]/ _planning-with-files/archive/x-[date-slug]/
```

## task_plan.md Template

```markdown
---
created: YYYY-MM-DD
status: in-progress
type: [research|feature|bugfix|refactor|documentation|exploration]
domain: [area of work]
---

# Task Plan: [Brief Description]

## Goal
[One sentence describing the end state]

## Phases
- [ ] Phase 1: Plan and setup
- [ ] Phase 2: Research/gather information
- [ ] Phase 3: Execute/build
- [ ] Phase 4: Review and deliver

## Key Questions
1. [Question to answer]
2. [Question to answer]

## Decisions Made
- [Decision]: [Rationale]

## Errors Encountered
- [Error]: [Resolution]

## Status
**Currently in Phase X** - [What I'm doing now]
```

## notes.md Template

```markdown
# Notes: [Topic]

## Sources

### Source 1: [Name]
- URL: [link]
- Key points:
  - [Finding]
  - [Finding]

## Synthesized Findings

### [Category]
- [Finding]
- [Finding]
```

## Critical Rules

### 1. ALWAYS Create Directory and Plan First
Never start a complex task without creating the planning directory and `task_plan.md`. This is non-negotiable.

### 2. Read Before Decide
Before any major decision, read the plan file. This keeps goals in your attention window.

### 3. Update After Act
After completing any phase, immediately update the plan file:
- Mark completed phases with [x]
- Update the Status section
- Log any errors encountered

### 4. Store, Don't Stuff
Large outputs go to files, not context. Keep only paths in working memory.

### 5. Log All Errors
Every error goes in the "Errors Encountered" section. This builds knowledge for future tasks.

### 6. Finalize Frontmatter at Completion
Before marking a task complete, update `task_plan.md` frontmatter with:
- `completed` date
- `status` (completed/abandoned)
- `outcome` (success/partial/failed)
- `deliverables` (descriptions or filenames)

### 7. Source URLs Are Mandatory

Every research finding added to `notes.md` MUST include the source URL. Never record findings without attribution. If information comes from a web search, documentation page, or any external source, the URL goes with it. This enables verification and future reference.

Format:

```markdown
### Source Name
- **URL:** https://example.com/article
- Key findings:
  - Finding 1
  - Finding 2
```

If a URL is unavailable (e.g., information from local files or prior knowledge), note that explicitly:

- `- **Source:** Local file analysis (path/to/file)`
- `- **Source:** Prior knowledge (no URL)`

### 8. Archive Completed Sessions

After finalizing frontmatter with terminal status (`completed` or `abandoned`):

1. Create `_planning-with-files/archive/` if it doesn't exist
2. Move the plan directory to `archive/x-[directory-name]/`
3. If collision: append version suffix (`-v2`, `-v3`)
4. Report: "Archived to archive/x-[directory-name]/"

This keeps active plans easy to find while preserving history.

## When to Use This Pattern

**Use for:**
- Multi-step tasks (3+ steps)
- Research tasks
- Building/creating something
- Tasks spanning multiple tool calls
- Anything requiring organization

**Skip for:**
- Simple questions
- Single-file edits
- Quick lookups

## Handoff Coordination

When a planning session needs to span multiple chat sessions, coordinate with `/handoff-general`:

### Key Insight

- **planning-with-files** solves the attention problem (goals drifting within a session)
- **handoffs** solve the session boundary problem (preserving state across conversations)
- These are complementary - a long planning task may need both

### When User Requests a Handoff Mid-Plan

If the user says "create a handoff" while a planning session is active:

1. `/handoff-general` will automatically detect the active plan directory
2. The handoff document will include an "Active Planning Session" section
3. The handoff references the plan directory; the next session reads `task_plan.md` first

### What Claude Should Do

- **Keep `task_plan.md` current** - The handoff relies on accurate phase status
- **Don't duplicate** - The handoff references the plan; don't copy all content into the handoff
- **Update before handoff** - Mark the current phase status before creating the handoff

### Resuming After Pickup

When `/pickup-general` loads a handoff with an `active_plan` field:

1. Read the referenced `task_plan.md` first
2. Check the current phase status
3. Continue execution from where it left off

The plan file is the source of truth; the handoff is the pointer.

## Archiving Completed Sessions

When a planning session reaches terminal status, archive it to keep the active directory clean.

### When to Archive

Archive immediately after updating frontmatter to:

- `status: completed`
- `status: abandoned`

### Archive Procedure

1. **Verify terminal status** - Confirm `task_plan.md` frontmatter has `status: completed` or `status: abandoned`
2. **Create archive directory** - `mkdir -p _planning-with-files/archive/`
3. **Move with x- prefix** - `mv [plan-dir]/ archive/x-[plan-dir]/`
4. **Handle collisions** - If target exists, append version suffix:
   - `x-2026-01-24-my-task/` (first)
   - `x-2026-01-24-my-task-v2/` (collision)
   - `x-2026-01-24-my-task-v3/` (rare)
5. **Report to user** - "Archived to archive/x-[directory-name]/"

### Example

Before completion:

```text
_planning-with-files/
├── 2026-01-24-implement-feature/
│   ├── task_plan.md
│   └── notes.md
└── 2026-01-23-research-apis/
    ├── task_plan.md
    └── notes.md
```

After completing `2026-01-24-implement-feature`:

```text
_planning-with-files/
├── archive/
│   └── x-2026-01-24-implement-feature/
│       ├── task_plan.md
│       └── notes.md
└── 2026-01-23-research-apis/
    ├── task_plan.md
    └── notes.md
```

### Why Archive?

- **Visual clarity:** The `x-` prefix signals "this is done"
- **Clean directory:** Active plans are easy to find
- **History preserved:** Archived plans remain accessible
- **Consistent pattern:** Matches other archive conventions (handoffs, feature-backlog-staging)

## Anti-Patterns to Avoid

| Don't | Do Instead |
|-------|------------|
| Use TodoWrite alone for complex tasks | Create planning directory and `task_plan.md` |
| State goals once and forget | Re-read plan before each decision |
| Hide errors and retry | Log errors to plan file |
| Stuff everything in context | Store large content in files |
| Start executing immediately | Create planning directory FIRST |
| Hardcode deliverable paths in frontmatter | Use filename or description only |

## Deliverables

**Deliverables depend on the type of work:**

- **Code projects:** The deliverable is often the code itself (commits, PRs, modified files)
- **Research/knowledge work:** The deliverable may be a document saved to a specific location
- **Check workspace CLAUDE.md** for guidance on where deliverables should go in this context

The `deliverables` field in frontmatter tracks what was produced - whether that's a filename, commit reference, or description of work completed.