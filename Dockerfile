# Image Airflow 3 + environnement Python séparé pour le pipeline (dlt, dbt, DuckDB).
# Pourquoi un venv séparé : les dépendances d'Airflow sont épinglées par ses "constraints" ;
# installer dbt/dlt dans le même environnement provoque des conflits de versions.
FROM apache/airflow:3.3.2-python3.12

USER root
# unzip : requis par scripts/fetch_month.sh (archives BTS)
RUN apt-get update \
    && apt-get install -y --no-install-recommends unzip \
    && rm -rf /var/lib/apt/lists/* \
    && python -m venv /opt/ontime-venv \
    && chown -R airflow:0 /opt/ontime-venv

USER airflow
COPY requirements-pipeline.txt /tmp/requirements-pipeline.txt
RUN /opt/ontime-venv/bin/pip install --no-cache-dir -r /tmp/requirements-pipeline.txt
