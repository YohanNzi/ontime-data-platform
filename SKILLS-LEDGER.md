# Skills Ledger

Garde-fou anti-récidive : une compétence n'entre dans un CV que si elle a une ligne ici, avec preuve.

| Compétence | Preuve (commit/capture/volume) | Date |
|---|---|---|
| dlt — ingestion incrémentale/idempotente (`write_disposition="merge"` + `primary_key` composite) | Clé naturelle validée empiriquement sur 2 mois BTS (547 271 + 519 221 lignes, 0 doublon intra-mois, 0 collision inter-mois). Pipeline testé : 2 runs consécutifs sur le même mois → 547 271 lignes les deux fois (vs 1 094 542 avec `append`). **Idempotence confirmée à l'échelle sur les 24 mois** (2023-01→2024-12) : 2 runs consécutifs sur l'intégralité du jeu → 13 926 960 lignes les deux fois. | 2026-09-22 |
| dlt — évolution de schéma absorbée sans échec | 24 mois ingérés en un run (13 926 960 lignes), colonnes `Div3-5*` changeant de type selon la densité de données mois par mois (VARCHAR sparse vs DOUBLE/BIGINT) — 0 job en échec. | 2026-09-22 |
