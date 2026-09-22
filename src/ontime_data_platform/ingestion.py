import csv
import dlt


CSV_PATH = "data/raw/On_Time_Reporting_Carrier_On_Time_Performance_(1987_present)_2024_1.csv"
DB_PATH = "data/warehouse/ontime.duckdb"

@dlt.resource(name="flights")
def flights():
    with open(CSV_PATH, encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            row.pop("", None)
            yield row


def main() -> None:
    pipeline = dlt.pipeline(
        pipeline_name="ontime",
        destination=dlt.destinations.duckdb(credentials=DB_PATH),
        dataset_name="raw",
    )
    info = pipeline.run(flights())
    print(info)


if __name__ == "__main__":
    main()
