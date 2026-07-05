#!/usr/bin/env bash
# WiFi watchdog for Mac Mini — restart WiFi + bot if ping fails
set -euo pipefail

ROUTER="192.168.1.50"
WIFI_INTERFACE="en1"
BOT_DIR="$HOME/projects/ai-news-assistant"
LOG="$BOT_DIR/watchdog.log"

ping -c1 -W2 "$ROUTER" >/dev/null 2>&1 && exit 0

echo "[$(date)] WiFi down — restarting..." >> "$LOG"

# Restart WiFi
networksetup -setairportpower "$WIFI_INTERFACE" off
sleep 3
networksetup -setairportpower "$WIFI_INTERFACE" on

# Wait for DHCP
sleep 10

# Restart bot
BOT_PID=$(pgrep -f bot.py 2>/dev/null || true)
if [ -n "$BOT_PID" ]; then
  kill "$BOT_PID" 2>/dev/null || true
  sleep 2
fi

cd "$BOT_DIR"
nohup bash scripts/start-bot.sh > bot.log 2>&1 &

echo "[$(date)] Bot restarted (PID $(pgrep -f bot.py))" >> "$LOG"
