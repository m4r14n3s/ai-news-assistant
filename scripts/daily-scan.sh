#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
OUTPUT_DIR="$PROJECT_DIR/output"
DATE=$(date +%Y-%m-%d)
TIME=$(date +%H-%M)
FORCE=${1:+true}

# Load secrets if available
if [ -f "$PROJECT_DIR/.secrets" ]; then
  set -a; source "$PROJECT_DIR/.secrets"; set +a
fi

echo "=== AI News Assistant — Daily Scan ==="
echo "Date: $DATE"
echo "Project: $PROJECT_DIR"
echo ""

mkdir -p "$OUTPUT_DIR"

cd "$PROJECT_DIR"

FILENAME="${DATE}_${TIME}.md"

FRESH_FLAG=""
if [ "$FORCE" = "true" ]; then
  FRESH_FLAG="Wykonaj ŚWIEŻE wyszukiwanie - nie czytaj żadnych istniejących plików w output/. "
fi

opencode run --agent build --model opencode/deepseek-v4-flash-free --dir "$PROJECT_DIR" \
  "${FRESH_FLAG}Wykonaj daily scan: przeszukaj internet w poszukiwaniu AI news (AI agents, MCP, LangGraph etc.). Wygeneruj podsumowanie w formacie Obsidian z frontmatter. WAŻNE: każda pozycja MUSI mieć klikalny link [tekst](url) do źródła. Repozytoria GitHub z linkiem. Sekcja SAP AI opieraj wyłącznie na oficjalnych źródłach SAP: community.sap.com, news.sap.com, sap.com, pages.community.sap.com, SAP Discovery Center, SAP BTP blogi, oficjalne dokumentacje SAP AI Core / AI Launchpad / Generative AI Hub. Żadnych third-party blogów czy portali w sekcji SAP AI. Sekcja Źródła na końcu: każda pozycja w formacie - [Tytuł](url) — krótki opis źródła (czego dotyczy). NIE używaj tabel. Żadnych [Link] ani | # | Źródło | URL |. Zapisz jako output/${FILENAME}. Użyj websearch."

echo ""
echo "=== Scan complete -> output/$FILENAME ==="
