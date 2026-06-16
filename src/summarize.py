from __future__ import annotations

from datetime import date, datetime
from typing import Optional

from search import SearchResult

CATEGORIES = {
    "top": "🔥 Top Stories",
    "frameworks": "🧠 Agent Frameworks",
    "sap": "🏢 SAP & AI",
    "repos": "📦 Repositories & Tools",
    "research": "📄 Research & Papers",
}


def classify_category(result: SearchResult) -> str:
    text = (result.title + " " + result.snippet).lower()
    if any(k in text for k in ["framework", "langgraph", "crewai", "autogen", "sdk"]):
        return "frameworks"
    if any(k in text for k in ["sap", "btp", "joule", "successfactors"]):
        return "sap"
    if any(k in text for k in ["github", "repo", "repository", "open source"]):
        return "repos"
    if any(k in text for k in ["paper", "arxiv", "research", "study", "benchmark"]):
        return "research"
    return "top"


def generate_summary(
    results: list[SearchResult],
    scan_date: Optional[date] = None,
) -> str:
    if scan_date is None:
        scan_date = date.today()

    categorized: dict[str, list[SearchResult]] = {k: [] for k in CATEGORIES}
    for r in results:
        cat = classify_category(r)
        categorized[cat].append(r)

    lines = []
    lines.append("---")
    lines.append(f"date: {scan_date.isoformat()}")
    lines.append("source: daily-scan")
    lines.append("tags: [ai, agents, sap, daily]")
    lines.append("---")
    lines.append("")
    lines.append(f"# AI News — {scan_date.isoformat()}")
    lines.append("")

    for i, (cat_key, cat_title) in enumerate(CATEGORIES.items()):
        items = categorized[cat_key]
        if not items:
            continue
        if i > 0:
            lines.append("---")
        lines.append(f"## {cat_title}")
        lines.append("")
        for r in items[:5]:
            lines.append(f"- **[{r.title}]({r.url})**")
            lines.append(f"  - {r.snippet[:200]}...")
            lines.append("")

    lines.append("")
    lines.append("## 🔗 Źródła")
    lines.append("")
    for r in results:
        lines.append(f"- [{r.title}]({r.url})")
    lines.append("")
    lines.append("---")
    lines.append(f"*Generated: {datetime.now().strftime('%Y-%m-%d %H:%M')}*")
    lines.append(f"*Results: {len(results)} curated from search*")

    return "\n".join(lines)
