# DECISIONS - Architectural Decision Records

## ADR-0001: Multi-model orchestration

**Status:** Accepted  
**Date:** 2026-06-15  
**Context:** Potrzeba optymalizacji kosztów vs jakości - tanie modele do search, drogie do analizy.  
**Decision:** opencode multi-provider config. Deepseek (free) do web search i wstępnego parsowania. Claude/GPT do curation, summarization.  
**Consequences:** Większa złożoność konfiguracji, ale optymalny balans cost/quality.

## ADR-0002: Output do Obsidian vault przez iCloud

**Status:** Accepted  
**Date:** 2026-06-15  
**Context:** Użytkownik chce mieć podsumowania dostępne na iPhone.  
**Decision:** Notatki zapisywane jako `.md` w katalogu Obsidian vault synchornizowanym przez iCloud.  
**Consequences:** Zero dodatkowej infrastruktury. Ograniczenie: iCloud musi być aktywny na Macu i iPhone.

## ADR-0003: Discord jako kanał komunikacji mobilnej

**Status:** Accepted  
**Date:** 2026-06-15  
**Context:** Potrzeba interakcji z agentem z iPhone (push + komendy).  
**Decision:** Discord bot z webhookiem do pusha i komendami slash do interakcji.  
**Consequences:** Wymaga hostowania bota (może być lokalnie lub na serwerze).

## ADR-0004: Provider credential `opencode-go` na Mac mini - jedno konto, dwóch konsumentów

**Status:** Accepted  
**Date:** 2026-10-17  
**Context:** Na Mac mini działa dwóch niezależnych klientów providera `opencode-go`: opencode CLI (skan `daily-scan.sh`, bot Discord) oraz Hermes (osobny projekt, agent z gatewayem Telegram). Każdy trzyma własną kopię klucza API: opencode CLI w `~/.local/share/opencode/auth.json`, Hermes w `~/projects/hermes/.hermes/.env`. 2026-10-17 rotacja klucza w konsoli dostawcy unieważniła poprzedni, co unieruchomiło oba systemy naraz (skany nie powstawały od 15.10, Hermes zwracał `401 api_key_expired` od 20:52) - procesy pozostały „żywe”, więc awaria była cicha.  
**Decision:** Utrzymujemy jeden klucz obsługujący oba systemy (jeden limit, jedno rozliczenie), ale rotacja jest **operacją dwumiejscową** i musi obejmować: (1) opencode CLI na Mini, (2) `OPENCODE_GO_API_KEY` w `.env` Hermesa. Weryfikacja po fingerprintcie SHA-256 (klucz nigdy nie jest wypisywany ani wysyłany do LLM), potem restart obu konsumentów i test wywołania modelu.  
**Consequences:** Mniejsza liczba sekretów do zarządzania, ale każda rotacja wymaga dwóch zmian + restartów; pominięcie jednego miejsca daje cichą awarię (`401` przy zdrowym procesie). Alternatywa (osobne klucze per system) odrzucona - wspólny limit i prostsze rozliczenie są ważniejsze niż izolacja.

