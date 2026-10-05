import argparse
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
def flights(year: int, month: int):
    csv_path = DATA_DIR / (
        f"On_Time_Reporting_Carrier_On_Time_Performance_(1987_present)_{year}_{month}.csv"
    )
    with open(csv_path, encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            row.pop("", None)
            yield row


def main() -> None:
    parser = argparse.ArgumentParser(description="Ingère un mois BTS dans DuckDB (raw.flights).")
    parser.add_argument("year", type=int)
    parser.add_argument("month", type=int, choices=range(1, 13))
    args = parser.parse_args()

    pipeline = dlt.pipeline(
        pipeline_name="ontime",
        destination=dlt.destinations.duckdb(credentials=DB_PATH),
        dataset_name="raw",
    )
    info = pipeline.run(flights(args.year, args.month))
    print(info)


if __name__ == "__main__":
    main()
