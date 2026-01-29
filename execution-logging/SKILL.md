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

One-time configuration in `~/.claude/settings.json`. Add or merge this hooks configuration.

### Windows (PowerShell)

On Windows, use PowerShell scripts (bash script files don't execute properly via Git Bash in Claude Code):

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Bash|Edit|Write|Read",
        "hooks": [
          {
            "type": "command",
            "command": "powershell.exe -ExecutionPolicy Bypass -File \"C:\\Users\\drewa\\.claude\\skills\\execution-logging\\scripts\\log-tool-event.ps1\""
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "powershell.exe -ExecutionPolicy Bypass -File \"C:\\Users\\drewa\\.claude\\skills\\execution-logging\\scripts\\finalize-log.ps1\""
          }
        ]
      }
    ]
  }
}
```

### macOS / Linux (Bash)

On macOS/Linux, use the bash scripts directly:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Bash|Edit|Write|Read",
        "hooks": [
          {
            "type": "command",
            "command": "/Users/drewa/.claude/skills/execution-logging/scripts/log-tool-event.sh"
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "/Users/drewa/.claude/skills/execution-logging/scripts/finalize-log.sh"
          }
        ]
      }
    ]
  }
}
```

**Note:** Replace `drewa` with your actual username in all paths.

## Troubleshooting

**No log file created:**
- Verify marker file exists: `cat ~/.claude/.claude-execution-log-path`
- Verify marker contains a valid path to a writable location
- Check stderr output for error messages from the hooks

**Logging stopped mid-session:**
- Marker file may have been deleted or corrupted
- Check if the log directory still exists

**Hooks not executing on Windows:**

- Claude Code captures hook configuration at session startup - changes require a new session
- Use PowerShell scripts on Windows (bash script files don't execute via Git Bash in Claude Code)
- Verify the hook command in settings.json uses the PowerShell format shown above

**Path issues on Windows:**

- Marker file should use Git Bash paths: `/c/Users/...`
- PowerShell scripts handle path conversion automatically
- Ensure the log directory exists before creating the marker file

**Dependencies:**

- Windows: PowerShell (included with Windows)
- macOS/Linux: jq (for JSON parsing in bash scripts)

## How It Works

1. **Activation:** A workflow creates the marker file containing the log path
2. **Logging:** PostToolUse hook fires on every Bash, Edit, Write, or Read call
   - Checks for marker file (exits silently if absent)
   - Appends JSONL event to the log file
3. **Finalization:** Stop hook fires when the Claude session ends
   - Writes `execution_complete` event with total event count
   - Deletes the marker file

The hooks are configured globally in settings.json, so they fire on every tool call in every project. The marker file pattern means logging only occurs when explicitly activated.
