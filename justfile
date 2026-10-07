default: check

check: lint test

lint:
    uv run ruff check .
    uv run ruff format --check .

fmt:
    uv run ruff format .

test:
    uv run pytest

# dbt sur DuckDB local (target dev). Ex : just dbt build, just dbt run -s fct_flights
# positional-arguments + "$@" : préserve les guillemets (ex. --inline "select ...").
[positional-arguments]
dbt *args:
    uv run dbt "$@" --project-dir dbt/ontime --profiles-dir dbt/ontime --target dev

# dbt sur BigQuery (target bq). Ex : just dbt-bq build, just dbt-bq debug
[positional-arguments]
dbt-bq *args:
    uv run dbt "$@" --project-dir dbt/ontime --profiles-dir dbt/ontime --target bq
