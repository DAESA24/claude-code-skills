# Docs-as-Code for LLM Execution - Essential Guide

- **Created:** 2025-11-17
- **Purpose:** Concise guide for creating LLM-executable documentation
- **Audience:** Claude Code and other AI agents
- **Source:** Synthesized from 4-part comprehensive series (2025-11-12)
- **Optimization:** Token-efficient, action-focused, battle-tested patterns

---

## Core Concept

**Docs-as-Code** = Documentation that IS the implementation, not a description of it.

**Traditional approach:**
```markdown
1. Create a backup
2. Set up directory structure
3. Copy files
```

**Docs-as-Code approach:**
```bash
# Step 1: Create backup with verification
timestamp=$(date +"%Y-%m-%d-%H%M")
backup_path="/path/to/backup-$timestamp"
cp -r "$source_path" "$backup_path"

if [ -d "$backup_path" ]; then
    source_count=$(find "$source_path" -type f | wc -l)
    backup_count=$(find "$backup_path" -type f | wc -l)

    if [ "$source_count" -eq "$backup_count" ]; then
        echo "✅ Backup created: $backup_count files"
    else
        echo "❌ BACKUP INCOMPLETE"
        exit 1
    fi
fi
```

**Key difference:** LLM executes pre-written scripts, doesn't improvise.

---

## The Five Critical Principles

### 1. Pre-Written Scripts (Not Instructions)

**Rule:** Write complete bash scripts in the plan.

❌ **WRONG:**
```markdown
Initialize a git repository and create .gitignore
```

✅ **CORRECT:**
```bash
cd "$repo_path" || {
    echo "❌ ERROR: Cannot access directory"
    exit 1
}

if [ -d .git ]; then
    echo "⚠️ Git already initialized"
else
    git init || {
        echo "❌ ERROR: Git init failed"
        exit 1
    }
    echo "✅ Git repo initialized"
fi

cat > .gitignore <<'EOF'
*.log
.DS_Store
node_modules/
EOF

if [ -f .gitignore ]; then
    echo "✅ .gitignore created"
fi
```

**Why:** LLM executes, doesn't compose. Saves ~2-3k tokens per operation.

---

### 2. Read-Once Architecture

**Rule:** Include all context upfront. Never require file exploration during execution.

**Embed everything:**
- File templates (README, config files)
- Directory structures
- Decision criteria
- All paths (absolute, pre-defined)

**Example:**
```markdown
## Project Structure

```
project/
├── docs/          # Documentation
├── src/           # Source code
├── tests/         # Test files
└── README.md      # Project overview
```

## README Template

```markdown
# Project Name

