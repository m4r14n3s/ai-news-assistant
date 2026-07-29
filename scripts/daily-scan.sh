#!/usr/bin/env bash
set -euo pipefail

export PATH="$HOME/.opencode/bin:$PATH"
PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
OUTPUT_DIR="$PROJECT_DIR/output"
SESSION_FILE="$PROJECT_DIR/.ai-scan-session"
DATE=$(date +%Y-%m-%d)
TIME=$(date +%H-%M)
FORCE=${1:+true}

# Load secrets if available
if [ -f "$PROJECT_DIR/.secrets" ]; then
  set -a; source "$PROJECT_DIR/.secrets"; set +a
fi

echo "=== AI News Assistant - Daily Scan ==="
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

# Fresh session mode: delete session file to force new session
if [ "${FRESH_SESSION:-false}" = "true" ] && [ -f "$SESSION_FILE" ]; then
  echo "Fresh session mode: removing stale session $(cat "$SESSION_FILE")"
  rm -f "$SESSION_FILE"
fi

# Persistent session: resume existing or create new with fixed title
SESSION_ARGS=()
if [ -f "$SESSION_FILE" ]; then
  SESSION_ARGS=(--session "$(cat "$SESSION_FILE")")
  echo "Resuming session $(cat "$SESSION_FILE")"
else
  SESSION_ARGS=(--title "AI Assistant Scan")
  echo "Creating new session: AI Assistant Scan"
fi

opencode run "${SESSION_ARGS[@]}" --agent build --model opencode/deepseek-v4-flash-free --dir "$PROJECT_DIR" \
  "${FRESH_FLAG}Wykonaj daily scan: przeszukaj internet w poszukiwaniu AI news (AI agents, MCP, LangGraph etc.). Wygeneruj podsumowanie w formacie Obsidian z frontmatter. WAŻNE: frontmatter MUSI zawierać tags: [ai, agents, sap, daily] oraz date. każda pozycja MUSI mieć klikalny link [tekst](url) do źródła. Repozytoria GitHub z linkiem.

Format sekcji Frameworki i narzędzia agentowe (dla KAŻDEJ pozycji):
- **[Nazwa frameworku](url)** - news/zmiana (1-2 zdania po polsku, czysty język biznesowy)
  - **Opis:** czym jest, do czego służy, dla kogo, wartość biznesowa (2-3 zdania po polsku). Nazwy produktów/usług po angielsku (Joule, MCP, ABAP, LangGraph itp.), ale całe zdanie po polsku. BEZ mieszania języków w jednym zdaniu. Zamiast "announce: wchodzi w erę z GA" → "SAP ogłosił ogólną dostępność". Zamiast bug fixów technicznych → "naprawiono błąd synchronizacji stanu". Skup się na "co to umożliwia" a nie "jak to zrobiono".
  - **Źródło:** [tytuł](url)

Sekcja SAP AI opieraj wyłącznie na oficjalnych źródłach SAP: community.sap.com, news.sap.com, sap.com, pages.community.sap.com, SAP Discovery Center, SAP BTP blogi, oficjalne dokumentacje SAP AI Core / AI Launchpad / Generative AI Hub. Żadnych third-party blogów czy portali w sekcji SAP AI. Opisy w czystej polszczyźnie biznesowej - nazwy produktów SAP po angielsku, reszta po polsku.

Sekcja Źródła na końcu: każda pozycja w formacie - [Tytuł](url) - krótki opis źródła (czego dotyczy). NIE używaj tabel. Żadnych [Link] ani | # | Źródło | URL |. Zapisz jako output/${FILENAME}. Użyj websearch.

Dodatkowe źródła do sprawdzenia (oprócz websearch):
- Twitter/X: @OpenAI, @AnthropicAI, @GoogleDeepMind, @kaborojevic, @sama
- GitHub Trending dla "AI agents", "MCP", "agentic AI"
- Hacker News (news.ycombinator.com) dla AI-related postów
- arXiv (arxiv.org/list/cs.AI/recent) dla nowych paperów
- Oficjalne blogi: OpenAI, Anthropic, Google DeepMind, Meta AI"

# Save session ID after first run for future resumes
if [ ! -f "$SESSION_FILE" ]; then
  opencode session list | grep "AI Assistant Scan" | head -1 | awk '{print $1}' > "$SESSION_FILE"
  echo "Saved session ID to .ai-scan-session"
fi

# Copy to iCloud Obsidian vault (iPhone sync)
ICLOUD_VAULT="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/main/AI News"
if [ -d "$ICLOUD_VAULT" ]; then
  cp "$OUTPUT_DIR/$FILENAME" "$ICLOUD_VAULT/"
  echo "Copied to iCloud Obsidian vault"
fi

echo ""
echo "=== Scan complete -> output/$FILENAME ==="
