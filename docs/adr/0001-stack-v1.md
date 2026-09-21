# ADR 0001 — Stack v1

**Statut** : acceptée (2026-09-21)

## Contexte

Combler un gap de compétences data engineering (Airflow, dbt, Power BI, BigQuery, Spark) identifié comme survendu sur un CV, via un projet réel plutôt qu'une correction de CV seule. Priorité : apprentissage > vitesse > vitrine, sans budget cloud.

## Décision

- **Ingestion** : dlt (Python) — incrémental, évolution de schéma, état intégrés.
- **Warehouse** : DuckDB + Parquet local — sémantique SQL analytique colonnaire, 0€/0 infra.
- **Transformation** : dbt-core 1.x (adapter `dbt-duckdb`) — standard marché BI/data. dbt Core v2 (Rust) écarté : alpha depuis juin 2026.
- **Orchestration** : Airflow 3 (Docker Compose) — le gap CV nomme "Airflow/Cloud Composer" explicitement ; Composer = Airflow managé. Garde-fou : bascule Dagster si 2 week-ends de lutte infra dépassent l'écriture de pipelines.
- **BI** : Power BI Desktop (gratuit, natif Windows) — standard marché FR.
- **Palier cloud (M5)** : BigQuery sandbox (gratuit, sans CB) — même projet dbt, second target.
- **Appoint** : Polars pour le pré-traitement CSV → Parquet.

## Explicitement hors v1

Spark (exercice borné M6), Kafka (stretch M6 via Redpanda), Iceberg/lakehouse, Great Expectations (dbt tests suffisent à cette échelle), Hadoop/Teradata/Dataflow/Kibana (retirés du CV, pas de chemin d'apprentissage gratuit réaliste en 2026).

## Détail complet

[[Projects/Dev-Perso/ontime-data-platform]] (vault Brain) — sources de données, cartographie gaps CV ↔ jalons, jalons M0→M6, risques.
