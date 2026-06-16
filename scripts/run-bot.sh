#!/bin/bash
export PROJECT_DIR="/Volumes/DevWork/projects/ai-news-assistant"
cd "$PROJECT_DIR" || exit 1
mkdir -p "$PROJECT_DIR/output"

# Read DISCORD_BOT_TOKEN from .secrets
TOKEN=$(grep '^DISCORD_BOT_TOKEN=' .secrets | head -1 | cut -d= -f2 | tr -d '"' | tr -d "'" | xargs)
export DISCORD_BOT_TOKEN="$TOKEN"

exec "$HOME/.venvs/ainews/bin/python3" "$PROJECT_DIR/discord-bot/bot.py"