## Setup
[Complete template here - don't reference another file]
```

## Paths (defined once, used throughout)

```bash
source_path="/c/Users/drewa/source"
dest_path="/c/Users/drewa/dest"
backup_path="/c/Users/drewa/backup-$(date +%Y%m%d)"
```
```

**Token savings:** ~25-40k tokens (no file exploration needed)

---

### 3. Explicit Success Criteria

**Rule:** Every step must have programmatically verifiable success criteria.

**Pattern: Check → Execute → Verify**

```bash
# Check prerequisites
if [ ! -d "$source" ]; then
    echo "❌ ERROR: Source not found"
    exit 1
fi

# Execute operation
cp -r "$source" "$dest"

# Verify success
if [ -d "$dest" ]; then
    src_count=$(find "$source" -type f | wc -l)
    dst_count=$(find "$dest" -type f | wc -l)

    if [ "$src_count" -eq "$dst_count" ]; then
        echo "✅ Copy successful: $dst_count files"
    else
        echo "❌ ERROR: File count mismatch"
        exit 1
    fi
fi
```

**Not acceptable:**

- "Ensure files are copied correctly"
- "Verify the operation succeeded"
- "Check that everything looks good"

**Multi-Point Validation (for complex steps):**

When a step requires multiple verification points, use checkbox format:

```markdown
**Validation Checklist:**

- [ ] Primary condition verified
- [ ] Secondary condition verified
- [ ] Edge case handled
- [ ] No side effects on preserved targets

**Instruction:** Mark each checkbox in this file as validation is confirmed.
```

**In-Place Marking:**

- When steps contain `- [ ]` checkboxes, edit the plan file to mark them `- [x]` as each item is verified
- This creates a persistent record for multi-session execution
- Distinguishes between "reported as done" vs. "actually marked done in file"

**When to Use:**

- Use `- [ ]` checkboxes when the step needs persistent tracking (mark in file)
- Use `-` bullet points when verification is transient (report in response only)

---

### 4. Minimal Approval Points

**Rule:** Require approval ONLY for:
- Destructive operations (delete, overwrite)
- External publishing (git push, npm publish)
- Irreversible actions (database migrations)

**Pattern:**
```markdown
### Step 4.2: Remove Original Directory
🚨 **USER APPROVAL REQUIRED**

**What will happen:**
- Delete: /path/to/original (350 files)

**Safety measures:**
- ✅ Backup verified at: /path/to/backup (350 files)
- ✅ New location verified at: /path/to/new (350 files)

**Reversibility:** Can restore from backup

Proceed with deletion? (yes/no)
```

**Everything else:** Mark as `**Autonomous:** YES`

**Token savings:** ~2-3k tokens (eliminates 10+ unnecessary confirmations)

---

### 5. Built-In Validation

**Rule:** Validate immediately after each critical operation.

**Single-pass validation:**
```bash
# Validate multiple conditions in one check
if [ -f "$path/README.md" ] && [ -s "$path/README.md" ]; then
    if grep -q "project-name" "$path/README.md"; then
        echo "✅ README validated (exists, has content, correct format)"
    else
        echo "❌ ERROR: README content invalid"
        exit 1
    fi
fi
```

**Not:** Separate checks for existence, size, content (wastes tokens)

**Token savings:** ~4-6k tokens (combined vs. individual checks)

**Expected Results Block (optional):**

For steps with measurable outcomes, add explicit expected values:

```markdown
**Expected Results:**

- File count: ~178 (may vary)
- Directory exists: YES
- Exit code: 0
```

**When to Use:**

- Operations produce countable outputs
- Specific values can be predicted
- Partial success needs detection

---

### 6. Explicit Execution Rules

**Rule:** Include explicit execution instructions in every plan.

**Why:** LLMs may optimize or parallelize unless told not to. Explicit rules prevent:

- Skipping validation steps
- Batching steps that should run sequentially
- Continuing after failures

**Standard Execution Instructions Block:**

```markdown
## Execution Instructions

- Execute steps SEQUENTIALLY in exact order listed
- Complete ALL validation substeps before proceeding to next step
- If ANY validation fails, STOP immediately and report failure
- Do NOT skip validation steps
- Do NOT batch multiple steps together
- Report results after EACH step completion
```

**Note on Parallelization:** When steps include parallelization annotations (`**Dependencies:** None`, `**Parallelizable:** YES`), the orchestrator may spawn sub-agents for concurrent execution. Sequential execution remains the default; parallelization is opt-in via explicit annotations.

**Savings:** Prevents expensive re-execution due to missed validations or incorrect ordering.

---

## LLM-Optimized Structure

### Standard Plan Template

```markdown
# [Operation Name] Execution Plan

- **Purpose:** [1-sentence goal]
- **Audience:** Claude Code (autonomous execution agent)
- **User Intervention:** Only for steps marked 🚨
- **Estimated Duration:** [X minutes]
- **Version:** 1.0

---

## Pre-Flight Validation

```bash
echo "=== PRE-FLIGHT CHECKS ==="

# Check disk space
available=$(df /target | tail -1 | awk '{print $4}')
if [ "$available" -lt 500000 ]; then
    echo "❌ Insufficient disk space"
    exit 1
fi

# Check required tools
command -v git &> /dev/null || {
    echo "❌ Git not installed"
    exit 1
}

echo "✅ Pre-flight checks passed"
```

---

## Phase 1: [Phase Name]

**Risks:**
- [What could go wrong]

**Mitigation:**
- [How to prevent/handle]

### Step 1.1: [Step Name]
**Autonomous:** YES

```bash
# Implementation with error handling
# and validation
```

**Success Criteria:** [Programmatically verifiable condition]

---

## Rollback Plan

```bash
#!/bin/bash
# Rollback script

echo "=== ROLLING BACK ==="
# Undo operations in reverse order
echo "✅ Rollback complete"
```
```

**Multi-Session Support:**

Plans may span multiple chat sessions. Include in Agent Execution Notes:

- Trigger phrase for resuming execution
- Plan file location
- Resume guidance: "If interrupted, re-read this file and continue from last incomplete step"

---

## Token Optimization Techniques

### 1. Heredocs for Multi-Line Files

❌ **Expensive (Write tool):**
```markdown
Use Write tool to create README.md with [content description]
```
Cost: ~1,500 tokens (agent reads reference, composes, writes)

✅ **Efficient (Heredoc):**
```bash
cat > README.md <<'EOF'
# Project Name

[Complete content here - 50+ lines]
EOF

if [ -f README.md ] && [ -s README.md ]; then
    echo "✅ README created"
fi
```
Cost: ~200 tokens

**Savings:** ~1,300 tokens per file

---

### 2. Pre-Answered FAQs

**Include in plan:**
```markdown
## Common Questions (Pre-Answered)

**Q: What if target directory exists?**
A: Step 1.1 checks and aborts with error message.

**Q: What happens to logs?**
A: Excluded via .gitignore (see Step 1.3).

**Q: Should repo be public or private?**
A: PRIVATE (default for safety, confirmed by user).
```

**Savings:** ~1-2k tokens (eliminates clarification exchanges)

---

### 3. Batch Operations

❌ **Inefficient:**
```bash
# Process files individually
for file in *.txt; do
    validate "$file"
    process "$file"
    report "$file"
done
```

✅ **Efficient:**
```bash
# Batch operation
file_count=$(find . -name "*.txt" | wc -l)
process_batch "*.txt"

if [ "$(find . -name "*.processed" | wc -l)" -eq "$file_count" ]; then
    echo "✅ All $file_count files processed"
fi
```

**Savings:** ~10-20k tokens (for 100+ files)

---

### 4. Exit-Code Validation

**Implicit validation (efficient):**
```bash
cd "$target_path" || {
    echo "❌ Cannot navigate to target"
    exit 1
}

git init || {
    echo "❌ Git init failed"
    exit 1
}
```

**No need to parse output** - exit code tells the story.

---

## Critical Patterns

### Pattern 1: File Migration

```bash
# Pre-migration
source="/path/to/source"
dest="/path/to/dest"

# Verify source exists
if [ ! -d "$source" ]; then
    echo "❌ Source not found"
    exit 1
fi

# Copy with verification
cp -r "$source" "$dest"

src_count=$(find "$source" -type f | wc -l)
dst_count=$(find "$dest" -type f | wc -l)

if [ "$src_count" -eq "$dst_count" ]; then
    echo "✅ Migrated $dst_count files"
else
    echo "❌ File count mismatch"
    exit 1
fi
```

---

### Pattern 2: Git Workflow

```bash
# Initialize
cd "$repo_path" || exit 1

if [ ! -d .git ]; then
    git init || exit 1
fi

# Commit with heredoc message
git add .

git commit -m "$(cat <<'EOF'
feat: Initial commit

Detailed description here.

🤖 Generated with Claude Code
EOF
)"

# Verify
commit_hash=$(git rev-parse HEAD)
if [ -n "$commit_hash" ]; then
    echo "✅ Commit: $commit_hash"
fi
```

---

### Pattern 3: Idempotent Operations

**Safe to re-run:**
```bash
# Directory creation
mkdir -p "$target_dir"  # -p makes it idempotent

# Conditional file creation
if [ ! -f config.yaml ]; then
    cat > config.yaml <<'EOF'
[config content]
EOF
fi

# Git init check
if [ ! -d .git ]; then
    git init
fi
```

**Why:** Enables safe retry after failures.

---

### Pattern 4: Per-Step Report Markers

**Rule:** Every step should have a standardized report format.

**Format:**

```markdown
**Report:** "STEP X.Y COMPLETE: <summary with key metrics>"
```

**Examples:**

```markdown
**Report:** "STEP 0.1 COMPLETE: Baseline snapshots created (5 snapshots)"
**Report:** "STEP 2.3 COMPLETE: Files migrated (178 files, 0 errors)"
**Report:** "STEP 3.1 COMPLETE: Git repository initialized"
```

**Why:**

- Enables progress tracking across phases
- Provides consistent format for LLM to parse
- Creates audit trail in execution logs

---

### Pattern 5: Agent Execution Notes

**Rule:** Include a dedicated section for agent-specific context at the end of plans.

**Structure:**

```markdown
## Agent Execution Notes

### Critical Execution Requirements
1. [Numbered list of rules specific to this plan]

### Preservation Targets
- [Files/directories that must NOT change]

### Safe Modification Targets
- [Files/directories the plan may alter]

### Execution Trigger
- **Trigger phrase:** "execute the [plan name]"
- **Plan location:** `path/to/plan.md`
- **Resume guidance:** If interrupted, re-read this file and continue from last incomplete step.
```

**Why:**

- Provides explicit guardrails for LLM execution
- Prevents accidental modification of critical files
- Enables multi-session execution with clear resume instructions

---

### Pattern 6: Phase Boundary Validation

**Rule:** Add a dedicated validation step at the end of each phase.

**Pattern:**

```markdown
### STEP X.N: Validate Phase X Completion

**Autonomous:** YES

**Actions:**
- Compare current state to expected state
- Verify all phase objectives met

**Expected Results:**
- [List what should be true after phase completes]

**Report:** "STEP X.N COMPLETE: Phase X validation passed"
```

**Why:**

- Catches issues at phase boundaries before they compound
- Creates natural checkpoint for multi-session execution
- Provides clear phase completion signal

---

### Pattern 7: Sub-Agent Parallelization

**Rule:** When multiple independent tasks exist within a phase, consider delegating to parallel sub-agents for context optimization.

**When to Use:**

- 2+ tasks in same phase have no dependencies on each other
- Each task has verifiable output artifacts
- Orchestrator can validate results without sub-agent context
- Task complexity justifies sub-agent spawn overhead

**When NOT to Use:**

- Fewer than 2 independent tasks in phase
- Tasks are simple (< 2 bash commands each)
- Validation requires context sub-agent has but orchestrator lacks
- Output artifacts overlap (race condition risk)
- User prefers visibility over speed

**Phase-Level Annotation:**

```markdown
## Phase 2: Database Setup

**Parallelization:** Steps 2.1, 2.2, 2.3 can run concurrently (no dependencies)
**Sequential requirement:** Step 2.4 must wait for 2.1-2.3 completion
```

**Step-Level Annotations (for parallelizable steps):**

```markdown
### STEP 2.1: Create database migration script

**Autonomous:** YES
**Dependencies:** None  <!-- or "Depends on: 2.0" if sequential required -->
**Parallelizable:** YES

**Output Artifacts:**
- File: `migrations/001_add_users_table.sql`
- File: `migrations/001_add_users_table_test.sql`

**Orchestrator Verification:**
```bash
# Commands the main session runs to validate sub-agent work
[ -f "migrations/001_add_users_table.sql" ] && echo "✅ Migration file exists"
grep -q "CREATE TABLE users" migrations/001_add_users_table.sql && echo "✅ Table creation present"
```
```

**Sub-Agent Task Prompt Template:**

When spawning sub-agents, use this structure:

```markdown
## Task Assignment

**Step:** [Step number and title]
**From Plan:** [Plan file path]

**Actions:**
[Copied from plan step]

**Output Artifacts Required:**
[Copied from plan step]

**Success Criteria:**
[Copied from plan step]

**Important:**
- Complete ONLY this specific step
- Do NOT proceed to other steps
- Report completion with artifact verification
```

**Orchestrator Validation Flow:**

1. Spawn sub-agents for independent tasks (parallel)
2. Wait for all sub-agents to complete
3. Run Orchestrator Verification commands for each task
4. Report consolidated results before proceeding
5. If any verification fails, report failure and stop

**Why:**

- Reduces context accumulation in orchestrating session (30-50% savings for parallelizable plans)
- Enables horizontal scaling for independent operations
- Maintains audit trail through verification commands

---

## LLM-Specific Formatting

### Status Prefixes (for LLM parsing)

```bash
echo "✅ Success message"
echo "❌ ERROR: Failure message"
echo "⚠️ WARNING: Caution message"
echo "ℹ️ INFO: Information"
echo "⏭️ SKIPPED: Step not needed"
echo "🚨 USER APPROVAL REQUIRED"
```

### Phase Boundaries

```bash
echo ""
echo "════════════════════════════════════════"
echo "✅ Phase 2 Complete - Files Migrated"
echo "════════════════════════════════════════"
echo "   Files copied: $file_count"
echo "   Next: Phase 3 - Git Commit"
echo ""
```

### Metadata Format

❌ **WRONG (paragraph style):**
```markdown
Created: 2025-11-17
Author: Drew Arnold
Status: Active
```

✅ **CORRECT (bullet points):**
```markdown
- **Created:** 2025-11-17
- **Author:** Drew Arnold
- **Status:** Active
```

**Why:** Scannable for LLMs and humans.

---

## Platform-Specific: Windows

### Path Handling

```bash
# ✅ CORRECT (Git Bash on Windows)
dev_path="/c/Users/drewa/work/dev"
cd "$dev_path" || exit 1

# ❌ WRONG (Windows path)
dev_path="C:\Users\drewa\work\dev"
```

### Symlink Considerations

```bash
# Create symlink
ln -s /target /link

# IMPORTANT: Hidden directories may need manual copy
hidden_dirs=$(find "$dev_path" -maxdepth 1 -type d -name ".*" ! -name ".git")

if [ -n "$hidden_dirs" ]; then
    for dir in $hidden_dirs; do
        dir_name=$(basename "$dir")
        cp -r "$dir" "$symlink_path/"
        echo "✅ Copied hidden dir: $dir_name"
    done
fi
```

---

## Error Handling Checklist

**Every critical operation must:**
- [ ] Check prerequisites (exit if not met)
- [ ] Execute with explicit error handling
- [ ] Verify success programmatically
- [ ] Provide actionable error messages
- [ ] Exit with non-zero code on failure

**Example:**
```bash
# Check
if [ ! -d "$source" ]; then
    echo "❌ ERROR: Source directory not found"
    echo "   Expected: $source"
    exit 1
fi

# Execute
if ! cp -r "$source" "$dest"; then
    echo "❌ ERROR: Copy operation failed"
    echo "   Check permissions for: $dest"
    exit 1
fi

# Verify
if [ -d "$dest" ]; then
    echo "✅ Copy successful"
else
    echo "❌ ERROR: Destination not created"
    exit 1
fi
```

---

## Anti-Patterns (Avoid These)

### ❌ Anti-Pattern 1: Vague Instructions

```markdown
Create a backup of the project before proceeding.
```

**Problem:** LLM must improvise how, where, and verification.

---

### ❌ Anti-Pattern 2: No Error Handling

```bash
cp -r /source /dest
rm -rf /source
```

**Problem:** Deletes source even if copy failed.

---

### ❌ Anti-Pattern 3: Missing Success Criteria

```markdown
### Step 3: Initialize Git
Run `git init` in the project directory.
```

**Problem:** No way to verify success.

---

### ❌ Anti-Pattern 4: Too Many Approval Points

```markdown
Approve: Create directory? (yes/no)
Approve: Initialize git? (yes/no)
Approve: Create README? (yes/no)
Approve: Stage files? (yes/no)
```

**Problem:** 4 interruptions for safe, reversible operations.

---

### ❌ Anti-Pattern 5: Repeated File Reads

```markdown
Step 1: Read project structure
Step 2: Create migration plan (reads files again)
Step 3: Execute migration (reads files again)
```

**Problem:** Same files read 3 times = 3x token cost.

---

## Quality Checklist

### Before Execution

**Metadata:**
- [ ] Title clearly describes operation
- [ ] Audience specified (Claude Code)
- [ ] User intervention points marked (🚨)
- [ ] Estimated duration provided

**Safety:**
- [ ] Backup strategy for destructive ops
- [ ] Rollback plan included
- [ ] Error handling at critical points
- [ ] Success criteria per step

**Efficiency:**
- [ ] Templates embedded (not referenced)
- [ ] Paths pre-defined (not discovered)
- [ ] FAQs pre-answered
- [ ] Validation combined (not repeated)

---

## Real-World Metrics

**Case Study: 350-file repository migration**

| Metric | Conversational | Docs-as-Code | Improvement |
|--------|----------------|--------------|-------------|
| Token Usage | ~500k | ~150k | 3.3x more efficient |
| Execution Time | 2+ hours | 15 minutes | 8x faster |
| User Interactions | 20+ | 2 | 10x less friction |
| Errors | Multiple retries | Zero | Dramatically safer |

**Token Breakdown:**
- Plan read: ~42k (one-time, comprehensive)
- Execution: ~88k (pre-written scripts)
- Output: ~20k (files, reports)
- **Total:** ~150k tokens

---

## When to Use Docs-as-Code

**✅ IDEAL CANDIDATES:**
- Complex multi-step operations (5+ phases)
- Repeatable processes (migrations, deployments)
- High-stakes operations (data migration, backups)
- Token-intensive tasks (many files)
- Batch operations (processing 50+ items)

**❌ USE CONVERSATIONAL INSTEAD:**
- Exploratory analysis (don't know what you're looking for)
- One-off simple tasks (1-2 steps)
- Rapid prototyping (requirements changing)
- Creative work (brainstorming, design)
- Debugging (investigating unexpected behavior)

---

## Quick Reference: Common Commands

### File Operations
```bash
mkdir -p /path/to/dir        # Create directory
cp -r /source /dest          # Copy recursively
rm -rf /path                 # Delete directory
ln -s /target /link          # Create symlink
[ -d "/path" ]               # Check if directory exists
[ -f "/path" ]               # Check if file exists
find /path -type f | wc -l   # Count files
```

### Git Operations
```bash
git init                     # Initialize repo
git add .                    # Stage all files
git commit -m "message"      # Commit
git push -u origin main      # Push to remote
git status --porcelain       # Machine-readable status
[ -z "$(git status --porcelain)" ]  # Check if clean
```

### Validation
```bash
df /path | tail -1 | awk '{print $4}'  # Disk space (KB)
command -v tool &> /dev/null           # Check if command exists
sha256sum /file | awk '{print $1}'     # File hash
```

---

## Summary: The Essential Rules

1. **Write scripts, not instructions** - LLM executes, doesn't improvise
2. **Include everything upfront** - No file exploration during execution
3. **Explicit success criteria** - Programmatically verifiable
4. **Minimal approvals** - Only for destructive/irreversible operations
5. **Built-in validation** - Check → Execute → Verify
6. **Heredocs for files** - Preserves formatting, saves tokens
7. **Pre-answer questions** - Eliminate clarification exchanges
8. **Batch operations** - Process many items as single operation
9. **Exit-code handling** - Let bash do the validation
10. **Platform awareness** - Windows paths, hidden directory handling

---

## Next Steps

**To create a docs-as-code plan:**

1. **Identify candidate** - Complex, repeatable, high-stakes task?
2. **Define phases** - Break into 5-10 logical phases
3. **Write scripts** - Complete bash implementation per step
4. **Embed context** - Templates, paths, decisions upfront
5. **Add validation** - Success criteria per critical step
6. **Mark approvals** - Only destructive/irreversible ops
7. **Test dry-run** - Validate before production
8. **Execute** - LLM runs autonomously

---

## Related Resources

- **Full 4-Part Series:** [Part 1](./docs-as-code-best-practices-part1-core-principles.md) | [Part 2](./docs-as-code-best-practices-part2-token-optimization.md) | [Part 3](./docs-as-code-best-practices-part3-templates-patterns.md) | [Part 4](./docs-as-code-best-practices-part4-integration-reference.md)
- **Case Study:** Repository migration execution plan (350 files, 150k tokens)
- **Token Optimization:** Read-once architecture, heredoc patterns, batch validation

---

**Document Status:** ✅ Production Ready
**Created:** 2025-11-17
**Synthesized From:** 4-part comprehensive guide (~40k tokens → 6k tokens)
**Compression Ratio:** 85% reduction while preserving critical insights
**For:** LLM-executable documentation workflows
