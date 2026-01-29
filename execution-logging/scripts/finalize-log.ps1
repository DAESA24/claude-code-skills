# finalize-log.ps1 - Stop hook for execution logging
# Writes completion event and cleans up marker file
#
# Marker file: ~/.claude/.claude-execution-log-path
# Contains: Single line with absolute path to log file
#
# Behavior:
#   - No marker file -> exit 0 silently (no active logging session)
#   - Marker exists -> write completion event, delete marker
#   - Errors -> write to stderr, exit 0 (non-blocking)

$ErrorActionPreference = "SilentlyContinue"

# Marker file location
$MarkerFile = Join-Path $env:USERPROFILE ".claude\.claude-execution-log-path"

# Check if marker file exists - if not, no logging session to finalize
if (-not (Test-Path $MarkerFile)) {
    exit 0
}

# Read log path from marker file
$LogPath = (Get-Content $MarkerFile -Raw).Trim()

# Validate log path is not empty
if ([string]::IsNullOrWhiteSpace($LogPath)) {
    Write-Error "execution-logging: Marker file exists but is empty"
    Remove-Item $MarkerFile -Force -ErrorAction SilentlyContinue
    exit 0
}

# Convert Git Bash path to Windows path if needed
if ($LogPath -match "^/c/") {
    $LogPath = $LogPath -replace "^/c/", "C:/"
}
$LogPath = $LogPath -replace "/", "\"

# Check if log file exists
if (-not (Test-Path $LogPath)) {
    Write-Error "execution-logging: Log file not found: $LogPath"
    Remove-Item $MarkerFile -Force -ErrorAction SilentlyContinue
    exit 0
}

try {
    # Count tool_call events in the log
    $TotalEvents = (Select-String -Path $LogPath -Pattern '"event":"tool_call"' -AllMatches).Matches.Count
    if ($null -eq $TotalEvents) { $TotalEvents = 0 }

    # Generate ISO8601 timestamp
    $Timestamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")

    # Build completion event
    $CompletionEvent = @{
        event = "execution_complete"
        ts = $Timestamp
        status = "success"
        total_events = $TotalEvents
    } | ConvertTo-Json -Compress

    # Append completion event to log file
    Add-Content -Path $LogPath -Value $CompletionEvent -NoNewline
    Add-Content -Path $LogPath -Value ""
}
catch {
    Write-Error "execution-logging: Failed to write completion event - $_"
}

# Delete marker file to signal logging session is complete
Remove-Item $MarkerFile -Force -ErrorAction SilentlyContinue

exit 0
