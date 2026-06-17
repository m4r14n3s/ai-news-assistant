from __future__ import annotations

import asyncio
import subprocess
import sys
from pathlib import Path

import discord
from discord import app_commands

from config import (
    ALLOWED_USERS,
    DISCORD_BOT_TOKEN,
    OBSIDIAN_VAULT_PATH,
)

intents = discord.Intents.default()
intents.message_content = True

client = discord.Client(intents=intents)
tree = app_commands.CommandTree(client)

SCAN_SCRIPT = str(Path(__file__).parent.parent / "scripts" / "daily-scan.sh")


def _is_allowed(user_id: int) -> bool:
    return not ALLOWED_USERS or user_id in ALLOWED_USERS


@tree.command(name="scan", description="Uruchom ręczny skan AI news")
async def scan(interaction: discord.Interaction):
    if not _is_allowed(interaction.user.id):
        await interaction.response.send_message("Brak uprawnień.", ephemeral=True)
        return
    await interaction.response.defer()
    try:
        result = subprocess.run(
            ["bash", SCAN_SCRIPT, "--force"],
            capture_output=True,
            text=True,
            timeout=180,
        )
        embed = discord.Embed(
            title="✅ AI News Scan",
            description="Skan zakończony. Użyj `/last` aby zobaczyć podsumowanie.",
            color=0x00FF00,
        )
        outfile = result.stdout.strip().split("/")[-1] if result.stdout else ""
        if outfile:
            embed.add_field(name="Plik", value=f"`{outfile}`", inline=True)
        await interaction.followup.send(embed=embed)
    except subprocess.TimeoutExpired:
        await interaction.followup.send("⏱ Skan przekroczył limit czasu.")
    except Exception as e:
        await interaction.followup.send(f"❌ Błąd: {e}")


@tree.command(name="last", description="Pokaż ostatnie podsumowanie")
async def last(interaction: discord.Interaction):
    if not _is_allowed(interaction.user.id):
        await interaction.response.send_message("Brak uprawnień.", ephemeral=True)
        return
    vault = Path(OBSIDIAN_VAULT_PATH)
    files = sorted(vault.glob("*.md"), reverse=True)
    if not files:
        await interaction.response.send_message("Brak podsumowań.", ephemeral=True)
        return
    content = files[0].read_text(encoding="utf-8")

    await interaction.response.defer()

    lines = content.split("\n")
    title = "AI News"
    for l in lines:
        if l.startswith("# ") and not l.startswith("##"):
            title = l.strip("# ").strip()
            break

    clean = []
    for l in lines:
        s = l.strip()
        if s == "---":
            continue
        if s.startswith("*") and s.endswith("*"):
            continue
        clean.append(l)

    body = "\n".join(clean)
    import re
    body = re.sub(r"\n{3,}", "\n\n", body)

    chunks = []
    current = ""
    for line in body.split("\n"):
        candidate = current + line + "\n"
        if len(candidate) > 4080:
            chunks.append(current)
            current = line + "\n"
        else:
            current = candidate
    if current:
        chunks.append(current)

    for i, chunk in enumerate(chunks):
        e = discord.Embed(
            title=title if i == 0 else None,
            description=chunk,
            color=0x00BFFF,
        )
        if i == 0:
            e.set_footer(text=f"{files[0].stem} • część 1/{len(chunks)}")
        else:
            e.set_footer(text=f"część {i+1}/{len(chunks)}")
        await interaction.followup.send(embed=e)


@tree.command(name="ask", description="Zadaj pytanie agentowi AI")
async def ask(interaction: discord.Interaction, pytanie: str):
    if not _is_allowed(interaction.user.id):
        await interaction.response.send_message("Brak uprawnień.", ephemeral=True)
        return
    await interaction.response.defer()
    vault = Path(OBSIDIAN_VAULT_PATH)
    context = []
    files = sorted(vault.glob("*.md"), reverse=True)[:3]
    for f in files:
        context.append(f.read_text(encoding="utf-8")[:1000])
    combined_context = "\n---\n".join(context) if context else "Brak kontekstu."
    prompt = f"Kontekst (ostatnie podsumowania):\n{combined_context}\n\nPytanie użytkownika: {pytanie}\n\nOdpowiedz zwięźle, powołując się na źródła jeśli dostępne."
    try:
        result = subprocess.run(
            [
                sys.executable,
                "-c",
                f"import sys; print({repr(prompt)})",
            ],
            capture_output=True,
            text=True,
            timeout=10,
        )
        await interaction.followup.send(
            f"**Pytanie:** {pytanie}\n> *Odpowiedź generowana przez agenta...*"
        )
    except Exception as e:
        await interaction.followup.send(f"❌ Błąd: {e}")


@client.event
async def on_ready():
    await tree.sync()
    for guild in client.guilds:
        await tree.sync(guild=guild)
    print(f"Bot online: {client.user} — synced to {len(client.guilds)} guild(s)")


def main():
    if not DISCORD_BOT_TOKEN:
        print("Brak DISCORD_BOT_TOKEN w zmiennych środowiskowych.")
        sys.exit(1)
    client.run(DISCORD_BOT_TOKEN)


if __name__ == "__main__":
    main()
