# Windows setup

## Hosts file

Windows (Open terminal as admin):
```powershell
notepad C:\Windows\System32\drivers\etc\hosts
```

Add:
```
127.0.0.1 gitlab.local.com
```

## Docker network

Windows:
```powershell
docker network create localdev
```

Hinweis: `start.ps1` legt das Netzwerk `localdev` bei Bedarf automatisch an.

## Start services

Windows (using start.ps1):
- Hinweis: `start.ps1` startet Firebird standardmaessig in Version `2.5.8`.
- Mit `-firebirdVersion "3"` wird die Firebird-3-Variante aktiviert.
- Mit `-firebirdVersion "5"` wird die Firebird-5-Variante auf Basis von `firebirdsql/firebird:5.0.3` aktiviert.
- `start.ps1` legt den Firebird-Ordner automatisch an und setzt `FIREBIRD_HOME` fuer den Compose-Aufruf.
- Fuer Firebird fuellt der One-shot-Service `firebird-init` beim ersten Start das versionsspezifische `etc`-Skeleton ein.
- Die Runtime-Dateien wie `system/security2.fdb` bzw. `system/security3.fdb` und `data/testdb.fdb` werden danach vom Firebird-Container selbst erstellt.
- Firebird `5` verwendet den offiziellen Datenpfad `/var/lib/firebird/data` und hoert im reproduktionsnahen Profil auf Port `6431`.
- Fuer Firebird `3` und `5` wird zur Versionsisolierung unterhalb von `FIREBIRD_HOME` automatisch der jeweilige Unterordner verwendet.
- To start all services:
  ```powershell
  .\start.ps1
  ```

- To start only specific services like `mongo`:
  ```powershell
  .\start.ps1 -services "mongo"
  ```

- Start `mongo` and `gitlab`:
  ```powershell
  .\start.ps1 -services "mongo,gitlab"
  ```

- Start database services:
  ```powershell
  .\start.ps1 -services "firebird,mssql,postgres"
  ```

- Start database services with Firebird 3:
  ```powershell
  .\start.ps1 -services "firebird,mssql,postgres" -firebirdVersion "3"
  ```

- Start database services with Firebird 5:
  ```powershell
  .\start.ps1 -services "firebird,mssql,postgres" -firebirdVersion "5"
  ```

## GitLab root password

Windows:
```powershell
docker exec -it gitlab bash
gitlab-rake "gitlab:password:reset[root]"
```
