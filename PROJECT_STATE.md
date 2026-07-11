# PROJECT STATE — AI News Assistant

**Ostatnia aktualizacja:** 2026-07-08 19:14

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
| Discord bot host | **Mac Mini** (`mna@192.168.1.184`, `~/projects/ai-news-assistant`) |
| Discord bot PID | `1564` (Mini); start: `ssh mna@192.168.1.184 "cd ~/projects/ai-news-assistant && nohup bash scripts/start-bot.sh &"` |
| SSH | `ssh mna@192.168.1.184` (key auth, bez hasła); WoL: magic packet na MAC `6a:ce:d1:22:20:7d` |
| DHCP reservation | Router ASUS: MAC `2a:c9:d6:98:5e:70` → IP `192.168.1.139` (NIE DZIAŁA — Mini ma Private Wi-Fi Address, aktualny MAC `6a:ce:d1:22:20:7d`, IP `.184`)

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
- Działa w tle (nohup) na Mac Mini
- Mini nie usypia (`sudo pmset -a sleep 0 disksleep 0`)
- Restart bota: `ssh mna@192.168.1.184 "cd ~/projects/ai-news-assistant && nohup bash scripts/start-bot.sh &"`
- Laptop (MacBook Air) — tylko development kodu. Bot NIGDY na laptopie

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
- **2026-07-01** — Deployment bota na Mac Mini (mcmna). Repo w `~/projects/ai-news-assistant/`. Bot uruchomiony przez `setup-mini.sh` (venv + discord.py). Skany i bot idą z Mini, laptop tylko do developmentu.
- **2026-07-03** — SSH key auth laptop → Mini. WoL przez magic packet. `daily-scan.sh`: `$HOME` zamiast hardcoded username, dodana opencode do PATH dla non-interactive shell. `start-bot.sh`: `source .secrets` z `set -a` (wszystkie zmienne, nie tylko token). Mini ustawione `sleep 0`. Świadome rozdzielenie architektur: SAP (system security) vs POC Discord bot (policy-based). Projekt pozostaje poza strukturą SAP — intencjonalnie.
- **2026-07-05** — WiFi watchdog: cron + `scripts/wifi-watchdog.sh` na Mini. Rozwiązuje cykliczne rozłączanie WiFi (en1) które zabijało sesję Gateway bota co ~3min. Watchdog pinguje router co minutę, restartuje WiFi i bota w razie problemu.

- **2026-07-08** — Prompt `daily-scan.sh` zmieniony na biznesowy styl opisów (czysta polszczyzna, nazwy produktów po angielsku, brak mieszania języków, focus na wartość biznesową). DHCP reservation na routerze ASUS. Stałe IP dla Mini: `192.168.1.139`.

## Ostatni skan

`output/2026-07-08_19-13.md` — poprawny, styl biznesowy

## Historia sesji

