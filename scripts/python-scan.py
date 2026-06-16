#!/usr/bin/env python3
"""
Standalone AI news scanner - uses only stdlib.
Run: python3 scripts/python-scan.py
"""
import sys
import os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "src"))

# Load .secrets if present
secrets_path = os.path.join(os.path.dirname(__file__), "..", ".secrets")
if os.path.exists(secrets_path):
    with open(secrets_path) as f:
        for line in f:
            line = line.strip()
            if line and not line.startswith("#") and "=" in line:
                k, v = line.split("=", 1)
                os.environ.setdefault(k.strip(), v.strip())

from search import run_search, fetch_page_content
from curation import curate
from summarize import generate_summary
from distribute import distribute
from pathlib import Path

def main():
    print("=== AI News Scanner (Python) ===")
    print("Searching...")
    results = run_search()
    print(f"  Found {len(results)} raw results")

    curated = curate(results, min_score=6)
    print(f"  Curated: {len(curated)} relevant results")

    for r in curated[:3]:
        content = fetch_page_content(r.url)
        if content:
            r.snippet = content[:300]

    summary = generate_summary(curated)
    print(f"  Summary: {len(summary)} chars")

    vault = Path(os.environ.get(
        "OBSIDIAN_VAULT_PATH",
        os.path.join(os.path.dirname(__file__), "..", "output"),
    ))
    result = distribute(summary, vault_path=vault)
    print(f"  Saved to: {result['obsidian_path']}")
    if result["discord_pushed"]:
        print("  Discord: pushed successfully")
    else:
        print("  Discord: skipped (no webhook)")

    print("=== Done ===")

if __name__ == "__main__":
    main()
