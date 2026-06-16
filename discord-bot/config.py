import os

DISCORD_BOT_TOKEN: str = os.environ.get("DISCORD_BOT_TOKEN", "")
DISCORD_CHANNEL_ID: int = int(os.environ.get("DISCORD_CHANNEL_ID", "0"))
OBSIDIAN_VAULT_PATH: str = os.environ.get(
    "OBSIDIAN_VAULT_PATH",
    os.path.join(os.path.dirname(__file__), "..", "output"),
)
ALLOWED_USERS: list[int] = [
    int(uid) for uid in os.environ.get("DISCORD_ALLOWED_USERS", "").split(",") if uid
]
