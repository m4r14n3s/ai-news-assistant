# DECISIONS — Architectural Decision Records

## ADR-0001: Multi-model orchestration

**Status:** Accepted  
**Date:** 2026-06-15  
**Context:** Potrzeba optymalizacji kosztów vs jakości — tanie modele do search, drogie do analizy.  
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
