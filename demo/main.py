from pyiceberg.catalog import load_catalog

warehouse_path = "/tmp/warehouse"
catalog = load_catalog(
    "default",
    **{
        "type": "sql",
        "uri": f"sqlite:///{warehouse_path}/pyiceberg_catalog.db",
        "warehouse": f"file://{warehouse_path}",
    },
)

import pyarrow.parquet as pq

df = pq.read_table("tmp/yellow_tripdata_2023-01.parquet")


catalog.create_namespace("default")

table = catalog.create_table(
    "default.taxi_dataset",
    schema=df.schema,
)

table.append(df)
len(table.scan().to_arrow())
