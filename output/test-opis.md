# Daily AI Scan — 2026-06-15

## Agentowe frameworki

- [CrewAI 1.9.3 dodaje natywne wsparcie dla protokołu A2A (Agent-to-Agent)](https://www.paperclipped.de/en/blog/ai-agent-framework-releases-february-2026) — LiteAgent implementuje Google A2A z auth, negocjacją transportu i transferem plików. Pierwszy framework z wbudowanym A2A.

- [OpenAI Agents SDK — aktualizacja z 15 kwietnia 2026: natywne sandboxy, MCP Tools i Codex-like workflows](https://authorityaitools.com/blog/openai-agents-sdk-april-2026-update) — Model-native harness, sandbox execution, configurable memory, AGENTS.md, i integracja z sandbox providerami (E2B, Modal, Cloudflare, Vercel).

- [Microsoft Agent Framework 1.0 GA (kwiecień 2026) — połączenie AutoGen + Semantic Kernel](https://www.morphllm.com/ai-agent-framework) — Zunifikowany SDK dla .NET i Pythona, wsparcie MCP i A2A. AutoGen (AG2) przechodzi w tryb maintenance.

- [Claude Agent SDK — oddzielny credit subskrypcyjny od 15 czerwca 2026](https://www.morphllm.com/ai-agent-framework) — Agent SDK i `claude -p` ciągną z osobnego miesięcznego limitu ($20 Pro, $100 Max), po wyczerpaniu przełączają na stawki API.

- [Google ADK 1.0 — cztery języki SDK: Python, TypeScript, Java, Go](https://www.morphllm.com/ai-agent-framework) — Agent Development Kit Google z pełnym wsparciem dla multi-agent orchestration.

- [LangGraph 1.0.8 — produkcyjne hardening, fixy streamingowe](https://www.paperclipped.de/en/blog/ai-agent-framework-releases-february-2026) — Time-travel debugging, checkpointing, human-in-the-loop. Dominujący framework w produkcji (47M+ PyPI downloads).

## MCP — Model Context Protocol

- [MCP 2026 Roadmap: transport scalability, server discovery, enterprise auth, long-running tasks](https://a2a-mcp.org/blog/mcp-2026-roadmap) — Cztery priorytety transformujące MCP w produkcyjny standard łączności agentów. Streamable HTTP, OAuth 2.1, sesje.

- [MCP przekazany do Linux Foundation (Agentic AI Foundation) — grudzień 2025](https://openclaw.direct/mcp-guide/model-context-protocol-news) — Wielo-vendorowe zarządzanie (Anthropic, OpenAI, Block). Ponad 19,000 serwerów MCP w rejestrze Glama, wzrost o 873% r/r.

- [MCP jako "USB-C for AI" — przyjęty przez wszystkie główne frameworki i providerów modeli](https://explore.n1n.ai/blog/mcp-tools-2026-model-context-protocol-guide-2026-05-12) — LangChain, CrewAI, LangGraph, LlamaIndex mają MCP jako domyślny protokół. 97M+ SDK downloads.

## SAP AI

- [SAP Sapphire 2026 — Autonomous Enterprise: 224 AI agentów i 51 Joule Assistants](https://enterprisedna.co/resources/news/sap-sapphire-2026-autonomous-enterprise-joule-agents/) — SAP ogłasza transformację z software company w business AI company. Ponad 200 wyspecjalizowanych agentów w Finance, Supply Chain, HR, CX.

- [Anthropic Claude jako primary reasoning model w SAP](https://enterprisedna.co/resources/news/sap-sapphire-2026-autonomous-enterprise-joule-agents/) — Claude embedded w SAP AI-enabled solution portfolio. NVIDIA dostarcza secure agent runtime.

- [Joule Studio 2.0 — agent factory dla klientów i partnerów](https://erp.today/will-sap-be-a-software-company-in-the-future-sapphire-2026-keynote-maps-saps-new-erp-stack/) — Projektowanie i budowa agentów dla konkretnych procesów biznesowych. First-wave dostępny od czerwca 2026.

- [SAP AI Agent Hub — governance, discovery i inventory agentów](https://clarkstonconsulting.com/insights/2026-sapphire-takeaways) — Centralne zarządzanie agentami AI w całym enterprise. SOX audit compatibility, ISO-certified process.

- [SAP Generative AI Hub: rozszerzanie Joule o custom skills i AI agents](https://community.sap.com/t5/artificial-intelligence-blogs-posts/sap-generative-ai-hub-extending-joule-with-custom-skills-amp-ai-agents-part/ba-p/14354559) — Przewodnik krok po kroku: od BTP, przez AI Core, CAP service, po Joule Skill Builder i Agent Builder.

- [Wdrożenia produkcyjne: automatyzacja close finansowego u wielu enterprise, autonomous sourcing u Novartis](https://sapinsider.org/blogs/sap-sapphire-2026-autonomous-enterprise-ai-agents) — Dowody ROI nie są już hipotetyczne. RISE with SAP obejmuje kontraktowe zobowiązanie aktywacji 3 Joule assistants w Year 1.

## Trendy i badania

- [80% aplikacji enterprise wysłanych w Q1 2026 zawiera co najmniej jednego AI agenta](https://lushbinary.com/blog/latest-ai-trends-2026-agentic-mcp-small-models-guide) — Gartner: 40% aplikacji będzie mieć agentów do końca 2026 (vs <5% w 2025). Rynek agentic AI: ~$12B w 2026.

- [Tylko 30% zespołów developerskich ma full governance dla AI agentów](https://aiagentsdirectory.com/news/ai-agents-news-brief-june-9-2026) — 97% firm używa AI coding tools, ale governance nie nadąża. Zero Trust i identity control stają się krytyczne.

- [SLM (Small Language Models) tną koszty inferencji](https://lushbinary.com/blog/latest-ai-trends-2026-agentic-mcp-small-models-guide) — Małe modele przejmują obciążenia agentowe, redukując koszty nawet o 80% w porównaniu do dużych modeli.

- [Google DeepMind: DiffusionGemma — 4x szybsza generacja tekstu, Gemini 3.5, Gemma 4 12B](https://deepmind.google/blog) — Czerwiec 2026: nowe modele Google z akcentem na multimodalność i szybkość.

---

## Źródła

- [Paperclipped — Release Roundup](https://www.paperclipped.de/en/blog/ai-agent-framework-releases-february-2026) — Comiesięczne podsumowanie wydań frameworków AI agentowych
- [Authority AI Tools](https://authorityaitools.com/blog/openai-agents-sdk-april-2026-update) — Portal śledzący narzędzia AI dla developerów
- [Morphllm — AI Framework Comparison](https://www.morphllm.com/ai-agent-framework) — Bieżące zestawienie 8 frameworków agentowych z datami release'ów
- [A2A-MCP.org](https://a2a-mcp.org/blog/mcp-2026-roadmap) — Oficjalny blog o protokołach A2A i MCP
- [OpenClaw Direct — MCP News](https://openclaw.direct/mcp-guide/model-context-protocol-news) — Stale aktualizowane kompendium wiedzy o MCP
- [n1n.ai — MCP Guide](https://explore.n1n.ai/blog/mcp-tools-2026-model-context-protocol-guide-2026-05-12) — Praktyczny przewodnik po MCP w 2026
- [Enterprise DNA — SAP Sapphire 2026](https://enterprisedna.co/resources/news/sap-sapphire-2026-autonomous-enterprise-joule-agents/) — Analiza ogłoszeń SAP Sapphire 2026
- [ERP Today — Sapphire Keynote](https://erp.today/will-sap-be-a-software-company-in-the-future-sapphire-2026-keynote-maps-saps-new-erp-stack/) — Relacja z keynote SAP Sapphire 2026
- [Clarkston Consulting — Sapphire Takeaways](https://clarkstonconsulting.com/insights/2026-sapphire-takeaways) — Analiza konsekwencji SAP Sapphire 2026 dla enterprise
- [SAP Community — Generative AI Hub series](https://community.sap.com/t5/artificial-intelligence-blogs-posts/sap-generative-ai-hub-extending-joule-with-custom-skills-amp-ai-agents-part/ba-p/14354559) — Seria 6 artykułów o SAP Generative AI Hub
- [SAPinsider — Sapphire 2026 Hybrid AI](https://sapinsider.org/blogs/sap-sapphire-2026-autonomous-enterprise-ai-agents) — Wgląd w hybrydowe AI dla on-premise SAP
- [Lushbinary — AI Trends 2026](https://lushbinary.com/blog/latest-ai-trends-2026-agentic-mcp-small-models-guide) — Siedem trendów AI, które faktycznie mają znaczenie w 2026
- [AI Agents Directory](https://aiagentsdirectory.com/news/ai-agents-news-brief-june-9-2026) — Codzienne briefy newsów o AI agentach
- [Google DeepMind Blog](https://deepmind.google/blog) — Oficjalny blog Google DeepMind z nowościami modelowymi
