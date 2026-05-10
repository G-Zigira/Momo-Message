# MoMo SMS Data Analytics Dashboard

> Done by Group 404

## Team

| Name | GitHub | Role |
|------|--------|------|
| Zigira Luc Guevara | g.zigira@alustudent | Team Lead / Backend |
| Keza Laura | k.laura@alustudent.com | Data Processing |
| Ineza Henry Jayz | i.henryjay@alustudent.com| Frontend / Visualization |
| Collins Wairimu | c.wairimu@alustudent.com | Database / API |
| Denzel Ngabo | d.ngabo@alustudent.com| Etl/Testing|

---

## Project Description

This application processes raw MoMo (Mobile Money) SMS transaction data exported as XML, cleans and categorizes each transaction, stores it in a relational database, and exposes the results through an interactive web dashboard with charts and filters.

The pipeline runs fully offline: XML → Python ETL → SQLite → static JSON → browser dashboard. An optional FastAPI backend is included as a bonus layer.

---

## Architecture Diagram

> **[View the system architecture diagram here](PASTE_YOUR_DRAW_IO_OR_MIRO_LINK_HERE)**

The system has four layers:

1. **Input** — Raw `momo.xml` file placed in `data/raw/`
2. **ETL** — Python scripts parse, clean, categorize, and load data into SQLite
3. **Storage** — SQLite database + exported `dashboard.json` for the frontend
4. **Frontend** — Static HTML/CSS/JS dashboard reading from `dashboard.json`

---

## Scrum Board

> **[View the project Scrum board here](PASTE_YOUR_GITHUB_PROJECTS_OR_TRELLO_LINK_HERE)**

Board columns: **To Do** · **In Progress** · **Done**

---

## Project Structure

```
.
├── README.md                         # Setup, run, overview
├── .env.example                      # DATABASE_URL or path to SQLite
├── requirements.txt                  # Python dependencies
├── index.html                        # Dashboard entry (static)
├── web/
│   ├── styles.css                    # Dashboard styling
│   ├── chart_handler.js              # Fetch + render charts/tables
│   └── assets/                       # Images/icons (optional)
├── data/
│   ├── raw/                          # Provided XML input (git-ignored)
│   │   └── momo.xml
│   ├── processed/                    # Cleaned/derived outputs for frontend
│   │   └── dashboard.json
│   ├── db.sqlite3                    # SQLite DB file
│   └── logs/
│       ├── etl.log                   # Structured ETL logs
│       └── dead_letter/              # Unparsed/ignored XML snippets
├── etl/
│   ├── __init__.py
│   ├── config.py                     # File paths, thresholds, categories
│   ├── parse_xml.py                  # XML parsing (ElementTree/lxml)
│   ├── clean_normalize.py            # Amounts, dates, phone normalization
│   ├── categorize.py                 # Simple rules for transaction types
│   ├── load_db.py                    # Create tables + upsert to SQLite
│   └── run.py                        # CLI: parse → clean → categorize → load → export JSON
├── api/                              # Optional (bonus)
│   ├── __init__.py
│   ├── app.py                        # Minimal FastAPI with /transactions, /analytics
│   ├── db.py                         # SQLite connection helpers
│   └── schemas.py                    # Pydantic response models
├── scripts/
│   ├── run_etl.sh                    # python etl/run.py --xml data/raw/momo.xml
│   ├── export_json.sh                # Rebuild data/processed/dashboard.json
│   └── serve_frontend.sh             # python -m http.server 8000
└── tests/
    ├── test_parse_xml.py
    ├── test_clean_normalize.py
    └── test_categorize.py
```

---

## Setup & Running

### Prerequisites

- Python 3.10+
- pip

### Install dependencies

```bash
pip install -r requirements.txt
```

### Configure environment

```bash
cp .env.example .env
# Edit .env if needed (default uses SQLite at data/db.sqlite3)
```

### Place your data

```bash
# Copy the provided XML file into:
data/raw/momo.xml
```

### Run the ETL pipeline

```bash
bash scripts/run_etl.sh
# or directly:
python etl/run.py --xml data/raw/momo.xml
```

This will:
1. Parse the XML and extract all SMS records
2. Clean and normalize amounts, dates, and phone numbers
3. Categorize each transaction (incoming money, payment, transfer, etc.)
4. Load everything into `data/db.sqlite3`
5. Export aggregated data to `data/processed/dashboard.json`

### Launch the dashboard

```bash
bash scripts/serve_frontend.sh
# Then open http://localhost:8000 in your browser
```

### (Optional) Run the API

```bash
pip install fastapi uvicorn
uvicorn api.app:app --reload
# Docs at http://localhost:8000/docs
```

---

## Transaction Categories

| Category | Description |
|----------|-------------|
| `incoming_money` | Money received from another user |
| `payment` | Payment to a merchant or business |
| `transfer` | Transfer to another mobile number |
| `bank_deposit` | Deposited from a bank account |
| `withdrawal` | Withdrawn as cash |
| `airtime` | Airtime purchase |
| `unknown` | Could not be categorized |

---

## Git Conventions

- Branch naming: `feature/your-feature-name`, `fix/bug-description`
- Commit messages follow [Conventional Commits](https://www.conventionalcommits.org/): `feat:`, `fix:`, `docs:`, `chore:`
- Open a Pull Request for every feature — no direct pushes to `main`
- At least one teammate must review and approve before merging

---

## `.gitignore` recommendations

Add the following to your `.gitignore`:

```
data/raw/
data/db.sqlite3
data/logs/
.env
__pycache__/
*.pyc
.DS_Store
```

---

## License

MIT — see `LICENSE` file for details.
