# CLAUDE.md

- **Scope:** Global Skills Repository
- **Purpose:** Claude Code skill development and management
- **Standard:** [Agent Skills open standard](https://agentskills.io)

## What This Repository Contains

Skills are modular packages that extend Claude's capabilities. Each skill is a directory containing:

- `SKILL.md` (required) - YAML frontmatter + markdown instructions
- `scripts/` (optional) - Executable Python/Bash code
- `references/` (optional) - Documentation loaded into context as needed
- `assets/` (optional) - Files used in output (templates, images, fonts)

## Repository Structure

```
skills/
├── skill-creator/       # Meta-skill for creating new skills
│   ├── SKILL.md
│   └── scripts/         # init_skill.py, quick_validate.py, package_skill.py
├── crawl4ai/            # Web crawling with Crawl4AI library
├── docs-as-code-execution-plan/  # Automation execution plans
├── planning-with-files/ # Manus-style persistent markdown planning
└── youtube-audio-download/       # YouTube audio extraction
```

## Two Toolsets: When to Use Each

This repository uses two complementary toolsets. Use the decision tree below.

### skill-creator (Design & Authoring)

**Location:** `skill-creator/scripts/`

**Use skill-creator when:**

- Creating a new skill from scratch → `init_skill.py`
- Iterating during development → `quick_validate.py`
- Packaging a skill for distribution → `package_skill.py`
- Following the 6-step skill design process → Read `skill-creator/SKILL.md`

**Commands:**

```bash
# Initialize new skill (always use this for new skills)
python skill-creator/scripts/init_skill.py <skill-name> --path <output-directory>

# Fast validation during development
python skill-creator/scripts/quick_validate.py <skill-directory>

# Package for distribution (validates first, then creates zip)
python skill-creator/scripts/package_skill.py <skill-directory> [output-directory]
```

### skills-ref CLI (Validation & Integration)

**Purpose:** Official reference implementation of the Agent Skills spec

**Use skills-ref when:**

- Final validation before publishing → `skills-ref validate`
- Extracting skill metadata programmatically → `skills-ref read-properties`
- Generating prompt XML for custom agents → `skills-ref to-prompt`

**Commands:**

```bash
# Official spec validation (run before publishing)
skills-ref validate <skill-directory>

# Read skill properties as JSON
skills-ref read-properties <skill-directory>

# Generate <available_skills> XML for agent prompts
skills-ref to-prompt <skill-directory> [additional-skills...]
```

## Skill Development Workflow

Follow this sequence when creating or modifying skills:

1. **Create** → `python skill-creator/scripts/init_skill.py <name> --path <dir>`
2. **Design** → Follow 6-step process in `skill-creator/SKILL.md`
3. **Iterate** → Run `quick_validate.py` after each change
4. **Final validate** → Run `skills-ref validate` before publishing
5. **Package** → Run `package_skill.py` to create distributable zip

## SKILL.md Requirements

### YAML Frontmatter (Required)

| Field           | Required | Constraints                                                               |
| --------------- | -------- | ------------------------------------------------------------------------- |
| `name`          | Yes      | Max 64 chars, lowercase alphanumeric + hyphens, must match directory name |
| `description`   | Yes      | Max 1024 chars, describe what skill does AND when to use it               |
| `license`       | No       | License name or reference to bundled file                                 |
| `compatibility` | No       | Max 500 chars, environment requirements                                   |
| `metadata`      | No       | Key-value pairs for custom properties                                     |
| `allowed-tools` | No       | Space-delimited list of pre-approved tools (experimental)                 |

**Important:** Custom fields (`version`, `author`, `last_updated`) must go inside `metadata:` block to pass spec validation.

### Example Frontmatter

```yaml
---
name: my-skill
description: This skill does X. This skill should be used when the user needs Y.
license: MIT
metadata:
  version: "1.0"
  author: drew-arnold
  last_updated: "2025-01-20"
---
```

## Writing Style for Skills

- Use imperative/infinitive form (verb-first): "To rotate a PDF, run..." not "You should run..."
- Use third-person in descriptions: "This skill should be used when..." not "Use this skill when..."
- Keep `SKILL.md` lean; move detailed reference material to `references/` files
- Include explicit trigger phrases in description to improve skill invocation accuracy

---

- **Document Status:** ✅ Active
- **Last Updated:** 2025-01-20
