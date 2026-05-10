#!/usr/bin/env bash
set -e
echo "Running MoMo ETL pipeline..."
python etl/run.py --xml data/raw/momo.xml
echo "ETL complete. Database and dashboard.json updated."
