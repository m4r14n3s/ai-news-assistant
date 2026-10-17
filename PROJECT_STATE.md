# PROJECT STATE - AI News Assistant

**Ostatnia aktualizacja:** 2026-10-17 22:20

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
| Discord bot host | **Mac Mini** (`mna@192.168.1.139`, `~/projects/ai-news-assistant`) |
| Discord bot | launchd `com.ainewsassistant.bot` (system domain, `KeepAlive=true`, konto `aiag`); PID `591`, uptime od 2026-10-06 |
| Scan automation | launchd `com.ainewsassistant.dailyscan` (system domain, konto `aiag`), codziennie 07:00 |
| Model scanu | `opencode-go/deepseek-v4.1-flash` (od 2026-10-17; poprzednie `deepseek-v4-flash` wycofane z katalogu providera) |
| Hermes (drugi agent) | launchd `com.hermes.gateway` (system domain, konto `aiag`); `HERMES_HOME=/Users/aiag/projects/hermes/.hermes` |
| Klucz `opencode-go` | dwóch konsumentów na Mini: opencode CLI (`~/.local/share/opencode/auth.json`) i Hermes (`hermes/.hermes/.env` → `OPENCODE_GO_API_KEY`). Rotacja = oba miejsca! |
| iCloud sync | ⚠️ Wymaga aktywnej sesji GUI na Mini. FileVault ON → **brak auto-login**. Po każdym resecie Mini zaloguj się raz przez Screen Sharing, aby `bird` wystartował i Obsidian zsynchronizował skany. |
| SSH | `ssh mna@192.168.1.139` (key auth, bez hasła); WoL: magic packet na MAC `14:98:77:70:6c:6e` |
| DHCP reservation | Router ASUS: MAC `14:98:77:70:6c:6e` → IP `192.168.1.139` (fizyczny MAC, Private WiFi Address OFF) |

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
- Restart bota: `ssh mna@192.168.1.139 "cd ~/projects/ai-news-assistant && nohup bash scripts/start-bot.sh &"`
- Laptop (MacBook Air) - tylko development kodu. Bot NIGDY na laptopie

### Automatyzacja (launchd)

**Produkcja (Mac mini): działa.** Dwa daemony systemowe w `/Library/LaunchDaemons/` (instalacja: `~/scripts/setup-aiag-daemons.sh` na Mini):
- `com.ainewsassistant.dailyscan` - `scripts/daily-scan.sh`, codziennie 07:00, konto `aiag`, logi `output/scan.log` / `output/scan.err`
- `com.ainewsassistant.bot` - `scripts/start-bot.sh`, `KeepAlive=true`, konto `aiag`, logi `output/bot.out.log` / `output/bot.err.log`

**Host (MacBook): wstrzymane** - macOS blokuje launchd dostęp do `/Volumes/DevWork/` (dysk zewnętrzny). Gdy będzie potrzebne:
1. `mv /Volumes/DevWork/projects/ai-news-assistant ~/Projects/`
2. `bash ~/Projects/ai-news-assistant/scripts/install-services.sh`

---

## Hermes (drugi agent na Mac mini)

Agent AI z własnym gatewayem (Telegram) i tool-callingiem. **Nie należy do tego repo** - kod w `~/projects/hermes`, konfiguracja w `~/projects/hermes/.hermes`.

| Element | Wartość |
|---------|---------|
| launchd | `com.hermes.gateway` (`/Library/LaunchDaemons/`, system domain, `KeepAlive=true`, `RunAtLoad=true`, konto `aiag`) |
| `HERMES_HOME` | `/Users/aiag/projects/hermes/.hermes` (z plist; **nie** `~/.hermes` - to inny, poboczny profil) |
| Uruchomienie | `python -m hermes_cli.main gateway run` z venv `~/projects/hermes/.venv` |
| Provider / model | `opencode-go` (`base_url https://opencode.ai/zen/go/v1`), `config.yaml` → `model.default: deepseek-v4.1-flash` |
| Credential | `OPENCODE_GO_API_KEY` w `~/projects/hermes/.hermes/.env` (pool: `auth.json` → `credential_pool.opencode-go`, `source: env:OPENCODE_GO_API_KEY`) |
| Logi | `~/projects/hermes/.hermes/logs/`: `gateway.log`, `gateway.err.log`, `errors.log`, `agent.log` |
| Weryfikacja jednym strzałem | `export HERMES_HOME=/Users/aiag/projects/hermes/.hermes && .venv/bin/python -m hermes_cli.main -z "Reply with exactly: OK"` |
| Restart | `hermes gateway restart` (uruchamiać w tle/bez blokującego SSH - patrz pułapka niżej) lub `sudo launchctl kickstart -k system/com.hermes.gateway` |

