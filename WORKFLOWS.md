# WORKFLOWS — Przepisy krok-po-kroku

## 1. daily-scan — Codzienne przeszukiwanie AI news

**Trigger:** launchd codziennie 07:00 lub ręcznie `bash scripts/daily-scan.sh`

1. **Search** — uruchom `websearch` z zapytaniami:
   - `"AI agents new framework 2026"`
   - `"SAP AI Core Generative AI Hub update"`
   - `"LangGraph CrewAI AutoGen new release"`
   - `"MCP Model Context Protocol developments"`
   - `"agentic AI enterprise SAP integration"`
   - `"AI research breakthrough agents"`
   - `"trending AI repositories GitHub agents"`
2. **Fetch** — dla każdego wyniku z `relevance > 7/10`, pobierz treść strony
3. **Curation** — LLM ocenia relevance (skala 1-5) w kontekście AI agents + SAP
4. **Summarize** — wygeneruj notatkę Obsidian z kategoriami:
   - 🔥 Top Stories
   - 🧠 Agent Frameworks
   - 🏢 SAP & AI
   - 📦 Repositories & Tools
   - 📄 Research & Papers
5. **Distribute** — zapisz do Obsidian vault + push na Discord

### Output format (Obsidian)

```markdown
---
date: 2026-06-15
source: daily-scan
tags: [ai, agents, sap, daily]
---

# AI News — 2026-06-15

## 🔥 Top Stories

- **[Tytuł tematu](link-do-najlepszego-źródła)** — krótki opis, kluczowe informacje

## 🧠 Agent Frameworks

- **[Nazwa frameworku](link-do-oficjalnej-strony/github/blog-post)** — opis, nowości, wersja

## 🏢 SAP & AI

- **[Nazwa produktu/aktualności](link-do-oficjalnego-źródła/SAP)** — opis zmiany/wdrożenia

## 📦 Repositories & Tools

- **[Nazwa repo](link-github)** — ⭐ liczba_starszek — krótki opis

## 📄 Research & Papers

- **[Tytuł paper](link-arxiv/PDF)** — autorzy, krótkie podsumowanie

## 🔗 Źródła

- [tytuł źródła 1](url-1)
- [tytuł źródła 2](url-2)
```

**WAŻNE:** Każda pozycja **MUSI** zawierać klikalny link `[tekst](url)`. Bez wyjątku. Repozytoria GitHub → link do repo. Artykuły → link do artykułu. Notki SAP → link do SAP. Źródła jako lista `- [tytuł](url)`, NIGDY jako tabelka. Żadnych `[Link]` ani `| # | Źródło | URL |`.

---

## 2. ask-agent — Zapytanie do agenta przez Discord

**Trigger:** `/ask <pytanie>` na Discord

1. Odbierz pytanie z Discorda
2. Przeszukaj lokalną bazę wiedzy (`output/`) czy już mamy odpowiedź
3. Jeśli nie — wykonaj szybki `websearch` na temat pytania
4. Wygeneruj odpowiedź z citation (link do źródła)
5. Wyślij odpowiedź na Discord (w wątku lub DM)

---

## 3. manual-scan — Ręczny skan na żądanie

**Trigger:** `/scan` na Discord lub `bash scripts/daily-scan.sh --force`

Identyczny do daily-scan, ale:
- Pomija cache
- Zawsze generuje pełne podsumowanie
- Wysyła też na Discord niezależnie od godziny

---

## 4. Git workflow

```bash
git status
git diff
git add -A
git commit -m "ai-news: YYYY-MM-DD daily scan"
git push
```

Konwencja commitów: `ai-news: krótki opis zmiany`
