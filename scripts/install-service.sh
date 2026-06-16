#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PLIST_DIR="$HOME/Library/LaunchAgents"
PLIST_PATH="$PLIST_DIR/com.ainewsassistant.dailyscan.plist"
SCRIPT_PATH="$PROJECT_DIR/scripts/daily-scan.sh"

mkdir -p "$PLIST_DIR"

cat > "$PLIST_PATH" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.ainewsassistant.dailyscan</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>${SCRIPT_PATH}</string>
    </array>
    <key>StartCalendarInterval</key>
    <dict>
        <key>Hour</key>
        <integer>7</integer>
        <key>Minute</key>
        <integer>0</integer>
    </dict>
    <key>WorkingDirectory</key>
    <string>${PROJECT_DIR}</string>
    <key>EnvironmentVariables</key>
    <dict>
        <key>PATH</key>
        <string>/usr/local/bin:/usr/bin:/bin:${PATH}</string>
        <key>DISCORD_WEBHOOK_URL</key>
        <string>${DISCORD_WEBHOOK_URL:-}</string>
        <key>OBSIDIAN_VAULT_PATH</key>
        <string>${OBSIDIAN_VAULT_PATH:-${PROJECT_DIR}/output}</string>
    </dict>
    <key>RunAtLoad</key>
    <false/>
    <key>KeepAlive</key>
    <false/>
    <key>StandardOutPath</key>
    <string>${PROJECT_DIR}/output/scan.log</string>
    <key>StandardErrorPath</key>
    <string>${PROJECT_DIR}/output/scan.err</string>
</dict>
</plist>
EOF

launchctl load "$PLIST_PATH"
echo "Service installed: $PLIST_PATH"
echo "Daily scan will run at 07:00"
echo ""
echo "To test: launchctl start com.ainewsassistant.dailyscan"
echo "To stop: launchctl unload $PLIST_PATH"
