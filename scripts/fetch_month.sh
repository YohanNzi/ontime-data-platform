#!/usr/bin/env bash
# Télécharge un mois BTS (chemin PREZIP validé en M0) dans data/raw/.
# Usage: scripts/fetch_month.sh <année> <mois sans zéro>
# Exemple: scripts/fetch_month.sh 2024 1

set -euo pipefail

YEAR="${1:?usage: fetch_month.sh <année> <mois>}"
MONTH="${2:?usage: fetch_month.sh <année> <mois>}"

BASE_URL="https://transtats.bts.gov/PREZIP/On_Time_Reporting_Carrier_On_Time_Performance_1987_present_${YEAR}_${MONTH}.zip"
RAW_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/data/raw"

mkdir -p "$RAW_DIR"
ZIP_PATH="${RAW_DIR}/${YEAR}_${MONTH}.zip"

echo "Téléchargement ${YEAR}-${MONTH}..."
curl -sSf -o "$ZIP_PATH" "$BASE_URL"

echo "Extraction..."
unzip -o -q "$ZIP_PATH" -d "$RAW_DIR"

echo "OK: $ZIP_PATH + CSV extrait dans $RAW_DIR"
