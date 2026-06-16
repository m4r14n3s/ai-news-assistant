#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PLIST_DIR="$HOME/Library/LaunchAgents"
mkdir -p "$PLIST_DIR"

# Load secrets for env vars
if [ -f "$PROJECT_DIR/.secrets" ]; then
  set -a; source "$PROJECT_DIR/.secrets"; set +a
fi

# ─── 1. Daily Scan (07:00) ───
SCAN_PLIST="$PLIST_DIR/com.ainewsassistant.dailyscan.plist"
cat > "$SCAN_PLIST" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.ainewsassistant.dailyscan</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>${PROJECT_DIR}/scripts/daily-scan.sh</string>
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
launchctl load "$SCAN_PLIST"
echo "✅ Daily scan service installed (07:00)"

# ─── 2. Discord Bot (persistent) ───
BOT_PLIST="$PLIST_DIR/com.ainewsassistant.bot.plist"
cat > "$BOT_PLIST" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.ainewsassistant.bot</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>${PROJECT_DIR}/scripts/start-bot.sh</string>
    </array>
    <key>WorkingDirectory</key>
    <string>${PROJECT_DIR}</string>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>${PROJECT_DIR}/output/bot.log</string>
    <key>StandardErrorPath</key>
    <string>${PROJECT_DIR}/output/bot.err</string>
    <key>ThrottleInterval</key>
    <integer>5</integer>
</dict>
</plist>
EOF
launchctl load "$BOT_PLIST"
echo "✅ Discord bot service installed (persistent)"

echo ""
echo "---"
echo "Status:"
echo "  launchctl list | grep ain"
echo "Logs:"
echo "  tail -f ${PROJECT_DIR}/output/bot.log"
echo "  tail -f ${PROJECT_DIR}/output/scan.log"
echo ""
echo "Manual run: bash ${PROJECT_DIR}/scripts/daily-scan.sh"
