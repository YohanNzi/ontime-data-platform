import duckdb

con = duckdb.connect("data/warehouse/ontime.duckdb")
print(con.execute("SELECT COUNT(*) FROM raw.flights").fetchone())
print(
    con.execute(
        "SELECT column_name FROM information_schema.columns "
        "WHERE table_name='flights' AND table_schema='raw'"
    ).fetchall()
)
