# PROJECT STATE — AI News Assistant

**Ostatnia aktualizacja:** 2026-06-16 10:10

---

## Sesja resume

Gdy wracasz/otwierasz nową sesję w tym projekcie, przeczytaj ten plik jako pierwszy.

### Konfiguracja

| Zmienna | Wartość |
|---------|---------|
| Obsidian vault | `/Users/mariusznaw/Library/Mobile Documents/iCloud~md~obsidian/Documents/main` |
| Obsidian folder | `AI News` (symlink → `output/`) |
| Discord webhook | zapisany w `.secrets` |
| Discord bot token | zapisany w `.secrets` |
| Discord bot PID | `6183` (sprawdź: `pgrep -f discord-bot/bot.py`) |

### Komendy daily

```bash
# Daily scan (Obsidian + Discord push)
bash scripts/daily-scan.sh

# Discord bot (interakcje z iPhone)
bash scripts/start-bot.sh

# Python fallback (stdlib, mniej dokładny)
python3 scripts/python-scan.py
```

### Bot Discord

- Komendy: `/scan` (nowy skan), `/last` (ostatnie podsumowanie)
- Działa w tle (nohup + disown)
- Nie restartuje się po pełnym restarcie Maca — trzeba wznowić: `bash scripts/start-bot.sh`
- Uśpienie Maca nie zabija bota

### Automatyzacja (launchd)

Wstrzymana — macOS blokuje launchd dostęp do `/Volumes/DevWork/` (dysk zewnętrzny). Gdy będzie potrzebna:
1. `mv /Volumes/DevWork/projects/ai-news-assistant ~/Projects/`
2. `bash ~/Projects/ai-news-assistant/scripts/install-services.sh`

---

## Status komponentów

| Obszar | Status | Opis |
|--------|--------|------|
| Core agent | ✅ Done | AGENTS.md, WORKFLOWS.md, KNOWLEDGE.md |
| Multi-model config | ✅ Done | opencode.json (deepseek + Claude/GPT/Ollama) |
| src/search.py | ✅ Done | Web search przez opencode agenta |
| src/curation.py | ✅ Done | Filtrowanie relevance (AI agents + SAP) |
| src/summarize.py | ✅ Done | Generowanie notatki Obsidian |
| src/distribute.py | ✅ Done | Zapis do Obsidian + Discord push |
| discord-bot/bot.py | ✅ Done | Bot z komendami /scan, /last |
| scripts/daily-scan.sh | ✅ Done | Trigger dla opencode agenta |
| scripts/start-bot.sh | ✅ Done | Uruchomienie bota w tle |
| scripts/install-services.sh | ✅ Done | Instalacja launchd |
| Obsidian vault | ✅ Done | Symlink w iCloud vault |
| Discord webhook | ✅ Done | Push podsumowań |
| Discord bot token | ✅ Done (rotated 2026-06-16) | Interakcje z iPhone — stary token wyciekł do lokalnego gita, zresetowany |
| launchd automatyzacja | ⏸️ Wstrzymana | Wymaga przeniesienia na dysk systemowy |

## Format notatki

```markdown
---
date: 2026-06-15
source: daily-scan
tags: [ai, agents, sap, daily]
---

# Daily AI Scan — 2026-06-15

## Agent Frameworks

- **[Tytuł](url)** — opis z kontekstem

## SAP AI

- **[Tytuł](url)** — opis

## Źródła

- [Tytuł](url) — krótki opis źródła
```

WAŻNE: ka.żda pozycja ma klikalny link `[tekst](url)`. Źródła jako lista, NIGDY tabela. Żadnych `[Link]`.

## Historia skanów

| Data | Plik | Wynik |
|------|------|-------|
| 2026-06-15 | `output/2026-06-15.md` | ⛔ usunięty |
| 2026-06-16 | `output/2026-06-16_10-05.md` | ~200 linii, pierwszy udany scan z timestampem |

## Historia sesji

- **2026-06-16** — Token Discorda zresetowany (był hardcoded w `scripts/run-bot.sh`, usunięty). Repozytorium wysłane na GitHub `m4r14n3s/ai-news-assistant` z czystą historią (bez sekretów). Dodana reguła bezpieczeństwa poświadczeń w AGENTS.md. Naprawiony skrypt scanu (`--project` → `--dir`). Format notatek zmieniony na `YYYY-MM-DD_HH-MM.md` — każdy scan tworzy osobny plik.

## Znane problemy

1. **launchd × dysk zewnętrzny** — macOS blokuje launchd dostęp do `/Volumes/DevWork/`. Rozwiązanie: przenieść na `~/Projects/`
2. **DuckDuckGo API** — nie zwraca wyników. Python fallback wymaga alternatywnego API. Główny flow używa opencode websearch — działa.
3. **Discord embed limit** — notatki >4096 znaków dzielone na 2 embedy. Nie do ominięcia (limit Discord API).
