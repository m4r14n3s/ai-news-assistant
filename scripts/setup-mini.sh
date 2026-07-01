#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$HOME/projects/ai-news-assistant"
VENV_DIR="$HOME/.venvs/ainews"

echo "=== Mac Mini setup: AI News Assistant ==="
echo ""

# 1. Clone lub pull
if [ -d "$REPO_DIR/.git" ]; then
  echo "[1/5] Aktualizuję repo..."
  cd "$REPO_DIR" && git pull
else
  echo "[1/5] Klonuję repo..."
  mkdir -p "$(dirname "$REPO_DIR")"
  git clone https://github.com/m4r14n3s/ai-news-assistant.git "$REPO_DIR"
  cd "$REPO_DIR"
fi

# 2. Venv
echo "[2/5] Tworzę venv..."
python3 -m venv "$VENV_DIR"

# 3. Discord.py
echo "[3/5] Instaluję discord.py..."
"$VENV_DIR/bin/pip" install discord.py

# 4. Secrets
echo "[4/5] Sprawdzam .secrets..."
if [ ! -f "$REPO_DIR/.secrets" ]; then
  cat << 'EOF'
  UWAGA: brak pliku .secrets w $REPO_DIR.
  Stwórz go:
    cat > ~/projects/ai-news-assistant/.secrets << 'SECEOF'
    DISCORD_BOT_TOKEN=twój_token
    DISCORD_WEBHOOK_URL=twój_webhook
    DISCORD_CHANNEL_ID=twój_channel_id
    DISCORD_ALLOWED_USERS=twój_discord_id
    SECEOF
    chmod 600 ~/projects/ai-news-assistant/.secrets
  Potem uruchom ponownie ten skrypt.
EOF
  exit 1
fi

# 5. Start bota
echo "[5/5] Uruchamiam bota..."
cd "$REPO_DIR"
bash scripts/start-bot.sh