- **2026-06-16** — Token Discorda zresetowany (był hardcoded w `scripts/run-bot.sh`, usunięty). Repozytorium wysłane na GitHub `m4r14n3s/ai-news-assistant` z czystą historią (bez sekretów). Dodana reguła bezpieczeństwa poświadczeń w AGENTS.md. Naprawiony skrypt scanu (`--project` → `--dir`). Format notatek zmieniony na `YYYY-MM-DD_HH-MM.md` — każdy scan tworzy osobny plik.
- **2026-06-17/18/20** — Trzy skany dzienne: frameworki (CrewAI 1.14.4, AG2 0.9.0, MCP Inspect, Claude Agent SDK billing) + SAP (AI-Native North Star, BTP ABAP + RAP, SAP Databricks). Wszystkie zapisane do `output/`.
- **2026-06-24** — Sesja 08:38. Skan: Claude 85-min outage, Enterprise MCP connectors z Okta, CrewAI 1.14.8a2, Cursor 3.8 /automate, Codex Record & Replay, Cognition $1B/$26B, MCP stateless spec RC, LangGraph 1.2.6, SAP Sapphire 2026, SAP + Snowflake, Joule w SAP for Me. Zapisany jako `output/2026-06-24_08-38.md`.
- **2026-06-24** — Sesja 15:44. Skan: Claude Tag (Slack), OpenAI GPT-5.5-Cyber, Daybreak, Patch the Planet, MCP stateless RC szczegóły, LangGraph 1.2.6. Zapisany jako `output/2026-06-24_15-44.md`.
- **2026-06-27** — Sesja 10:47. Skan: OpenAI GPT-5.6 Sol preview, Broadcom Jalapeño chip, Claude for Apple Foundation Models, iOS 27 AI extensions, CrewAI 1.14.8a5, Google ADK 2.0, MCP 2026-07-28 RC 45-day window. Zapisany jako `output/2026-06-27_10-47.md`.
- **2026-06-28** — Sesja 09:47. Skan: GPT-5.6 Sol limited by Trump admin (precedens), Broadcom $10.8B AI revenue + Jalapeño chip, Microsoft "closed gap" z Anthropic, ABAP MCP dla ADT Eclipse GA, S/4HANA Custom Code Migration Agent, CAP React/Vue.js, MCP spec 2026-07-28 RC szczegóły techniczne, Google ADK 1.0 GA w 4 językach, Microsoft Agent Framework 1.0 GA. Zapisany jako `output/2026-06-28_09-47.md`.
- **2026-07-01** — Sesja 20:29. Skan: MCP stateless spec szczegóły, LangGraph vs CrewAI adoption split, Google ADK 1.0 GA 4 języki, Microsoft Agent Framework 1.0 GA, Claude Agent SDK billing dual-bucket, GPT-5.6 Sol/Terra/Luna, OpenClaw 369K stars, Joule Studio GA, ABAP ADT dla VS Code, CAP React/Vue.js, SAP Business AI Platform. Zapisany jako `output/2026-07-01_20-29.md`.
- **2026-07-03** — Sesja 17:38. Skan: MCP 2026-07-28 RC ostatnie 25 dni do finału + Backslash Security o 3 nowych attack surfaces, Claude Sonnet 5 launch + Fable 5/Mythos 5 przywrócone + self-hosted Claude Code gateway, Google ADK 2.0 GA z graph workflow i Task API, AI Coding Agents 2026 porównanie (Claude Code vs Codex vs Devin vs Cursor), LangGraph 1.2.7 bugfix, SAP Business AI Platform konsolidacja, SAP inwestycja w n8n $5.2B, Joule Studio 2.0 intent-based development. Zapisany jako `output/2026-07-03_17-38.md`.
- **2026-07-03** — Sesja 18:56. Deployment bota na Mac Mini: SSH key auth, WoL, venv + discord.py. Naprawa `start-bot.sh` (source .secrets + venv fallback). Naprawa `daily-scan.sh` (opencode PATH, `$HOME` zamiast hardcoded). Mini `sleep 0`. /scan i /last działają z iPhone. iCloud sync przez `$HOME/Library/Mobile Documents/...`. Analiza architektury bezpieczeństwa SAP (system security) vs POC (policy-based). Zapisany jako `output/2026-07-03_17-38.md`.

- **2026-07-05** — Sesja 09:56. WiFi watchdog (cron + `wifi-watchdog.sh`) na Mini rozwiązuje cykliczne rozłączanie en1. `.gitignore`: dodano `*.log`, `nohup.out`. Ostatni commit: `a807e76`.
- **2026-07-06** — Sesja 18:27. Mini zmieniło IP z `192.168.1.139` na `192.168.1.140` po hard resecie. Bot zrestartowany PID 1564.
- **2026-07-08** — Sesja 19:12. DHCP reservation na routerze ASUS: MAC `2a:c9:d6:98:5e:70` → stałe IP `192.168.1.139`. Prompt `daily-scan.sh`: styl biznesowy zamiast technicznego. Watchdog: tylko restart WiFi, nie zabija bota. Scan timeout: 300s.

## Znane problemy

1. **launchd × dysk zewnętrzny** — macOS blokuje launchd dostęp do `/Volumes/DevWork/`. Rozwiązanie: przenieść na `~/Projects/`
2. **DuckDuckGo API** — nie zwraca wyników. Python fallback wymaga alternatywnego API. Główny flow używa opencode websearch — działa.
3. **Discord embed limit** — notatki >4096 znaków dzielone na 2 embedy. Nie do ominięcia (limit Discord API).
4. **Mini sleep → bot disconnect** — przy uśpieniu Mini bot traci sesję Gateway. `pmset -a sleep 0` powinno zapobiegać, ale wymaga monitorowania.
5. **Bot restart po resecie Mini** — brak launchd. Ręcznie: `ssh mna@192.168.1.184 "cd ~/projects/ai-news-assistant && nohup bash scripts/start-bot.sh &"`
6. **WiFi Mini niestabilne** — en1 cyklicznie gubi połączenie. Watchdog: cron co minutę pinguje router, restartuje WiFi i bota w razie problemu. Skrypt: `scripts/wifi-watchdog.sh`
7. **Private Wi-Fi Address** — macOS zmienia MAC WiFi, co psuje DHCP reservation. Rozwiązanie: wyłączyć w ustawieniach WiFi (System Settings → WiFi → szczegóły sieci → Private Wi-Fi Address → Off) lub podłączyć Ethernet.
