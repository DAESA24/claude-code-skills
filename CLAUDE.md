# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository contains Claude Code skills - modular packages that extend Claude's capabilities with specialized knowledge, workflows, and tools. Each skill is a self-contained directory with a `SKILL.md` file and optional bundled resources.

Skills in this repo follow the [Agent Skills open standard](https://agentskills.io) maintained by Anthropic.

## Repository Structure

```
skills/
├── skill-creator/       # Meta-skill for creating new skills
│   ├── SKILL.md
│   └── scripts/         # Python tools for skill management
├── crawl4ai/            # Web crawling with Crawl4AI library
├── docs-as-code-execution-plan/  # Automation execution plans
├── planning-with-files/ # Manus-style persistent markdown planning
└── youtube-audio-download/       # YouTube audio extraction
```

## Skill Anatomy

Every skill requires:
- `SKILL.md` - YAML frontmatter (name, description) + markdown instructions
- Optional: `scripts/`, `references/`, `assets/` directories

## Common Commands

### Create a New Skill
```bash
python skill-creator/scripts/init_skill.py <skill-name> --path <output-directory>
```

### Quick Validation (Development)

```bash
python skill-creator/scripts/quick_validate.py <skill-directory>
```

### Official Spec Validation (Before Publishing)

```bash
skills-ref validate <skill-directory>
```

### Package a Skill for Distribution
```bash
python skill-creator/scripts/package_skill.py <skill-directory> [output-directory]
```

## Agent Skills Spec Validation with `skills-ref`

The `skills-ref` CLI is the **official reference implementation** for validating skills against the Agent Skills open standard. Always run this before publishing or sharing a skill.

### Commands

```bash
# Validate a skill against the official spec
skills-ref validate <skill-directory>

# Read skill properties as JSON
skills-ref read-properties <skill-directory>

# Generate <available_skills> XML for agent prompts
skills-ref to-prompt <skill-directory> [additional-skills...]
```

### Validation Rules (Official Spec)

The `skills-ref validate` command enforces:

**Required fields:**

- `name` - Max 64 chars, lowercase alphanumeric + hyphens, must match directory name
- `description` - Max 1024 chars, describes what skill does and when to use it

**Optional fields (only these are allowed):**

- `license` - License name or reference to bundled file
- `compatibility` - Max 500 chars, environment requirements
- `metadata` - Key-value pairs for custom properties (use this for version info, author, etc.)
- `allowed-tools` - Space-delimited list of pre-approved tools (experimental)

**Important:** Custom fields like `version`, `last_updated`, or `crawl4ai_version` must go inside the `metadata:` block to pass spec validation.

### Example: Spec-Compliant Frontmatter

```yaml
---
name: my-skill
description: This skill does X. Use when the user needs Y.
license: MIT
metadata:
  version: "1.0"
  author: example-org
  last_updated: "2025-01-19"
---
```

### Development Workflow

1. **During development:** Use `quick_validate.py` for fast feedback
2. **Before publishing:** Run `skills-ref validate` for full spec compliance
3. **Testing prompt integration:** Use `skills-ref to-prompt` to see how skills appear to agents

## Writing Style for Skills

- Use imperative/infinitive form (verb-first instructions)
- Use third-person in descriptions ("This skill should be used when..." not "Use this skill when...")
- Keep `SKILL.md` lean; put detailed info in `references/` files
