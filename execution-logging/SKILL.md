---
name: execution-logging
description: Provides deterministic tool call logging via Claude Code hooks. Logs Bash, Edit, Write, and Read operations to JSONL format. Use when implementing execution plans, audit trails, or debugging workflows. Activate by creating a marker file; invoke directly for log format documentation and integration guidance.
---

# Execution Logging

Deterministic, always-on tool call logging via Claude Code hooks. Any workflow can activate logging by creating a marker file; hooks handle the rest automatically.

## Quick Start

1. Create marker file pointing to desired log location:
   ```bash
   echo "/path/to/your/execution-log.jsonl" > ~/.claude/.claude-execution-log-path
   ```
2. Run the workflow (hooks log all Bash, Edit, Write, Read calls automatically)
3. When the session ends, the Stop hook writes a completion event and deletes the marker

## Integration

**Marker file:** `~/.claude/.claude-execution-log-path`
- Contains a single line: the absolute path to the log file
- Use forward slash paths (`/c/Users/...` on Windows, `/Users/...` on macOS)

**Logged tools:** Bash, Edit, Write, Read

**Log format:** JSONL (one JSON object per line)

See [log-format-reference.md](references/log-format-reference.md) for the complete schema, event types, and field definitions.

## User Setup

One-time configuration in `~/.claude/settings.json`. Add or merge this hooks configuration:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Bash|Edit|Write|Read",
        "hooks": [
          {
            "type": "command",
            "command": "/c/Users/drewa/.claude/skills/execution-logging/scripts/log-tool-event.sh"
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "/c/Users/drewa/.claude/skills/execution-logging/scripts/finalize-log.sh"
          }
        ]
      }
    ]
  }
}
```

**Path format:** Always use forward slashes. On Windows: `/c/Users/username/...`. On macOS/Linux: `/Users/username/...`.

## Troubleshooting

**No log file created:**
- Verify marker file exists: `cat ~/.claude/.claude-execution-log-path`
- Verify marker contains a valid path to a writable location
- Check stderr output for error messages from the hooks

**Logging stopped mid-session:**
- Marker file may have been deleted or corrupted
- Check if the log directory still exists

**Path issues on Windows:**
- Use Git Bash path format: `/c/Users/...` not `C:\Users\...`
- Ensure jq is installed and available in PATH

## How It Works

1. **Activation:** A workflow creates the marker file containing the log path
2. **Logging:** PostToolUse hook fires on every Bash, Edit, Write, or Read call
   - Checks for marker file (exits silently if absent)
   - Appends JSONL event to the log file
3. **Finalization:** Stop hook fires when the Claude session ends
   - Writes `execution_complete` event with total event count
   - Deletes the marker file

The hooks are configured globally in settings.json, so they fire on every tool call in every project. The marker file pattern means logging only occurs when explicitly activated.