**Zadania cron Hermesa (profil live - ticker wbudowany w gateway, `cron/ticker_heartbeat`):**

| ID | Nazwa | Harmonogram | Ostatnie uruchomienie | Następne |
|----|-------|-------------|----------------------|----------|
| `43c875441bfa` | `borealis-scorpionfish-watch` (skill `product-price-monitor`) | `0 9 * * *` | 2026-10-17 09:02 ok | 2026-10-18 09:00 |
| `2776d1c1f30c` | `ai-information-news` | co 43200 min (30 dni) | 2026-09-19 13:10 ok | 2026-10-19 13:10 |

Historia uruchomień: `cron/executions.db` (kolumna `status`), wyniki: `cron/output/<job_id>/`.

**Pułapki (potwierdzone 2026-10-17):**
- CLI bez `export HERMES_HOME=...` działa na `~/.hermes`, czyli **nie na tym profilu, którego używa daemon** → mylące `auth status: logged out`, `cron list: brak zadań`, `auth reset: 0 credentials`.
- `hermes gateway restart` podpięty do sesji SSH potrafi zostawić proces-sierotę (double-run) obok instancji z launchd - po restarcie sprawdzić, że istnieje **dokładnie jeden** proces i że trzyma `gateway.lock` + lock Telegrama (`~/.local/state/hermes/gateway-locks/`).
- Rotacja klucza `opencode-go` w OpenCode Console unieważnia poprzedni klucz - trzeba go podmienić w **obu** konsumentach (opencode CLI i Hermes), inaczej jeden z agentów zwraca `401 api_key_expired` przy zachowaniu „żywego” procesu.
- Flapy WiFi (en1) generują w logach Hermesa dziesiątki–setki `nodename nor servname` / `ReadError` dziennie; adapter Telegrama wznawia polling sam, to nie jest awaria agenta.

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
| Discord bot token | ✅ Done (rotated 2026-06-16) | Interakcje z iPhone - stary token wyciekł do lokalnego gita, zresetowany |
| launchd automatyzacja | ✅ Done (Mini) | Bot + dailyscan w `/Library/LaunchDaemons/`; host - wstrzymane (`/Volumes/DevWork/`) |
| Hermes (osobny projekt, `~/projects/hermes`) | ✅ Done | Agent AI + gateway Telegram, launchd `com.hermes.gateway`, konto `aiag`; osobna dokumentacja poza tym repo |

## Format notatki

```markdown
---
date: 2026-06-15
source: daily-scan
tags: [ai, agents, sap, daily]
---

# Daily AI Scan - 2026-06-15

## Frameworki i narzędzia agentowe

- **[Nazwa frameworku](url)** - news/zmiana (1-2 zdania)
  - **Opis:** czym jest, do czego służy, mocne strony (2-3 zdania)
  - **Źródło:** [tytuł](url)

## SAP AI

- **[Tytuł](url)** - opis

## Źródła

- [Tytuł](url) - krótki opis źródła
```

WAŻNE: ka.żda pozycja ma klikalny link `[tekst](url)`. Źródła jako lista, NIGDY tabela. Żadnych `[Link]`.

### Zmiany infrastrukturalne

- **2026-07-01** - Zamieniono symlink `AI News` w iCloud vault na prawdziwy katalog. `daily-scan.sh` kopiuje plik po skanie do iCloud (iPhone sync). 11 istniejących skanów przekopiowane.
- **2026-07-01** - Deployment bota na Mac Mini (mcmna). Repo w `~/projects/ai-news-assistant/`. Bot uruchomiony przez `setup-mini.sh` (venv + discord.py). Skany i bot idą z Mini, laptop tylko do developmentu.
- **2026-07-03** - SSH key auth laptop → Mini. WoL przez magic packet. `daily-scan.sh`: `$HOME` zamiast hardcoded username, dodana opencode do PATH dla non-interactive shell. `start-bot.sh`: `source .secrets` z `set -a` (wszystkie zmienne, nie tylko token). Mini ustawione `sleep 0`. Świadome rozdzielenie architektur: SAP (system security) vs POC Discord bot (policy-based). Projekt pozostaje poza strukturą SAP - intencjonalnie.
- **2026-07-05** - WiFi watchdog: cron + `scripts/wifi-watchdog.sh` na Mini. Rozwiązuje cykliczne rozłączanie WiFi (en1) które zabijało sesję Gateway bota co ~3min. Watchdog pinguje router co minutę, restartuje WiFi i bota w razie problemu.

