#!/bin/bash
# finalize-log.sh - Stop hook for execution logging
# Writes completion event and cleans up marker file
#
# Marker file: ~/.claude/.claude-execution-log-path
# Contains: Single line with absolute path to log file
#
# Behavior:
#   - No marker file → exit 0 silently (no active logging session)
#   - Marker exists → write completion event, delete marker
#   - Errors → write to stderr, exit 0 (non-blocking)

set -o pipefail

# Marker file location (use $HOME for portability)
MARKER_FILE="$HOME/.claude/.claude-execution-log-path"

# Check if marker file exists - if not, no logging session to finalize
if [[ ! -f "$MARKER_FILE" ]]; then
    exit 0
fi

# Read log path from marker file
LOG_PATH=$(cat "$MARKER_FILE" 2>/dev/null | tr -d '\r\n')

# Validate log path is not empty
if [[ -z "$LOG_PATH" ]]; then
    echo "execution-logging: Marker file exists but is empty" >&2
    # Clean up invalid marker
    rm -f "$MARKER_FILE" 2>/dev/null
    exit 0
fi

# Check if log file exists
if [[ ! -f "$LOG_PATH" ]]; then
    echo "execution-logging: Log file not found: $LOG_PATH" >&2
    # Clean up marker even if log is missing
    rm -f "$MARKER_FILE" 2>/dev/null
    exit 0
fi

# Count tool_call events in the log
TOTAL_EVENTS=$(grep -c '"event":"tool_call"' "$LOG_PATH" 2>/dev/null || echo "0")

# Generate ISO8601 timestamp
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Build completion event
COMPLETION_EVENT=$(jq -n -c \
    --arg event "execution_complete" \
    --arg ts "$TIMESTAMP" \
    --arg status "success" \
    --argjson total "$TOTAL_EVENTS" \
    '{event: $event, ts: $ts, status: $status, total_events: $total}' 2>/dev/null)

# Validate event was created
if [[ -z "$COMPLETION_EVENT" || "$COMPLETION_EVENT" == "null" ]]; then
    echo "execution-logging: Failed to build completion event" >&2
    # Still try to clean up marker
    rm -f "$MARKER_FILE" 2>/dev/null
    exit 0
fi

# Append completion event to log file
if ! echo "$COMPLETION_EVENT" >> "$LOG_PATH" 2>/dev/null; then
    echo "execution-logging: Cannot write completion event to: $LOG_PATH" >&2
fi

# Delete marker file to signal logging session is complete
if ! rm -f "$MARKER_FILE" 2>/dev/null; then
    echo "execution-logging: Cannot delete marker file: $MARKER_FILE" >&2
fi

exit 0
