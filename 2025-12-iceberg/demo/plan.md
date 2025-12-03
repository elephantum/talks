# PyIceberg Demo Plan: Clickstream Analytics

Based on the "Apache Iceberg Internals" talk plan.

## Goal
Demonstrate how Iceberg abstractions (Metadata, Snapshots, Manifests) map to real files on disk using a local filesystem catalog. We will use a synthetic clickstream dataset to show partitioning and evolution.

## Environment
- **Catalog**: Local filesystem (`tmp/warehouse`)
- **Engine**: PyIceberg + DataFusion

## Step-by-Step Walkthrough

### 1. Initialization (Init)
- **Action**: Initialize a local catalog.
- **Action**: Create a table `events` with a schema:
    - `event_time` (timestamp)
    - `user_id` (int)
    - `event_name` (string)
    - `event_properties` (string) (json encoded to string)
- **Partitioning**: Define partitioning by **Day** of `event_time`.
- **Inspection**: Look at the file system structure.
    - Check `metadata/v1.metadata.json`.
    - Verify partition spec is recorded.

### 2. Day 1: The First Ingestion
- **Action**: Generate synthetic data for **Day 1** (e.g., 2025-12-01).
- **Action**: Append the dataframe to the table.
- **Inspection**: Look at the file system structure.
    - **Data Layer**: Find the new Parquet file in `data/event_time_day=2025-12-01/`.
    - **Metadata Layer**:
        - Find `metadata/v2.metadata.json`.
        - Find the **Manifest List** (Snapshot).
        - Find the **Manifest File** tracking the file in the Day 1 partition.

### 3. Day 2: New Partition
- **Action**: Generate synthetic data for **Day 2** (e.g., 2025-12-02).
- **Action**: Append this new batch.
- **Inspection**:
    - See new folder `data/event_time_day=2025-12-02/`.
    - Check `v3.metadata.json` and how the new snapshot includes data from both days (conceptually) but adds only new files.

### 4. Time Travel
- **Action**: Query the table to show total count (Day 1 + Day 2).
- **Action**: Retrieve the history of snapshots.
- **Action**: Perform a "Time Travel" query to see the state at the end of Day 1.
- **Observation**: We only see data from 2025-12-01.

### 5. Partition Pruning
- **Action**: Run a query filtering by date: `WHERE event_time >= '2025-12-02'`.
- **Observation**: Show datafusion physical plan to show that it will not touch files from day 1 partition
- **Explanation**: Discuss how Iceberg uses the **Manifest List** to skip the entire `event_time_day=2025-12-01` partition without listing files in that directory.
