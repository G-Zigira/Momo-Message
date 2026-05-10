"""
config.py — Central configuration for the MoMo ETL pipeline.
Edit paths and category keywords here; no changes needed elsewhere.
"""

import os
from pathlib import Path

# ── Paths ──────────────────────────────────────────────────────────────────
BASE_DIR = Path(__file__).resolve().parent.parent

XML_INPUT_PATH    = Path(os.getenv("XML_INPUT_PATH",    BASE_DIR / "data/raw/momo.xml"))
DATABASE_URL      = os.getenv("DATABASE_URL",            f"sqlite:///{BASE_DIR / 'data/db.sqlite3'}")
DASHBOARD_JSON    = Path(os.getenv("DASHBOARD_JSON_PATH", BASE_DIR / "data/processed/dashboard.json"))
ETL_LOG_PATH      = BASE_DIR / "data/logs/etl.log"
DEAD_LETTER_DIR   = BASE_DIR / "data/logs/dead_letter"

# ── Transaction category keywords ─────────────────────────────────────────
# Each key is a category name; the list contains substrings to match (case-insensitive).
CATEGORY_RULES: dict[str, list[str]] = {
    "incoming_money":  ["received", "you have received", "incoming"],
    "payment":         ["payment", "paid to", "merchant", "shop"],
    "transfer":        ["transferred", "sent to", "transfer to"],
    "bank_deposit":    ["bank deposit", "deposited from bank", "bank transfer"],
    "withdrawal":      ["withdrawn", "cash out", "agent withdrawal"],
    "airtime":         ["airtime", "top up", "recharge"],
}
FALLBACK_CATEGORY = "unknown"

# ── Normalization ──────────────────────────────────────────────────────────
PHONE_COUNTRY_CODE = "+250"     # Rwanda default — prepend if number starts with 07x
CURRENCY           = "RWF"
