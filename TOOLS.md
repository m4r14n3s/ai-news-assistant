# TOOLS — Rejestr narzędzi

| Narzędzie | Opis | Lokalizacja |
|-----------|------|-------------|
| `daily-scan.sh` | Uruchamia daily scan agenta | `scripts/daily-scan.sh` |
| `install-service.sh` | Instaluje launchd scheduler | `scripts/install-service.sh` |
| `bot.py` | Discord bot (interaktywny) | `discord-bot/bot.py` |
| `search.py` | Web search + RSS parsing | `src/search.py` |
| `curation.py` | Filtrowanie/ranking treści | `src/curation.py` |
| `summarize.py` | Generowanie podsumowania Obsidian | `src/summarize.py` |
| `distribute.py` | Zapis do Obsidian + Discord push | `src/distribute.py` |

## Zależności zewnętrzne

| Narzędzie | Użycie |
|-----------|--------|
| `opencode` | Orchestrator agenta |
| `python 3.12+` | Runtime skryptów |
| `discord.py` | Discord bot |
| `feedparser` | RSS parsing |
| `httpx` | Async HTTP |
| `pytest` | Testy |
