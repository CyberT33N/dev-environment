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
- Hinweis: `start.ps1` legt den Firebird-Ordner automatisch an und setzt `FIREBIRD_HOME` fuer den Compose-Aufruf.
- Fuer Firebird fuellt der One-shot-Service `firebird-init` beim ersten Start das benoetigte `etc`-Skeleton ein.
- Die Runtime-Dateien wie `system/security2.fdb` und `data/testdb.fdb` werden danach vom Firebird-Container selbst erstellt.
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

## GitLab root password

Windows:
```powershell
docker exec -it gitlab bash
gitlab-rake "gitlab:password:reset[root]"
```
