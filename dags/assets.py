from airflow.sdk import Asset

BTS_FLIGHTS = Asset("duckdb:///opt/ontime/data/warehouse/ontime.duckdb/raw/flights")
