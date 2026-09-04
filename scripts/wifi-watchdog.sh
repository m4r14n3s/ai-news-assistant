#!/usr/bin/env bash
# WiFi watchdog for Mac Mini - restart WiFi only if ping fails
set -euo pipefail

ROUTER="192.168.1.50"
WIFI_INTERFACE="en1"
BOT_DIR="$HOME/projects/ai-news-assistant"
LOG="$BOT_DIR/watchdog.log"
COOLDOWN_FILE="/tmp/.wifi-watchdog-cooldown"

# Cooldown: skip if WiFi was restarted in last 30s
if [ -f "$COOLDOWN_FILE" ]; then
  last=$(cat "$COOLDOWN_FILE")
  now=$(date +%s)
  if [ $((now - last)) -lt 30 ]; then
    exit 0
  fi
fi

ping -c1 -W2 "$ROUTER" >/dev/null 2>&1 && exit 0

echo "[$(date)] WiFi down - restarting WiFi only (bot reconnect auto)..." >> "$LOG"

# Restart WiFi (don't touch bot - discord.py auto-reconnects)
networksetup -setairportpower "$WIFI_INTERFACE" off
sleep 3
networksetup -setairportpower "$WIFI_INTERFACE" on

date +%s > "$COOLDOWN_FILE"

echo "[$(date)] WiFi restarted, bot untouched" >> "$LOG"
