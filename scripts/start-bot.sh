#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$SCRIPT_DIR" || exit 1
mkdir -p output

# Read token from .secrets directly
TOKEN=$(grep '^DISCORD_BOT_TOKEN=' .secrets | head -1 | cut -d= -f2 | tr -d '"' | tr -d "'" | xargs)
export DISCORD_BOT_TOKEN="$TOKEN"

# Prefer venv, fallback to system python3
if [ -f "$HOME/.venvs/ainews/bin/python3" ]; then
  exec "$HOME/.venvs/ainews/bin/python3" discord-bot/bot.py
else
  exec python3 discord-bot/bot.py
fi
