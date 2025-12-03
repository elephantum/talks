import marimo

__generated_with = "0.18.1"
app = marimo.App()


@app.cell
def _():
    import pyarrow.parquet as pq
    return (pq,)


@app.cell
def _():
    from pyiceberg.catalog import load_catalog

    warehouse_path = "tmp/warehouse"
    catalog = load_catalog(
        "default",
        **{
            "type": "sql",
            "uri": f"sqlite:///{warehouse_path}/pyiceberg_catalog.db",
            "warehouse": f"file://{warehouse_path}",
        },
    )
    return (catalog,)


@app.cell
def _(pq):
    taxi_df = pq.read_table("tmp/yellow_tripdata_2023-01.parquet")
    return (taxi_df,)


@app.cell
def _(catalog, taxi_df):
    catalog.create_namespace("default")

    table = catalog.create_table(
        "default.taxi_dataset",
        schema=taxi_df.schema,
    )

    table.append(taxi_df)
    len(table.scan().to_arrow())
    return (table,)


@app.cell
def _(table):
    table
    return


@app.cell
def _():
    return


if __name__ == "__main__":
    app.run()
