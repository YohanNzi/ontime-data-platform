import csv
from pathlib import Path

import dlt

DATA_DIR = Path("data/raw")
DB_PATH = "data/warehouse/ontime.duckdb"


@dlt.resource(
    name="flights",
    write_disposition="merge",
    primary_key=(
        "FlightDate",
        "DOT_ID_Reporting_Airline",
        "Flight_Number_Reporting_Airline",
        "Origin",
        "Dest",
    ),
)
def flights():
    for csv_path in sorted(DATA_DIR.glob("*.csv")):
        with open(csv_path, encoding="utf-8") as f:
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
