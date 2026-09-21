# OnTime Data Platform

Ponctualité aérienne US (BTS) : **dlt** (ingestion) → **DuckDB** (warehouse) → **dbt-core** (transformation) → **Airflow 3** (orchestration) → **Power BI** (restitution), avec un palier **BigQuery sandbox** en M5.

Projet d'apprentissage data engineering — voir `CLAUDE.md` pour la gouvernance (l'agent scaffold, pas la logique métier) et `SKILLS-LEDGER.md` pour les compétences réellement pratiquées.

## Validation source (M0)

Un mois BTS (janvier 2024, `On_Time_Reporting_Carrier_On_Time_Performance`) :

| Métrique | Valeur |
|---|---|
| Lignes | 547 271 |
| Colonnes | 110 |
| Taille CSV | 246,8 Mo |
| Taille Parquet | 18,0 Mo |
| Ratio compression | 13,7x |
| Temps lecture/count (DuckDB) | 0,53 s |
| Temps conversion Parquet | 2,01 s |

Chemin `PREZIP` (`transtats.bts.gov/PREZIP/...`) fonctionne directement (HTTP 200) — pas besoin du mirror de repli.

## Setup

```bash
uv sync --all-groups
just check   # ruff + pytest
```

## Jalons

Voir la note projet dans le vault Brain : `Projects/Dev-Perso/ontime-data-platform.md`.
