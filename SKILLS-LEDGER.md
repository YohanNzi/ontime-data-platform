# Skills Ledger

Garde-fou anti-récidive : une compétence n'entre dans un CV que si elle a une ligne ici, avec preuve.

| Compétence | Preuve (commit/capture/volume) | Date |
|---|---|---|
| dlt — ingestion incrémentale/idempotente (`write_disposition="merge"` + `primary_key` composite) | Clé naturelle validée empiriquement sur 2 mois BTS (547 271 + 519 221 lignes, 0 doublon intra-mois, 0 collision inter-mois). Pipeline testé : 2 runs consécutifs sur le même mois → 547 271 lignes les deux fois (vs 1 094 542 avec `append`). **Idempotence confirmée à l'échelle sur les 24 mois** (2023-01→2024-12) : 2 runs consécutifs sur l'intégralité du jeu → 13 926 960 lignes les deux fois. | 2026-09-22 |
| dlt — évolution de schéma absorbée sans échec | 24 mois ingérés en un run (13 926 960 lignes), colonnes `Div3-5*` changeant de type selon la densité de données mois par mois (VARCHAR sparse vs DOUBLE/BIGINT) — 0 job en échec. | 2026-09-22 |
| dbt — modélisation dimensionnelle (schéma en étoile) | 3 dimensions (`dim_carrier`, `dim_date`, `dim_airport`) + 1 fait (`fct_flights`, grain = flight_date+carrier_id+flight_number+origin+dest, 13 926 960 lignes). Cas réel de Slowly Changing Dimension rencontré et résolu (aéroport PBI renommé DJT dans OurAirports, code historique réconcilié). | 2026-09-23 |
| dbt — tests de qualité de données (génériques + singulier) | 21 tests (`unique`/`not_null`/`relationships`/`accepted_values` + 1 test métier singulier), 20 PASS + 1 WARN documenté (anomalie source BTS connue, sévérité abaissée volontairement). | 2026-09-23 |
