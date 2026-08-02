"""Land one month of NYC Yellow Taxi trip data into the warehouse's `raw` schema,
completely unmodified — column names and types as published by NYC TLC.

This is the "L" in ELT: no cleaning happens here. All of the cleaning,
renaming, and type-fixing lives in the dbt staging models, in SQL, so it's
versioned and testable like the rest of the transformation logic.
"""

import io
import os

import pandas as pd
import requests
from sqlalchemy import create_engine, text

TLC_BASE_URL = "https://d37ci6vzurychx.cloudfront.net/trip-data"


def main() -> None:
    year = int(os.environ.get("TAXI_YEAR", 2024))
    month = int(os.environ.get("TAXI_MONTH", 1))

    host = os.environ.get("POSTGRES_HOST", "localhost")
    port = os.environ.get("POSTGRES_PORT", "5434")
    db = os.environ.get("POSTGRES_DB", "warehouse")
    user = os.environ.get("POSTGRES_USER", "dbt_user")
    password = os.environ.get("POSTGRES_PASSWORD", "dbt_pass")

    url = f"{TLC_BASE_URL}/yellow_tripdata_{year:04d}-{month:02d}.parquet"
    print(f"Downloading {url}")
    response = requests.get(url, timeout=120)
    response.raise_for_status()
    df = pd.read_parquet(io.BytesIO(response.content))
    print(f"Downloaded {len(df):,} rows, {len(df.columns)} columns")

    engine = create_engine(f"postgresql+psycopg2://{user}:{password}@{host}:{port}/{db}")
    with engine.begin() as conn:
        conn.execute(text("CREATE SCHEMA IF NOT EXISTS raw"))

    df.to_sql(
        "yellow_tripdata",
        engine,
        schema="raw",
        if_exists="replace",
        index=False,
        chunksize=50_000,
    )
    print(f"Loaded raw.yellow_tripdata ({len(df):,} rows) into {db} on {host}:{port}")


if __name__ == "__main__":
    main()