- **2026-07-08** - Prompt `daily-scan.sh` zmieniony na biznesowy styl opisów (czysta polszczyzna, nazwy produktów po angielsku, brak mieszania języków, focus na wartość biznesową). DHCP reservation na routerze ASUS. Stałe IP dla Mini: `192.168.1.139`.
- **2026-07-11** - Sesja 23:00. Private Wi-Fi Address wyłączony (MAC `14:98:77:70:6c:6e`). DHCP reservation działa (`.139`). Bot PID 1564, uptime 5 dni. Ostatni commit: `7a54f48`.
- **2026-07-18** - Dodane źródła do `daily-scan.sh`: Twitter/X, GitHub Trending, HN, arXiv, blogi OpenAI/Anthropic/Google. Bot zrestartowany PID 25363 po zdechnięciu.
- **2026-10-17** - Rotacja klucza API providera `opencode-go` na Mini (poprzedni wygasł; `~/.local/share/opencode/auth.json` pochodził z 23.08). Model scanu podniesiony z wycofanego `opencode-go/deepseek-v4-flash` na `opencode-go/deepseek-v4.1-flash` (`scripts/daily-scan.sh`), w `opencode.json` `deepseek-v4-flash-free` → `deepseek-v4.1-flash-free`. Commit `382e173` + `git pull --ff-only` na Mini (HEAD `382e173`).
- **2026-10-17** - Świeża sesja scanu: `.ai-scan-session` → `ses_eb4a36c6cffe7XUAySI5JJeRb0`. Poprzednia sesja `ses_fc36c33fcffekp5Vhz528xknKm` (404 wiadomości, 37,7 mln tokenów wejściowych narastająco) pozostaje w bazie `~/.local/share/opencode/opencode.db` jako archiwum i nie jest już wznawiana.

## Ostatni skan

Produkcja: Mac mini (konto `aiag`), codziennie 07:00, wynik trafia do Obsidian (iCloud vault). Skany działały do **2026-10-14** (ostatni `2026-10-14_21-28.md`). **Luka 2026-10-15/16/17** (07:00) - wycofany model `deepseek-v4-flash` i wygasły klucz `opencode-go`; decyzja użytkownika: bez backfillu, powrót do rytmu od 2026-10-18.

Ostatni skan: `2026-10-17_21-35.md` - przebieg weryfikacyjny po naprawie, `EXIT=0`, 25,7 kB / 156 linii, obecny w vaultcie na Mini (`mna`) i na laptopie (iCloud).

Lokalny `output/` (host) to kopia deweloperska: ostatni zachowany plik `output/2026-09-05_18-30.md`. Trzy skany testowe z 2026-10-11 (`09-29`, `09-55`, `10-17`) usunięte na polecenie użytkownika.

## Historia sesji

