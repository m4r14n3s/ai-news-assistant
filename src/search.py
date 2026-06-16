from __future__ import annotations

import json
import re
import urllib.request
import urllib.parse
from dataclasses import dataclass, field
from typing import Optional


@dataclass
class SearchResult:
    title: str
    url: str
    snippet: str
    source: str
    relevance: int = 5


SEARCH_QUERIES = [
    "AI agents new framework 2026",
    "SAP AI Core Generative AI Hub update",
    "LangGraph CrewAI AutoGen new release",
    "MCP Model Context Protocol developments",
    "agentic AI enterprise SAP integration",
    "AI research breakthrough agents 2026",
    "trending AI repositories GitHub agents",
    "multi-agent systems latest advances",
    "AI orchestration tools 2026",
    "function calling LLM improvements",
]


def _fetch_json(url: str, params: dict) -> Optional[dict]:
    try:
        query = urllib.parse.urlencode(params)
        full_url = f"{url}?{query}"
        req = urllib.request.Request(
            full_url,
            headers={"User-Agent": "AI-News-Bot/1.0"},
        )
        with urllib.request.urlopen(req, timeout=15) as resp:
            return json.loads(resp.read().decode())
    except Exception:
        return None


def web_search(query: str, num_results: int = 5) -> list[SearchResult]:
    """Synchronously search the web using DuckDuckGo API."""
    data = _fetch_json(
        "https://api.duckduckgo.com/",
        {
            "q": query,
            "format": "json",
            "no_html": "1",
            "skip_disambig": "1",
        },
    )
    if not data:
        return []
    results = []
    for topic in data.get("RelatedTopics", [])[:num_results]:
        if "Text" in topic and "FirstURL" in topic:
            results.append(
                SearchResult(
                    title=topic.get("Text", "").split(" - ")[0],
                    url=topic.get("FirstURL", ""),
                    snippet=topic.get("Text", ""),
                    source="duckduckgo",
                )
            )
    return results


def fetch_page_content(url: str) -> Optional[str]:
    """Fetch and extract text content from a URL."""
    try:
        req = urllib.request.Request(
            url,
            headers={"User-Agent": "AI-News-Bot/1.0"},
        )
        with urllib.request.urlopen(req, timeout=15) as resp:
            text = resp.read().decode("utf-8", errors="replace")
        text = re.sub(r"<[^>]+>", " ", text)
        text = re.sub(r"\s+", " ", text).strip()
        return text[:3000]
    except Exception:
        return None


def run_search() -> list[SearchResult]:
    all_results: list[SearchResult] = []
    for query in SEARCH_QUERIES:
        results = web_search(query)
        all_results.extend(results)
    seen = set()
    unique = []
    for r in all_results:
        if r.url not in seen:
            seen.add(r.url)
            unique.append(r)
    return unique
