#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
OUTPUT_DIR="$PROJECT_DIR/output"
DATE=$(date +%Y-%m-%d)
FORCE=${1:+true}

# Load secrets if available
if [ -f "$PROJECT_DIR/.secrets" ]; then
  set -a; source "$PROJECT_DIR/.secrets"; set +a
fi

echo "=== AI News Assistant — Daily Scan ==="
echo "Date: $DATE"
echo "Project: $PROJECT_DIR"
if [ "$FORCE" = "true" ]; then
  echo "Mode: forced fresh scan"
fi
echo ""

mkdir -p "$OUTPUT_DIR"

cd "$PROJECT_DIR"

# Build a time-unique suffix for manual scans
SUFFIX=""
if [ "$FORCE" = "true" ]; then
  SUFFIX="-$(date +%H%M)"
fi
FILENAME="${DATE}${SUFFIX}.md"

FRESH_FLAG=""
if [ "$FORCE" = "true" ]; then
  FRESH_FLAG="Wykonaj ŚWIEŻE wyszukiwanie - nie czytaj żadnych istniejących plików w output/. "
fi

opencode run --project "$PROJECT_DIR" --agent build --model opencode/deepseek-v4-flash-free \
  "${FRESH_FLAG}Wykonaj daily scan: przeszukaj internet w poszukiwaniu AI news (AI agents, SAP AI, MCP, LangGraph etc.). Wygeneruj podsumowanie w formacie Obsidian z frontmatter. WAŻNE: każda pozycja MUSI mieć klikalny link [tekst](url) do źródła. Repozytoria GitHub z linkiem. Sekcja Źródła na końcu: każda pozycja w formacie - [Tytuł](url) — krótki opis źródła (czego dotyczy). NIE używaj tabel. Żadnych [Link] ani | # | Źródło | URL |. Nie czytaj żadnych istniejących plików w output/. Zapisz jako output/${FILENAME}. Użyj websearch."

echo ""
echo "=== Scan complete -> output/$FILENAME ==="
