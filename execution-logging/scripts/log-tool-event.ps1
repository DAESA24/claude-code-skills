# log-tool-event.ps1 - PostToolUse hook for execution logging
# Logs tool calls to JSONL format when marker file exists
#
# Marker file: ~/.claude/.claude-execution-log-path
# Contains: Single line with absolute path to log file
#
# Behavior:
#   - No marker file -> exit 0 silently (expected inactive state)
#   - Marker exists -> append JSONL event to log file
#   - Errors -> write to stderr, exit 0 (non-blocking)

$ErrorActionPreference = "SilentlyContinue"

# Marker file location
$MarkerFile = Join-Path $env:USERPROFILE ".claude\.claude-execution-log-path"

# Check if marker file exists - if not, logging is inactive
if (-not (Test-Path $MarkerFile)) {
    exit 0
}

# Read log path from marker file
$LogPath = (Get-Content $MarkerFile -Raw).Trim()

# Validate log path is not empty
if ([string]::IsNullOrWhiteSpace($LogPath)) {
    Write-Error "execution-logging: Marker file exists but is empty"
    exit 0
}

# Convert Git Bash path to Windows path if needed
if ($LogPath -match "^/c/") {
    $LogPath = $LogPath -replace "^/c/", "C:/"
}
$LogPath = $LogPath -replace "/", "\"

# Validate log path directory exists
$LogDir = Split-Path $LogPath -Parent
if (-not (Test-Path $LogDir)) {
    Write-Error "execution-logging: Log directory does not exist: $LogDir"
    exit 0
}

# Read JSON from stdin
$InputJson = [Console]::In.ReadToEnd()

# Skip if no input
if ([string]::IsNullOrWhiteSpace($InputJson)) {
    exit 0
}

try {
    # Parse input JSON
    $InputData = $InputJson | ConvertFrom-Json

    # Extract tool information
    $ToolName = if ($InputData.tool_name) { $InputData.tool_name } else { "unknown" }
    $ToolInput = if ($InputData.tool_input) { $InputData.tool_input } else { @{} }
    $ToolResponse = if ($InputData.tool_response) { $InputData.tool_response } else { @{} }

    # Generate ISO8601 timestamp
    $Timestamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")

    # Build JSONL event
    $Event = @{
        event = "tool_call"
        ts = $Timestamp
        tool = $ToolName
        input = $ToolInput
        response = $ToolResponse
    } | ConvertTo-Json -Compress -Depth 10

    # Append to log file
    Add-Content -Path $LogPath -Value $Event -NoNewline
    Add-Content -Path $LogPath -Value ""
}
catch {
    Write-Error "execution-logging: Failed to process event - $_"
    exit 0
}

exit 0
