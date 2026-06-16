#!/bin/bash
cd /Volumes/DevWork/projects/ai-news-assistant || exit 1
mkdir -p output

# Read token from .secrets directly
TOKEN=$(grep '^DISCORD_BOT_TOKEN=' .secrets | head -1 | cut -d= -f2 | tr -d '"' | tr -d "'" | xargs)
export DISCORD_BOT_TOKEN="$TOKEN"

exec "$HOME/.venvs/ainews/bin/python3" discord-bot/bot.py
