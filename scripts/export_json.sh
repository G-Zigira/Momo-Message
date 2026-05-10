#!/usr/bin/env bash
set -e
echo "Exporting dashboard JSON from database..."
python etl/run.py --export-only
echo "Exported to data/processed/dashboard.json"
