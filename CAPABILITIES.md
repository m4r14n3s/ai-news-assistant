# CAPABILITIES — Możliwości systemu

## Architektura

```
                    ┌──────────────────────────┐
                    │     opencode orchestrator │
                    │  (AGENTS.md workflow)     │
                    └─────────┬────────────────┘
                              │
            ┌─────────────────┼─────────────────┐
            ▼                 ▼                   ▼
    ┌──────────────┐  ┌──────────────┐  ┌──────────────┐
    │ Web Search   │  │ AI Models    │  │ Tools        │
    │ (websearch   │  │ (deepseek    │  │ (git, curl,  │
    │  + RSS)      │  │  + Claude    │  │  scripting)  │
    │              │  │  + Ollama)   │  │              │
    └──────┬───────┘  └──────┬───────┘  └──────┬───────┘
           │                 │                  │
           └─────────────────┼──────────────────┘
                             ▼
                    ┌──────────────────┐
                    │  Curation &      │
                    │  Summarization   │
                    │  (relevance: AI  │
                    │   agents + SAP)  │
                    └────────┬─────────┘
                             │
               ┌─────────────┼─────────────┐
               ▼             ▼             ▼
        ┌──────────┐  ┌──────────┐  ┌──────────┐
        │ Obsidian │  │ Discord  │  │ Git repo │
        │ vault    │  │ bot      │  │ (backup) │
        │ (iCloud) │  │(iPhone)  │  │          │
        └──────────┘  └──────────┘  └──────────┘
```

## Generowane / przetwarzane dane

| Typ | Format | Lokalizacja |
|-----|--------|-------------|
| Daily summary | Markdown (Obsidian) | `output/YYYY-MM-DD.md` |
| Discord push | Embed + text | Discord channel |
| Search results | JSON (temp) | `output/.cache/` |

## Konfiguracja

| Zmienna | Opis | Default |
|---------|------|---------|
| `OBSIDIAN_VAULT` | Ścieżka do vaultu Obsidian | `./vault` (symlink) |
| `DISCORD_WEBHOOK_URL` | Webhook URL do Discord | env var |
| `DISCORD_BOT_TOKEN` | Token bota Discord | env var |
| `OPENAI_API_KEY` | Klucz do OpenAI (GPT) | env var |
| `ANTHROPIC_API_KEY` | Klucz do Anthropic (Claude) | env var |

## Konwencje kodowania

- Python 3.12+, type hints, async gdzie wskazane
- Testy: pytest
- Format: black + isort
- Komunikacja: polski w promptach, angielski w kodzie
