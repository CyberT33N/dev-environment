# Docs

## Services

### MSSQL

#### Copy file from host to mounted container

```shell
docker cp "C:\git\test\test-mono\apps\privyou\data\dumps\pvs\z1\base\sql\without-timer\all-in-one\z1_base_2026-03-06_15_50_02.bak" mssql-dev:/var/opt/mssql/data/z1_base_2026-03-06_15_50_02.bak
```