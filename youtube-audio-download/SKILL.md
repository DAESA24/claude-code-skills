---
name: youtube-audio-download
description: This skill should be used when users want to download audio from YouTube videos as high-quality MP3 files with embedded metadata and thumbnails. Trigger this skill for requests like "download the audio from this YouTube video", "extract audio as MP3", "get the audio from [YouTube URL]", "save YouTube audio as MP3", or "download the soundtrack from [video URL]".
---

# YouTube Audio Download

## Overview

Download audio from YouTube videos as high-quality MP3 files with embedded metadata, thumbnails, and detailed metadata JSON files. Files are automatically saved to the pbc-media-ingestion downloads directory for easy access.

## Quick Start

To download audio from a YouTube video, invoke the pbc-media-ingestion Python script with the `--audio-only` flag:

```bash
/c/Users/drewa/pbcs/pbc-media-ingestion/tool-yt-dlp/.venv/Scripts/python.exe \
  /c/Users/drewa/pbcs/pbc-media-ingestion/tool-yt-dlp/scripts/download_youtube.py \
  "<YOUTUBE_URL>" --audio-only
```

Replace `<YOUTUBE_URL>` with the actual YouTube video or playlist URL.

## What Gets Downloaded

When you download audio from a YouTube video, you get:

- **MP3 Audio File** - High-quality audio extracted from the video (best quality available)
- **Metadata JSON File** - A detailed `.info.json` sidecar file containing 100+ fields of metadata (title, duration, channel, upload date, description, thumbnails, statistics, etc.)
- **Embedded Thumbnail** - The video thumbnail is embedded in the MP3 file
- **Embedded Metadata Tags** - ID3 tags are written to the MP3 file (title, artist, album art, etc.)

This makes the audio files ideal for music players, transcription services, and archival purposes.

## Usage

### Basic Audio Download

Execute the command with a YouTube URL:

```bash
/c/Users/drewa/pbcs/pbc-media-ingestion/tool-yt-dlp/.venv/Scripts/python.exe \
  /c/Users/drewa/pbcs/pbc-media-ingestion/tool-yt-dlp/scripts/download_youtube.py \
  "https://www.youtube.com/watch?v=dQw4w9WgXcQ" --audio-only
```

The script will:
1. Fetch the video metadata
2. Download the best available audio stream
3. Convert it to MP3 format
4. Embed the thumbnail and metadata tags
5. Save both the MP3 and JSON metadata file
6. Report the download location

### Alternative: Using Global yt-dlp with Config Preset

If you prefer using the global yt-dlp command with the audio-only configuration preset:

```bash
yt-dlp --config-location /c/Users/drewa/pbcs/pbc-media-ingestion/tool-yt-dlp/configs/audio-only.conf "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
```

Both approaches produce identical results. The Python script provides more flexibility for future enhancements.

### Downloading Playlists

To download audio from all videos in a playlist, provide the playlist URL:

```bash
/c/Users/drewa/pbcs/pbc-media-ingestion/tool-yt-dlp/.venv/Scripts/python.exe \
  /c/Users/drewa/pbcs/pbc-media-ingestion/tool-yt-dlp/scripts/download_youtube.py \
  "https://www.youtube.com/playlist?list=PLxxxx" --audio-only
```

Each video in the playlist will be downloaded as a separate MP3 file with its own metadata JSON.

## Output Location

All downloaded files are automatically saved to:

```text
C:\Users\drewa\pbcs\pbc-media-ingestion\tool-yt-dlp\downloads\
```

Files are named using the YouTube video title with these extensions:

- `.mp3` - The audio file (e.g., `Video Title.mp3`)
- `.info.json` - The metadata file (e.g., `Video Title.info.json`)

## Examples

### Download a Music Video

```bash
/c/Users/drewa/pbcs/pbc-media-ingestion/tool-yt-dlp/.venv/Scripts/python.exe \
  /c/Users/drewa/pbcs/pbc-media-ingestion/tool-yt-dlp/scripts/download_youtube.py \
  "https://www.youtube.com/watch?v=jNQXAC9IVRw" --audio-only
```

This downloads the first YouTube video ever uploaded as an MP3 file.

### Download a Podcast Episode

```bash
/c/Users/drewa/pbcs/pbc-media-ingestion/tool-yt-dlp/.venv/Scripts/python.exe \
  /c/Users/drewa/pbcs/pbc-media-ingestion/tool-yt-dlp/scripts/download_youtube.py \
  "https://www.youtube.com/@YourPodcastChannel/videos" --audio-only
```

This downloads audio from the podcast's YouTube channel.

### Download a Lecture

```bash
/c/Users/drewa/pbcs/pbc-media-ingestion/tool-yt-dlp/.venv/Scripts/python.exe \
  /c/Users/drewa/pbcs/pbc-media-ingestion/tool-yt-dlp/scripts/download_youtube.py \
  "https://www.youtube.com/watch?v=LectureLinkHere" --audio-only
```

The audio can then be transcribed or archived for reference.

## Features

- **High-Quality Audio** - Extracts the best available audio stream for each video
- **Fast Processing** - Quick download and conversion to MP3
- **Rich Metadata** - Comprehensive JSON metadata for programmatic access and indexing
- **File Embedding** - Thumbnail and metadata tags embedded in MP3 files
- **Batch Processing** - Handles playlists and channels with multiple videos
- **Automatic Organization** - All files saved to a single, consistent directory

## Troubleshooting

### Command Not Found

If you see "command not found", ensure the full path to Python is correct. The pbc-media-ingestion must be installed at `C:\Users\drewa\pbcs\pbc-media-ingestion\tool-yt-dlp\`.

### ffmpeg Missing

The script requires ffmpeg to convert video streams to MP3. FFmpeg is installed as part of the pbc-media-ingestion PBC:

- **Location:** `C:\Users\drewa\pbcs\pbc-media-ingestion\tool-ffmpeg\bin\`
- **Must be in PATH:** Ensure `C:\Users\drewa\pbcs\pbc-media-ingestion\tool-ffmpeg\bin` is in system PATH

Verify ffmpeg is accessible:

```bash
ffmpeg -version
```

### Large Video Files Take Time

Very long videos or high-resolution streams take longer to download and convert. This is normal. The progress will be shown in the terminal.

### Playlist Not Downloading

Ensure the playlist URL is correct and the playlist is public or unlisted (private playlists won't work). Check that you're using the full playlist URL, not just a video URL from the playlist.

### File Encoding Issues

If the output filename has special characters that don't render correctly, this is a terminal/filesystem encoding issue. The file is still valid; try opening it in another application or checking the `.info.json` file for the correct video title.