- **2026-06-16** - Token Discorda zresetowany (był hardcoded w `scripts/run-bot.sh`, usunięty). Repozytorium wysłane na GitHub `m4r14n3s/ai-news-assistant` z czystą historią (bez sekretów). Dodana reguła bezpieczeństwa poświadczeń w AGENTS.md. Naprawiony skrypt scanu (`--project` → `--dir`). Format notatek zmieniony na `YYYY-MM-DD_HH-MM.md` - każdy scan tworzy osobny plik.
- **2026-06-17/18/20** - Trzy skany dzienne: frameworki (CrewAI 1.14.4, AG2 0.9.0, MCP Inspect, Claude Agent SDK billing) + SAP (AI-Native North Star, BTP ABAP + RAP, SAP Databricks). Wszystkie zapisane do `output/`.
- **2026-06-24** - Sesja 08:38. Skan: Claude 85-min outage, Enterprise MCP connectors z Okta, CrewAI 1.14.8a2, Cursor 3.8 /automate, Codex Record & Replay, Cognition $1B/$26B, MCP stateless spec RC, LangGraph 1.2.6, SAP Sapphire 2026, SAP + Snowflake, Joule w SAP for Me. Zapisany jako `output/2026-06-24_08-38.md`.
- **2026-06-24** - Sesja 15:44. Skan: Claude Tag (Slack), OpenAI GPT-5.5-Cyber, Daybreak, Patch the Planet, MCP stateless RC szczegóły, LangGraph 1.2.6. Zapisany jako `output/2026-06-24_15-44.md`.
- **2026-06-27** - Sesja 10:47. Skan: OpenAI GPT-5.6 Sol preview, Broadcom Jalapeño chip, Claude for Apple Foundation Models, iOS 27 AI extensions, CrewAI 1.14.8a5, Google ADK 2.0, MCP 2026-07-28 RC 45-day window. Zapisany jako `output/2026-06-27_10-47.md`.
- **2026-06-28** - Sesja 09:47. Skan: GPT-5.6 Sol limited by Trump admin (precedens), Broadcom $10.8B AI revenue + Jalapeño chip, Microsoft "closed gap" z Anthropic, ABAP MCP dla ADT Eclipse GA, S/4HANA Custom Code Migration Agent, CAP React/Vue.js, MCP spec 2026-07-28 RC szczegóły techniczne, Google ADK 1.0 GA w 4 językach, Microsoft Agent Framework 1.0 GA. Zapisany jako `output/2026-06-28_09-47.md`.
- **2026-07-01** - Sesja 20:29. Skan: MCP stateless spec szczegóły, LangGraph vs CrewAI adoption split, Google ADK 1.0 GA 4 języki, Microsoft Agent Framework 1.0 GA, Claude Agent SDK billing dual-bucket, GPT-5.6 Sol/Terra/Luna, OpenClaw 369K stars, Joule Studio GA, ABAP ADT dla VS Code, CAP React/Vue.js, SAP Business AI Platform. Zapisany jako `output/2026-07-01_20-29.md`.
- **2026-07-03** - Sesja 17:38. Skan: MCP 2026-07-28 RC ostatnie 25 dni do finału + Backslash Security o 3 nowych attack surfaces, Claude Sonnet 5 launch + Fable 5/Mythos 5 przywrócone + self-hosted Claude Code gateway, Google ADK 2.0 GA z graph workflow i Task API, AI Coding Agents 2026 porównanie (Claude Code vs Codex vs Devin vs Cursor), LangGraph 1.2.7 bugfix, SAP Business AI Platform konsolidacja, SAP inwestycja w n8n $5.2B, Joule Studio 2.0 intent-based development. Zapisany jako `output/2026-07-03_17-38.md`.
- **2026-07-03** - Sesja 18:56. Deployment bota na Mac Mini: SSH key auth, WoL, venv + discord.py. Naprawa `start-bot.sh` (source .secrets + venv fallback). Naprawa `daily-scan.sh` (opencode PATH, `$HOME` zamiast hardcoded). Mini `sleep 0`. /scan i /last działają z iPhone. iCloud sync przez `$HOME/Library/Mobile Documents/...`. Analiza architektury bezpieczeństwa SAP (system security) vs POC (policy-based). Zapisany jako `output/2026-07-03_17-38.md`.

