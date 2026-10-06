from airflow.providers.standard.operators.bash import BashOperator
from airflow.sdk import dag
from assets import BTS_FLIGHTS


@dag(
    dag_id="dbt_build",
    schedule=[BTS_FLIGHTS],
    catchup=False,
    max_active_runs=1,
    tags=["dbt", "transformation"],
)
def dbt_build():
    BashOperator(
        task_id="build",
        # Le chemin DuckDB dans profiles.yml est relatif à /opt/ontime.
        cwd="/opt/ontime",
        pool="duckdb_writer",
        retries=0,
        # Tout code non nul doit faire échouer la tâche.
        skip_on_exit_code=None,
        # Sans promotion des warnings en erreurs :
        # WARN seul -> code 0 ; test en échec ERROR -> code 1.
        # exec transmet directement le code de sortie de dbt à Airflow.
        # [Codes de sortie dbt](https://docs.getdbt.com/reference/exit-codes)
        # [Sévérité des tests](https://docs.getdbt.com/reference/resource-configs/severity)
        bash_command=(
            'exec "$ONTIME_VENV/bin/dbt" build '
            "--project-dir /opt/ontime/dbt/ontime "
            "--profiles-dir /opt/ontime/dbt/ontime"
        ),
    )


dbt_build()
