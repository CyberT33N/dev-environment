# MSSQL: Importing large SQL files (batching required)

## Summary

When importing a large SQL file (for example a ~125 MB dump like `journal.sql`) into SQL Server running in Docker, you can hit:

- `There is insufficient system memory in resource pool 'default' to run this query.`
- `Error: 701, Severity: 17` (often with memory diagnostics / MSR-2 output)

This is typically triggered by **one very large statement** (or a small set of extremely heavy statements) that requires a big **query memory grant** (e.g. sort/hash/index build), not by the raw file size alone.

## Recommended fix

### 1) Do NOT execute the dump as one “mega query”

If your importer reads the whole file and sends it as one big batch, SQL Server may need to compile/execute a huge statement and request a large memory grant.

### 2) Split imports into multiple batches (multi-statement)

Prefer:

- Splitting the file into **many batches**, each containing **multiple smaller statements**
- Committing progress between batches (depending on your tooling)
- Avoiding single statements that insert/create indexes for extremely large sets in one go

This reduces peak memory-grant pressure and avoids the 701 failures during import.

## Notes about this repo’s MSSQL container defaults

This repo includes a one-shot `mssql-config` service in `docker-compose.yml` that applies import-friendly defaults after the MSSQL container becomes healthy:

- Sets `max server memory (MB)` (default is moderate; can be overridden via `MSSQL_MAX_SERVER_MEMORY_MB`)
- Sets `optimize for ad hoc workloads = 1`
- Sets `MAXDOP` and `cost threshold for parallelism` to reduce parallel memory-grant spikes
- Clears plan cache once (`DBCC FREESYSTEMCACHE('SQL Plans')`, `DBCC FREEPROCCACHE`) to reduce plan-cache pressure before heavy imports

If you still see 701 errors after batching, the next step is to identify the specific statement(s) that request huge memory grants and adjust batching/statement shape accordingly.

