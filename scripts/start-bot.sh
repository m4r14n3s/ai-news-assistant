#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$SCRIPT_DIR" || exit 1
mkdir -p output

# Load all secrets as exported env vars
if [ -f ".secrets" ]; then
  set -a; source .secrets; set +a
fi

# Prefer venv, fallback to system python3
if [ -f "$HOME/.venvs/ainews/bin/python3" ]; then
  exec "$HOME/.venvs/ainews/bin/python3" discord-bot/bot.py
else
  exec python3 discord-bot/bot.py
fi
