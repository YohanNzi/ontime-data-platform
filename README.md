# OnTime Data Platform

Plateforme data de bout en bout sur la **ponctualité aérienne aux États-Unis** (données publiques du Bureau of Transportation Statistics) : **13,9 millions de vols** sur 24 mois (2023-2024), ingérés, modélisés, testés, orchestrés, puis portés sur **Google Cloud (BigQuery)**.

```
BTS (CSV mensuels)                     OurAirports (référentiel aéroports)
        │                                         │
        ▼                                         ▼
  dlt : ingestion idempotente (merge sur clé) ──▶ DuckDB (local)
        ▲                                         │  dbt : raw → staging → intermediate → marts
        │                                         │        (schéma en étoile + 21 tests)
  Airflow 3 (Docker)                              │
    ingest_bts ──Asset──▶ dbt_build               ▼ export Parquet par mois
                                       Cloud Storage ──bq load──▶ BigQuery
                                       (même projet dbt, 2e cible ; infra en Terraform)
```

## Résultats mesurés

| | |
|---|---|
| Volume | **13 926 960 vols**, 24 mois, 109 colonnes brutes |
| Modèle | schéma en étoile : `fct_flights` + `dim_carrier`, `dim_airport`, `dim_date` |
| Qualité | **21 tests dbt**, mêmes résultats sur DuckDB et BigQuery (`PASS=26 WARN=1 ERROR=0`) |
| Idempotence | un mois rechargé : 547 271 lignes, **0 doublon**, total inchangé |
| Rattrapage Airflow | **24/24 mois** rejoués, **2 pannes réseau réelles absorbées** par les reprises automatiques, 0 doublon |
| Chargement BigQuery | 13,9 M de lignes en **9 s** (chargement par lots) |
| Partitionnement | requête mensuelle type : **204 Mo → 17,6 Mo lus (−91 %)** |
| Infrastructure | 8 ressources Terraform, **aucune clé de compte de service** |

Le détail de chaque compétence et de sa preuve est dans [`SKILLS-LEDGER.md`](SKILLS-LEDGER.md).

## Choix techniques

- **Ingestion idempotente** (`dlt`, `write_disposition="merge"` sur une clé composite) : rejouer un mois ne crée jamais de doublon, ce qui rend les reprises et les rattrapages sûrs.
- **Orchestration Airflow 3** (LocalExecutor) : DAG mensuel avec rattrapage historique (`catchup`), reprises sur les tâches réseau, **déclenchement de la transformation par la donnée** (Asset), **pool à une place** partagé entre DAGs (DuckDB n'accepte qu'un écrivain). Les dépendances du pipeline vivent dans un environnement Python séparé de celui d'Airflow.
- **Qualité intégrée au pipeline** : la tâche dbt échoue sur un test en erreur et passe sur un avertissement documenté (anomalie connue de la source).
- **dbt multi-cible** : le même projet tourne sur DuckDB (local) et BigQuery. Les écarts de dialecte sont traités explicitement (macro `type_double`, génération de la série de dates, convention du jour de semaine, typage strict).
- **BigQuery** : couche brute séparée (`raw`, en lecture seule pour la transformation), table de faits partitionnée par mois et clusterisée, garde-fou de coût `maximum_bytes_billed`, suivi des volumes lus via `INFORMATION_SCHEMA.JOBS`.
- **Sécurité GCP** : moindre privilège (droits limités au dataset), usurpation d'identité de compte de service au lieu de clés JSON.

Décisions détaillées : [`docs/adr/`](docs/adr/).

## Structure

```
src/ontime_data_platform/   ingestion dlt (vols par mois, référentiel aéroports)
dbt/ontime/                 modèles staging → intermediate → marts, tests, macros
dags/                       DAGs Airflow (ingest_bts, dbt_build) + Asset partagé
infra/terraform/            bucket, datasets BigQuery, compte de service, IAM
scripts/                    téléchargement des fichiers BTS
```

## Lancer le projet

Prérequis : Python 3.12 et [uv](https://docs.astral.sh/uv/), [just](https://just.systems/), Docker (pour Airflow), Terraform et gcloud (pour la partie GCP).

```bash
uv sync --all-groups
just check                                     # lint + tests

scripts/fetch_range.sh 2023 1 2024 12          # télécharge 24 mois BTS dans data/raw
uv run python -m ontime_data_platform.ingest_airports
uv run python -m ontime_data_platform.ingestion 2024 1   # ingère un mois

just dbt build                                 # dbt sur DuckDB
just dbt-bq build                              # dbt sur BigQuery (profil `bq`)
```

Airflow : copier `.env.example` en `.env`, renseigner les secrets indiqués, puis `docker compose up -d` (interface sur http://localhost:8080).

## Feuille de route

- [x] Ingestion idempotente, modèle en étoile testé, orchestration Airflow, BigQuery + Terraform
- [ ] Alerte en cas d'échec de tâche, modèles dbt incrémentaux
- [ ] Restitution Power BI
- [ ] Flux temps réel (Pub/Sub, Dataflow), Spark
