# ADR 0001 — Stack v1

**Statut** : acceptée (2026-09-21), complétée le 2026-10-07

## Contexte

Construire une plateforme data de bout en bout sur des données publiques réelles (ponctualité aérienne US, BTS), pour pratiquer une stack data moderne : ingestion, modélisation, tests de qualité, orchestration, puis passage au cloud. Priorités : apprentissage > vitesse > vitrine, coût minimal.

## Décision

- **Ingestion** : dlt (Python) — incrémental, évolution de schéma, état intégrés.
- **Warehouse local** : DuckDB + Parquet — sémantique SQL analytique colonnaire, 0 € d'infra.
- **Transformation** : dbt-core 1.x (adapter `dbt-duckdb`) — standard du marché BI/data. dbt Core v2 (Rust) écarté : alpha depuis juin 2026.
- **Orchestration** : Airflow 3 (Docker Compose), transposable sur Cloud Composer (Airflow managé). Garde-fou : bascule Dagster si la lutte contre l'infra dépasse l'écriture de pipelines.
- **BI** : Power BI Desktop — standard du marché en France.
- **Palier cloud** : BigQuery — même projet dbt, second target.
- **Appoint** : Polars pour le pré-traitement CSV → Parquet.

## Explicitement hors v1

Spark (exercice borné ultérieur), Kafka (via Redpanda, ultérieur), Iceberg/lakehouse, Great Expectations (les tests dbt suffisent à cette échelle), Hadoop/Teradata (technologies en recul, pas de chemin d'apprentissage gratuit réaliste).

## Mise à jour 2026-10-07

- Palier cloud réalisé sur un **compte d'essai GCP** plutôt que le sandbox (le sandbox interdit `MERGE`/DML) : infrastructure en **Terraform** (`infra/terraform/`), chargement Parquet → Cloud Storage → BigQuery, dbt multi-cible DuckDB + BigQuery.
- Airflow exécuté sur une seule machine (état du scheduler centralisé).
