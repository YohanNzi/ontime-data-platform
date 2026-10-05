from datetime import timedelta

import pendulum
from airflow.providers.standard.operators.bash import BashOperator
from airflow.sdk import dag


@dag(
    dag_id="ingest_bts",
    schedule="@monthly",
    start_date=pendulum.datetime(2023, 1, 1, tz="UTC"),
    end_date=pendulum.datetime(2024, 12, 1, tz="UTC"),
    catchup=True,
    max_active_runs=1,
    default_args={
        "retries": 3,
        "retry_delay": timedelta(minutes=5),
    },
    tags=["bts", "ingestion"],
)
def ingest_bts():
    download = BashOperator(
        task_id="download_bts",
        cwd="/opt/ontime",
        bash_command=(
            "bash scripts/fetch_month.sh "
            "{{ data_interval_start.year }} "
            "{{ data_interval_start.month }}"
        ),
    )

    ingest = BashOperator(
        task_id="ingest_duckdb",
        cwd="/opt/ontime",
        env={"PYTHONPATH": "/opt/ontime/src"},
        append_env=True,
        bash_command=(
            '"$ONTIME_VENV/bin/python" '
            "-m ontime_data_platform.ingestion "
            "{{ data_interval_start.year }} "
            "{{ data_interval_start.month }}"
        ),
    )

    download >> ingest


ingest_bts()
