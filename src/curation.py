from __future__ import annotations

from search import SearchResult


RELEVANCE_KEYWORDS = [
    "agent", "multi-agent", "orchestration", "tool use", "function calling",
    "langgraph", "crewai", "autogen", "mcp", "model context protocol",
    "sap", "btp", "joule", "successfactors", "ai core",
    "llm", "foundation model", "rag", "retrieval augmented",
    "reasoning", "planning", "memory", "state machine",
    "enterprise", "production", "deployment",
]


def score_relevance(result: SearchResult) -> int:
    text = (result.title + " " + result.snippet).lower()
    score = 5
    for keyword in RELEVANCE_KEYWORDS:
        if keyword in text:
            score += 1
    return min(score, 10)


def curate(results: list[SearchResult], min_score: int = 6) -> list[SearchResult]:
    scored = []
    for r in results:
        r.relevance = score_relevance(r)
        if r.relevance >= min_score:
            scored.append(r)
    scored.sort(key=lambda x: x.relevance, reverse=True)
    return scored
