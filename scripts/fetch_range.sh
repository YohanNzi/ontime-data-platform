#!/usr/bin/env bash
# Télécharge une plage de mois BTS via fetch_month.sh.
# Usage: scripts/fetch_range.sh <année_début> <mois_début> <année_fin> <mois_fin>
# Exemple: scripts/fetch_range.sh 2023 1 2024 12

set -euo pipefail

START_YEAR="${1:?usage: fetch_range.sh <année_début> <mois_début> <année_fin> <mois_fin>}"
START_MONTH="${2:?usage: fetch_range.sh <année_début> <mois_début> <année_fin> <mois_fin>}"
END_YEAR="${3:?usage: fetch_range.sh <année_début> <mois_début> <année_fin> <mois_fin>}"
END_MONTH="${4:?usage: fetch_range.sh <année_début> <mois_début> <année_fin> <mois_fin>}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

year="$START_YEAR"
month="$START_MONTH"

while [ "$year" -lt "$END_YEAR" ] || { [ "$year" -eq "$END_YEAR" ] && [ "$month" -le "$END_MONTH" ]; }; do
  echo "=== ${year}-${month} ==="
  "$SCRIPT_DIR/fetch_month.sh" "$year" "$month"

  month=$((month + 1))
  if [ "$month" -gt 12 ]; then
    month=1
    year=$((year + 1))
  fi
done

echo "Terminé : ${START_YEAR}-${START_MONTH} → ${END_YEAR}-${END_MONTH}"
