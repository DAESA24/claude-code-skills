#!/bin/bash
# log-tool-event.sh - PostToolUse hook for execution logging
# Logs tool calls to JSONL format when marker file exists
#
# Marker file: ~/.claude/.claude-execution-log-path
# Contains: Single line with absolute path to log file
#
# Behavior:
#   - No marker file → exit 0 silently (expected inactive state)
#   - Marker exists → append JSONL event to log file
#   - Errors → write to stderr, exit 0 (non-blocking)

set -o pipefail

# Marker file location (use $HOME for portability)
MARKER_FILE="$HOME/.claude/.claude-execution-log-path"

# Check if marker file exists - if not, logging is inactive
if [[ ! -f "$MARKER_FILE" ]]; then
    exit 0
fi

# Read log path from marker file
LOG_PATH=$(cat "$MARKER_FILE" 2>/dev/null | tr -d '\r\n')

# Validate log path is not empty
if [[ -z "$LOG_PATH" ]]; then
    echo "execution-logging: Marker file exists but is empty" >&2
    exit 0
fi

# Validate log path directory exists
LOG_DIR=$(dirname "$LOG_PATH")
if [[ ! -d "$LOG_DIR" ]]; then
    echo "execution-logging: Log directory does not exist: $LOG_DIR" >&2
    exit 0
fi

# Read JSON from stdin
INPUT_JSON=$(cat)

# Parse tool information using jq
# Hook input structure: { tool_name, tool_input, tool_response }
TOOL_NAME=$(echo "$INPUT_JSON" | jq -r '.tool_name // "unknown"' 2>/dev/null)
TOOL_INPUT=$(echo "$INPUT_JSON" | jq -c '.tool_input // {}' 2>/dev/null)
TOOL_RESPONSE=$(echo "$INPUT_JSON" | jq -c '.tool_response // {}' 2>/dev/null)

# Generate ISO8601 timestamp
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Build JSONL event
EVENT=$(jq -n -c \
    --arg event "tool_call" \
    --arg ts "$TIMESTAMP" \
    --arg tool "$TOOL_NAME" \
    --argjson input "$TOOL_INPUT" \
    --argjson response "$TOOL_RESPONSE" \
    '{event: $event, ts: $ts, tool: $tool, input: $input, response: $response}' 2>/dev/null)

# Validate event was created
if [[ -z "$EVENT" || "$EVENT" == "null" ]]; then
    echo "execution-logging: Failed to build JSONL event" >&2
    exit 0
fi

# Append to log file
if ! echo "$EVENT" >> "$LOG_PATH" 2>/dev/null; then
    echo "execution-logging: Cannot write to log file: $LOG_PATH" >&2
    exit 0
fi

exit 0
