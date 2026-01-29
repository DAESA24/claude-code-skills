#!/bin/bash
# Debug version of log-tool-event.sh

set -o pipefail

exec 2>&1  # Redirect stderr to stdout for easier debugging

echo "DEBUG: Script started"

MARKER_FILE="$HOME/.claude/.claude-execution-log-path"
echo "DEBUG: MARKER_FILE=$MARKER_FILE"

if [[ ! -f "$MARKER_FILE" ]]; then
    echo "DEBUG: Marker file not found - exiting"
    exit 0
fi
echo "DEBUG: Marker file exists"

LOG_PATH=$(cat "$MARKER_FILE" 2>/dev/null | tr -d '\r\n')
echo "DEBUG: LOG_PATH=$LOG_PATH"

if [[ -z "$LOG_PATH" ]]; then
    echo "DEBUG: Log path is empty - exiting"
    exit 0
fi
echo "DEBUG: Log path is valid"

LOG_DIR=$(dirname "$LOG_PATH")
echo "DEBUG: LOG_DIR=$LOG_DIR"

if [[ ! -d "$LOG_DIR" ]]; then
    echo "DEBUG: Log directory does not exist - exiting"
    exit 0
fi
echo "DEBUG: Log directory exists"

echo "DEBUG: About to read stdin..."
INPUT_JSON=$(cat)
echo "DEBUG: INPUT_JSON length=${#INPUT_JSON}"
echo "DEBUG: INPUT_JSON=$INPUT_JSON"

if [[ -z "$INPUT_JSON" ]]; then
    echo "DEBUG: No input received - exiting"
    exit 0
fi

TOOL_NAME=$(echo "$INPUT_JSON" | jq -r '.tool_name // "unknown"' 2>/dev/null)
echo "DEBUG: TOOL_NAME=$TOOL_NAME"

TOOL_INPUT=$(echo "$INPUT_JSON" | jq -c '.tool_input // {}' 2>/dev/null)
echo "DEBUG: TOOL_INPUT=$TOOL_INPUT"

TOOL_RESPONSE=$(echo "$INPUT_JSON" | jq -c '.tool_response // {}' 2>/dev/null)
echo "DEBUG: TOOL_RESPONSE=$TOOL_RESPONSE"

TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
echo "DEBUG: TIMESTAMP=$TIMESTAMP"

EVENT=$(jq -n -c \
    --arg event "tool_call" \
    --arg ts "$TIMESTAMP" \
    --arg tool "$TOOL_NAME" \
    --argjson input "$TOOL_INPUT" \
    --argjson response "$TOOL_RESPONSE" \
    '{event: $event, ts: $ts, tool: $tool, input: $input, response: $response}' 2>/dev/null)
echo "DEBUG: EVENT=$EVENT"

if [[ -z "$EVENT" || "$EVENT" == "null" ]]; then
    echo "DEBUG: Failed to build event - exiting"
    exit 0
fi

echo "DEBUG: About to write to $LOG_PATH"
if echo "$EVENT" >> "$LOG_PATH"; then
    echo "DEBUG: Successfully wrote to log"
else
    echo "DEBUG: Failed to write to log"
fi

echo "DEBUG: Script complete"
exit 0
