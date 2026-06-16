from __future__ import annotations

import json
import os
import urllib.request
from datetime import date
from pathlib import Path
from typing import Optional

DEFAULT_VAULT = Path(__file__).parent.parent / "output"
DISCORD_WEBHOOK_URL = os.environ.get("DISCORD_WEBHOOK_URL", "")


def save_to_obsidian(
    content: str,
    scan_date: Optional[date] = None,
    vault_path: Optional[Path] = None,
) -> Path:
    if scan_date is None:
        scan_date = date.today()
    vault = vault_path or DEFAULT_VAULT
    vault.mkdir(parents=True, exist_ok=True)
    filepath = vault / f"{scan_date.isoformat()}.md"
    filepath.write_text(content, encoding="utf-8")
    return filepath


def push_to_discord(
    summary_text: str,
    webhook_url: Optional[str] = None,
) -> bool:
    url = webhook_url or DISCORD_WEBHOOK_URL
    if not url:
        return False

    lines = summary_text.split("\n")
    title = next((l for l in lines if l.startswith("# ")), "AI News Daily")
    description_lines = []
    for l in lines:
        stripped = l.strip()
        if stripped.startswith("## "):
            description_lines.append(f"\n**{stripped[3:]}**")
        elif stripped.startswith("- [") and "](" in stripped:
            description_lines.append(stripped)
        elif stripped.startswith("---"):
            continue

    payload = {
        "embeds": [
            {
                "title": title.replace("# ", ""),
                "description": "\n".join(description_lines[:30])[:4000],
                "color": 0x00BFFF,
                "footer": {"text": "AI News Assistant"},
            }
        ]
    }

    try:
        data = json.dumps(payload).encode()
        req = urllib.request.Request(
            url,
            data=data,
            headers={"Content-Type": "application/json"},
            method="POST",
        )
        with urllib.request.urlopen(req, timeout=10) as resp:
            return resp.status == 204 or resp.status == 200
    except Exception:
        return False


def distribute(
    content: str,
    scan_date: Optional[date] = None,
    vault_path: Optional[Path] = None,
    discord_webhook: Optional[str] = None,
) -> dict:
    filepath = save_to_obsidian(content, scan_date, vault_path)
    discord_ok = push_to_discord(content, discord_webhook)
    return {
        "obsidian_path": str(filepath),
        "discord_pushed": discord_ok,
    }
