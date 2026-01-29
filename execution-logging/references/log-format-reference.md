# Execution Logging - Log Format Reference

## Marker File

- **Location:** `~/.claude/.claude-execution-log-path`
- **Contents:** Single line containing the absolute path to the log file
- **Lifecycle:** Created by consuming workflow, deleted by Stop hook on session end

**Example:**
```
/c/Users/drewa/project/docs/2026-01-29-task/execution-log.jsonl
```

## Log Format

Logs are written in JSONL format (one JSON object per line). This format is:
- Human-readable (one event per line)
- Machine-parseable (valid JSON per line)
- Appendable (no need to parse entire file to add events)

## Event Types

### tool_call

Logged by PostToolUse hook for Bash, Edit, Write, and Read operations.

| Field | Type | Description |
|-------|------|-------------|
| event | string | Always `"tool_call"` |
| ts | string | ISO8601 UTC timestamp |
| tool | string | Tool name: Bash, Edit, Write, or Read |
| input | object | Tool input parameters (varies by tool) |
| response | object | Tool response/output |

**Example:**
```json
{"event":"tool_call","ts":"2026-01-29T10:30:00Z","tool":"Bash","input":{"command":"git status"},"response":{"output":"On branch main..."}}
```

### execution_complete

Logged by Stop hook when session ends.

| Field | Type | Description |
|-------|------|-------------|
| event | string | Always `"execution_complete"` |
| ts | string | ISO8601 UTC timestamp |
| status | string | Always `"success"` (hook completed) |
| total_events | number | Count of tool_call events in the log |

**Example:**
```json
{"event":"execution_complete","ts":"2026-01-29T10:35:00Z","status":"success","total_events":15}
```

## Tool-Specific Input Fields

### Bash
- `command`: The shell command executed

### Edit
- `file_path`: Path to the edited file
- `old_string`: Text being replaced
- `new_string`: Replacement text

### Write
- `file_path`: Path to the written file
- `content`: File contents (may be truncated in response)

### Read
- `file_path`: Path to the read file
- `offset`: Starting line (if specified)
- `limit`: Number of lines (if specified)

## Sample Log File

```jsonl
{"event":"tool_call","ts":"2026-01-29T10:30:00Z","tool":"Read","input":{"file_path":"/c/Users/drewa/project/src/main.py"},"response":{}}
{"event":"tool_call","ts":"2026-01-29T10:30:05Z","tool":"Edit","input":{"file_path":"/c/Users/drewa/project/src/main.py","old_string":"def old_func","new_string":"def new_func"},"response":{}}
{"event":"tool_call","ts":"2026-01-29T10:30:10Z","tool":"Bash","input":{"command":"python -m pytest"},"response":{"output":"3 passed"}}
{"event":"execution_complete","ts":"2026-01-29T10:35:00Z","status":"success","total_events":3}
```

## Error Handling

Hook scripts write errors to stderr but always exit 0 to avoid blocking execution. Common error messages:

| Message | Cause |
|---------|-------|
| `Marker file exists but is empty` | Marker file has no content |
| `Log directory does not exist` | Parent directory of log path missing |
| `Cannot write to log file` | Permission or disk space issue |
| `Log file not found` | Finalize called but log file missing |
| `Cannot delete marker file` | Permission issue on cleanup |

These errors appear in the terminal but do not halt Claude's execution.
