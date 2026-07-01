# PROJECT STATE — AI News Assistant

**Ostatnia aktualizacja:** 2026-06-28 09:47

---

## Sesja resume

Gdy wracasz/otwierasz nową sesję w tym projekcie, przeczytaj ten plik jako pierwszy.

### Konfiguracja

| Zmienna | Wartość |
|---------|---------|
| Obsidian vault | `/Users/mariusznaw/Library/Mobile Documents/iCloud~md~obsidian/Documents/main` |
| iCloud sync | Kopiowanie post-scan do `AI News/` w vault (iPhone sync) |
| Obsidian folder | `AI News` (katalog w iCloud vault; skan kopiuje pliki z `output/`) |
| Discord webhook | zapisany w `.secrets` |
| Discord bot token | zapisany w `.secrets` |
| Discord bot PID | `56506` (sprawdź: `pgrep -f discord-bot/bot.py`) |

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

## Frameworki i narzędzia agentowe

- **[Nazwa frameworku](url)** — news/zmiana (1-2 zdania)
  - **Opis:** czym jest, do czego służy, mocne strony (2-3 zdania)
  - **Źródło:** [tytuł](url)

## SAP AI

- **[Tytuł](url)** — opis

## Źródła

- [Tytuł](url) — krótki opis źródła
```

WAŻNE: ka.żda pozycja ma klikalny link `[tekst](url)`. Źródła jako lista, NIGDY tabela. Żadnych `[Link]`.

### Zmiany infrastrukturalne

- **2026-07-01** — Zamieniono symlink `AI News` w iCloud vault na prawdziwy katalog. `daily-scan.sh` kopiuje plik po skanie do iCloud (iPhone sync). 11 istniejących skanów przekopiowane.

## Ostatni skan

`output/2026-06-28_09-47.md` — poprawny, 7 sekcji + źródła

## Historia sesji

- **2026-06-16** — Token Discorda zresetowany (był hardcoded w `scripts/run-bot.sh`, usunięty). Repozytorium wysłane na GitHub `m4r14n3s/ai-news-assistant` z czystą historią (bez sekretów). Dodana reguła bezpieczeństwa poświadczeń w AGENTS.md. Naprawiony skrypt scanu (`--project` → `--dir`). Format notatek zmieniony na `YYYY-MM-DD_HH-MM.md` — każdy scan tworzy osobny plik.
- **2026-06-17/18/20** — Trzy skany dzienne: frameworki (CrewAI 1.14.4, AG2 0.9.0, MCP Inspect, Claude Agent SDK billing) + SAP (AI-Native North Star, BTP ABAP + RAP, SAP Databricks). Wszystkie zapisane do `output/`.
- **2026-06-24** — Sesja 08:38. Skan: Claude 85-min outage, Enterprise MCP connectors z Okta, CrewAI 1.14.8a2, Cursor 3.8 /automate, Codex Record & Replay, Cognition $1B/$26B, MCP stateless spec RC, LangGraph 1.2.6, SAP Sapphire 2026, SAP + Snowflake, Joule w SAP for Me. Zapisany jako `output/2026-06-24_08-38.md`.
- **2026-06-24** — Sesja 15:44. Skan: Claude Tag (Slack), OpenAI GPT-5.5-Cyber, Daybreak, Patch the Planet, MCP stateless RC szczegóły, LangGraph 1.2.6. Zapisany jako `output/2026-06-24_15-44.md`.
- **2026-06-27** — Sesja 10:47. Skan: OpenAI GPT-5.6 Sol preview, Broadcom Jalapeño chip, Claude for Apple Foundation Models, iOS 27 AI extensions, CrewAI 1.14.8a5, Google ADK 2.0, MCP 2026-07-28 RC 45-day window. Zapisany jako `output/2026-06-27_10-47.md`.
- **2026-06-28** — Sesja 09:47. Skan: GPT-5.6 Sol limited by Trump admin (precedens), Broadcom $10.8B AI revenue + Jalapeño chip, Microsoft "closed gap" z Anthropic, ABAP MCP dla ADT Eclipse GA, S/4HANA Custom Code Migration Agent, CAP React/Vue.js, MCP spec 2026-07-28 RC szczegóły techniczne, Google ADK 1.0 GA w 4 językach, Microsoft Agent Framework 1.0 GA. Zapisany jako `output/2026-06-28_09-47.md`.

## Znane problemy

1. **launchd × dysk zewnętrzny** — macOS blokuje launchd dostęp do `/Volumes/DevWork/`. Rozwiązanie: przenieść na `~/Projects/`
2. **DuckDuckGo API** — nie zwraca wyników. Python fallback wymaga alternatywnego API. Główny flow używa opencode websearch — działa.
3. **Discord embed limit** — notatki >4096 znaków dzielone na 2 embedy. Nie do ominięcia (limit Discord API).
