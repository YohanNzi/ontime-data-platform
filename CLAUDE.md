# OnTime Data Platform

Plateforme data engineering perso : ponctualité aérienne US (BTS) — ingestion (dlt) → warehouse (DuckDB) → transformation (dbt-core) → orchestration (Airflow 3) → BI (Power BI) → palier cloud (BigQuery sandbox).

## Objectif du projet

**Apprentissage réel, pas vitrine.** Combler un gap de compétences data engineering (Airflow, dbt, Power BI, BigQuery) identifié comme survendu sur un CV. Priorité : apprentissage > vitesse > démontrabilité. Pas de deadline.

## Gouvernance agent — INVERSÉE par rapport aux autres projets perso

Sur ce projet, l'agent (Claude/Codex) **NE RÉDIGE PAS** les artefacts dont la maîtrise est l'objet de l'apprentissage :
- Modèles dbt (staging/intermediate/marts), schéma dimensionnel
- Logique des DAGs Airflow
- Tests de qualité de données (dbt tests, assertions)

**L'agent PEUT rédiger** : scaffolding (structure de repo, Dockerfiles, CI), plomberie répétitive, documentation, scripts de téléchargement/setup, debug d'environnement/infra.

Si une tâche touche à la logique métier d'un modèle dbt ou d'un DAG : proposer une alternative/un review, ne pas l'écrire à la place de Yohan.

## SKILLS-LEDGER.md

Garde-fou anti-récidive : toute compétence listée sur un CV doit avoir une ligne dans `SKILLS-LEDGER.md` avec preuve (commit, capture, volume traité, date). Ne jamais suggérer d'ajouter une compétence au CV sans cette preuve.

## Environnement

- Multi-machine assumé (WSL le soir, Mac en journée) : repo `~/dev/ontime-data-platform` en FS natif sur les deux (jamais `/mnt/c` côté WSL — problèmes mmap/cache connus sur drvfs avec DuckDB/gros fichiers).
- Python 3.12 via `uv`. Commandes : `just check` (lint + tests), `uv run <cmd>`.
- `data/` gitignoré (CSV/Parquet/DuckDB volumineux, jamais commités) — régénéré à chaque machine via `scripts/fetch_month.sh <année> <mois>` + `uv run python -m ontime_data_platform.ingestion`.

## Concision
- Réponses directes : pas de préambule de politesse, pas de reformulation de ma demande, pas de récap final non sollicité.
- Ne pas réintroduire le code ou le contexte déjà visible — montrer uniquement ce qui change (diffs, lignes concernées).
- Formatage minimal nécessaire : pas de remplissage ni de listes décoratives. Plafonner les listes à 5 éléments ; au-delà, regrouper par catégorie/priorité plutôt que tout énumérer à plat.
- Numéroter les étapes quand une réponse comporte plusieurs actions distinctes à faire (pas pour une simple liste d'infos).
- Sur une tâche qui s'étend sur plusieurs tours : rappeler l'avancement en une ligne (« 3/5 fait »), pas un récap complet — ce n'est pas un récap non sollicité, juste un repère de progression.
- Demander avant de produire de longs blocs (fichiers entiers, dumps) si un extrait suffit.
- Exception — ne jamais sacrifier la clarté sur : warnings de sécurité, opérations destructives/irréversibles, raisonnement derrière une décision technique, explication explicitement demandée, débogage qui part en spirale, ou ambiguïté réelle sur ce qui est demandé.
