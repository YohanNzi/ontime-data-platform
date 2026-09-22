# Skills Ledger

Garde-fou anti-récidive : une compétence n'entre dans un CV que si elle a une ligne ici, avec preuve.

| Compétence | Preuve (commit/capture/volume) | Date |
|---|---|---|
| dlt — ingestion incrémentale/idempotente (`write_disposition="merge"` + `primary_key` composite) | Clé naturelle validée empiriquement sur 2 mois BTS (547 271 + 519 221 lignes, 0 doublon intra-mois, 0 collision inter-mois). Pipeline testé : 2 runs consécutifs sur le même mois → 547 271 lignes les deux fois (vs 1 094 542 avec `append`). | 2026-09-22 |
