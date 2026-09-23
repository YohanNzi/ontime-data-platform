import csv

import dlt

CSV_PATH = "data/raw/ourairports/airports.csv"
DB_PATH = "data/warehouse/ontime.duckdb"


@dlt.resource(name="airports", write_disposition="replace")
def airports():
    with open(CSV_PATH, encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            if row["iso_country"] in ("US", "PR", "VI", "GU", "AS", "MP"):
                yield row


def main() -> None:
    pipeline = dlt.pipeline(
        pipeline_name="ontime",
        destination=dlt.destinations.duckdb(credentials=DB_PATH),
        dataset_name="raw",
    )
    info = pipeline.run(airports())
    print(info)


if __name__ == "__main__":
    main()