- **2026-07-05** - Sesja 09:56. WiFi watchdog (cron + `wifi-watchdog.sh`) na Mini rozwiązuje cykliczne rozłączanie en1. `.gitignore`: dodano `*.log`, `nohup.out`. Ostatni commit: `a807e76`.
- **2026-07-06** - Sesja 18:27. Mini zmieniło IP z `192.168.1.139` na `192.168.1.140` po hard resecie. Bot zrestartowany PID 1564.
- **2026-07-08** - Sesja 19:12. DHCP reservation na routerze ASUS: MAC `2a:c9:d6:98:5e:70` → stałe IP `192.168.1.139`. Prompt `daily-scan.sh`: styl biznesowy zamiast technicznego. Watchdog: tylko restart WiFi, nie zabija bota. Scan timeout: 300s.
- **2026-07-18** - Sesja 09:21. Dodane źródła do `daily-scan.sh`: Twitter/X (OpenAI, Anthropic, Google), GitHub Trending, HN, arXiv, blogi producentów. Bot padł, zrestartowany PID 25363. Synchronizacja plików po sesji.
- **2026-07-29** - Sesja 18:56. Reguła 0 w AGENTS.md (NIGDY nie usuwać bez zgody). `/fresh` (nowa sesja), `/scan` (persistent). `/fresh` timeout 600s. `/last` pomija pliki <100B. Frontmatter wymuszone tags. Private WiFi Address OFF na stałe. Bot PID 51858.
- **2026-08-14** - Sesja 18:32. Bot na Mini martwy od 2026-08-11 15:02 (padł po timeoutzie `/scan`, stacktrace w `bot.log`). Zrestartowany: PID 11962, połączony z Gateway. Bez launchd, restart tylko ręczny — open issue #5.
- **2026-08-16** - Sesja 13:05. Diagnoza braku skanów w Obsidian: skany POWSTAJA (output/2026-08-16_11-59.md), ale iCloud Drive na Mini nie synchronizuje, bo Mini zrestartowany 13.08 bez zalogowania sesji GUI (loginwindow console, auto-login zablokowany przez FileVault ON, bird nie działa). Laptopowy vault kończy się na 2026-08-10. Usunięto `.ai-scan-session` (wskazywał na usuniętą sesję `ses_ff9e95...`). Decyzja: po resecie Mini loguj się raz przez Screen Sharing — iCloud wstaje sam.
- **2026-08-16** - Sesja 13:10. Naprawa iCloud sync. Po zalogowaniu do GUI (Screen Sharing) bird wystartował. Zaległe skany (15, 16.08) skopiowane przez scp do laptopowego vault nie miały metadanych iCloud — rozwiązanie: `killall fileproviderd` na laptopie → pliki dostały flagę `compressed,dataless` (zarejestrowane w iCloud). Bot PID 11962 aktywny. Obsidian na laptopie + iPhone widzi skany.
- **2026-10-11** - Sesja 09:30-10:05 (zgoda użytkownika na naprawę skryptu). **Naprawa `daily-scan.sh`:** opencode v2.0.26 nie obsługuje już flagi `--dir` (skrypt wypisywał usage i kończył bez skanu). Usunięto `--dir "$PROJECT_DIR"` (cwd ustawiany przez `cd`), dodano `--auto` dla pracy bezobsługowej. Model `opencode-go/deepseek-v4-flash` działa (błąd "Content Exists Risk" minął). Skrypt przetestowany pełnym przebiegiem - utworzył `output/2026-10-11_09-55.md` i `.ai-scan-session`.
- **Naprawa `websearch` (ten sam dzień).** Objaw: narzędzie `websearch` zwracało `Web search cancelled` przy każdym wywołaniu (`executed: false`). Przyczyna: domyślne `websearch.provider: "random"` trafiało na niedziałającego dostawcę (znany błąd opencode #54311 - brak fallbacku poza HTTP 429; pokrewne #47063, #50217, #51263). Endpoint Exa MCP (`https://mcp.exa.ai/mcp`) działa poprawnie i bez klucza. **Rozwiązanie:** w `opencode.json` ustawiono `"websearch": { "provider": "exa" }` oraz `permission.websearch: allow`. Weryfikacja: pełny przebieg skryptu zalogował 8x `Web Search via Exa`, exit=0, `=== Scan complete ===`, plik `output/2026-10-11_10-17.md` (plik usunięty później jako artefakt testowy).
- **Naprawa zapisu sesji.** `opencode session list | grep | head -1 | awk` przy `set -o pipefail` kończyło skrypt SIGPIPE-em przed zapisem `.ai-scan-session` (każdy skan tworzył nową sesję zamiast wznawiać). Zamieniono `head -1` na `awk 'NR==1{print $1}'` + `|| true` i dodano kontrolę `-s`.
- **Uwaga:** przy keyless Exa występuje sporadyczny HTTP 429 - skan radzi sobie, uzupełniając źródłami oficjalnymi.
- **Skrypt odporny na wersje opencode.** Produkcja (Mac mini) używa innej wersji opencode niż host (host: 2.0.26 bez `--dir`, Mini: wg ENVIRONMENTS.md 1.18.18 z `--dir`). Dodano wykrywanie flag przez `opencode run --help`: `--dir` i `--auto` dokładane tylko, gdy są wspierane. Na hoście wykrywa `--auto`, na Mini dołoży `--dir`. Bez tego zmiana mogła zepsuć działający skan na Mini.
- **Weryfikacja stanu produkcji:** w iCloud vault (Obsidian) są skany z **każdego dnia 5-11.10**, w tym `2026-10-11_07-00.md` - daily-scan na Mini **działa i synchronizuje**. Katalog `output/` na hoście to osobna, nieaktualizowana kopia deweloperska; brak plików w niej nie oznacza braku skanów.
- **Pull na Mini wykonany i zweryfikowany (2026-10-11):** `ssh-aiag` → `~/projects/ai-news-assistant`, HEAD `cbf1938`, working tree czysty. Mini ma opencode **1.18.34** (1.x), wykryte flagi `--dir --auto` (oba wspierane) - skrypt adaptacyjny poda oba. Test `opencode run --dir ... --auto` zwrócił `OK`, więc nowy klucz `websearch.provider` nie psuje konfiguracji na 1.x (jest ignorowany; V1 ma websearch natywnie). `.ai-scan-session` na Mini istnieje (z 26.08) - sesja wznawiana, zgodnie z decyzją użytkownika pozostawiona.
- **2026-10-17** - Sesja 21:15-21:40. Diagnoza braku skanów z 15/16/17.10: `scan.log` miał tylko nagłówki, `scan.err` kończył się 3× `UnknownError: Unexpected server error` (`err_bd55702f`, `err_96411cf5`, `err_d1c0aeea`), w bazie ostatnia wiadomość `assistant` z 14.10 21:29, a wiadomości `user` z każdego 07:00 bez odpowiedzi. Przyczyny (potwierdzone reprodukcją na Mini): (a) `opencode-go/deepseek-v4-flash` wycofany z katalogu providera, (b) wygasły klucz API `opencode-go`. Naprawa: nowy klucz wstawiony przez użytkownika (`opencode auth list` → `OpenCode Go · api`; test `deepseek-v4.1-flash` → `OK`, `websearch` działa), model zaktualizowany w `daily-scan.sh` i `opencode.json` (commit `382e173`, pull na Mini), sesja scanu odświeżona (`FRESH_SESSION=true`), 6 jednorazowych sesji diagnostycznych usuniętych przez `opencode session delete`. Weryfikacja end-to-end: `output/2026-10-17_21-35.md` (25,7 kB, 156 linii, `EXIT=0`), bridge `mna` przeniósł plik do vaultu o 21:38, plik widoczny w vaultcie na laptopie. Bot: launchd PID 591, gateway wznawia sesje; WiFi nadal gubi połączenie (watchdog restartował 13/14/17.10).
- **2026-10-17** - Obserwacja do ewentualnej korekty promptu (bez wpływu na działanie): nowa notatka ma nagłówek `# Daily AI Scan - 17 października 2026 (21:35)` (data słownie) zamiast `# Daily AI Scan - 2026-10-17`, a frontmatter kolejność `title, date, source, tags` - wymagane pola (`date`, `source`, `tags: [ai, agents, sap, daily]`) są obecne.
- **2026-10-17** - Sesja 21:45-22:00. **Hermes (drugi agent na Mini) miał tę samą przyczynę awarii**: proces żywy (launchd `com.hermes.gateway`, PID 587, `runs=1`, never exited), Telegram polling zdrowy, ale każde wywołanie LLM zwracało `401 api_key_expired` (pierwsze o 20:52:02, 9 wystąpień, 3× `Transient agent failure`). Hermes używa własnej kopii klucza: `OPENCODE_GO_API_KEY` w `~/projects/hermes/.hermes/.env` (67 znaków, fingerprint `3ce4e23043a4`) vs nowy klucz w `~/.local/share/opencode/auth.json` (51 znaków, `7f3c662317e6`). Naprawa: podmiana `OPENCODE_GO_API_KEY` w `.env` (odczyt z lokalnego `auth.json`, klucz nigdy nie wypisany - weryfikacja po fingerprintcie), backup `.env.bak-20261017_214650` (zawiera tylko wygasły klucz), `config.yaml`: `model.default` `deepseek-v4-flash` → `deepseek-v4.1-flash` (backup `config.yaml.bak-20261017_214715`), `hermes auth reset opencode-go` (wyczyszczenie `last_status: exhausted` / `last_error_code: 401`), restart gateway. Weryfikacja: `hermes -z "Reply with exactly: OK"` → `OK`; na Telegramie odpowiedzi 1818 i 315 znaków (`api_calls=1`, 0× 401). Skan wycieku: nowy klucz wyłącznie w `.env` (0 trafień w logach, `state.db` 57 MB, cache i packach repo). Sprzątnięte: proces-sierota po `hermes gateway restart` (double-run) - został jeden proces pod `KeepAlive` (PID 12734, trzyma `gateway.lock` + lock Telegrama).

- **2026-10-17** - Sesja 22:05-22:20. **Sprzątanie po naprawach** (zgoda użytkownika): usunięte `hermes/.hermes/.env.bak-20261017_214650` (pełny duplikat sekretów + wygasły klucz; `shasum` potwierdził różnicę względem żywego `.env`), usunięta testowa sesja Hermesa `20261017_214841_0eb424` (`Reply with exactly: OK`) przez `hermes sessions delete --yes`, wcześniej 6 sesji diagnostycznych opencode. Zostawione świadomie: `config.yaml.bak-20261017_214715` (rollback bez sekretów), profil `~/.hermes` (skills 3,4 MB, `price-watches`, `SOUL.md`), katalog `cron/output/e05d833f8654` (raport z 2026-08-20 po zadaniu, którego już nie ma - 4 KB, do decyzji użytkownika). Kontrola po sprzątaniu: 1 proces gatewaya (PID 12734, launchd), ticker crona żywy (`ticker_heartbeat` 21:56), Hermes cron `borealis-scorpionfish-watch` 17.10 09:02 `ok`, `ai-information-news` ostatnio 19.09 `ok` i następny przebieg 19.10 13:10.

## Znane problemy

1. **launchd × dysk zewnętrzny (host)** - macOS blokuje launchd dostęp do `/Volumes/DevWork/`. Nie dotyczy Mini (repo w `~/projects/`, daemony w `/Library/LaunchDaemons/`). Rozwiązanie dla hosta: przenieść na `~/Projects/`
2. **DuckDuckGo API** - nie zwraca wyników. Python fallback wymaga alternatywnego API. Główny flow używa opencode websearch - działa.
3. **Discord embed limit** - notatki >4096 znaków dzielone na 2 embedy. Nie do ominięcia (limit Discord API).
4. **Mini sleep → bot disconnect** - przy uśpieniu Mini bot traci sesję Gateway. `pmset -a sleep 0` powinno zapobiegać, ale wymaga monitorowania.
5. ~~Bot restart po resecie Mini~~ - **rozwiązane** (2026-09-11, potwierdzone 2026-10-17): launchd `com.ainewsassistant.bot` z `KeepAlive=true` podnosi bota automatycznie (PID 591, uptime 11 dni, konto `aiag`).
6. **WiFi Mini niestabilne** - en1 cyklicznie gubi połączenie. Watchdog: cron co minutę pinguje router, restartuje WiFi i bota w razie problemu. Skrypt: `scripts/wifi-watchdog.sh`
7. **Private Wi-Fi Address** - **wyłączone** na stałe. MAC `14:98:77:70:6c:6e`, DHCP reservation działa na `.139`.
8. **iCloud sync wymaga sesji GUI** - po restarcie Mini bez zalogowania do GUI daemon `bird` nie działa i Obsidian nie synchronizuje. Auto-login zablokowany przez FileVault ON. **Rozwiązanie:** po każdym resecie Mini zaloguj się raz przez Screen Sharing (lub zostaw Mini zawsze zalogowany w GUI).
9. **Klucz `opencode-go` ma dwóch konsumentów na Mini** - opencode CLI (`~/.local/share/opencode/auth.json`) i Hermes (`~/projects/hermes/.hermes/.env`, `OPENCODE_GO_API_KEY`). Rotacja klucza w OpenCode Console unieważnia poprzedni, więc trzeba go podmienić w **obu** miejscach. Objaw przy pominięciu: `401 api_key_expired` przy „zdrowym” procesie i braku błędów startowych (Hermes odpowiedział na Telegramie komunikatem błędu, nie treścią). Szczegóły i procedura: sekcja „Hermes (drugi agent na Mac mini)”.
