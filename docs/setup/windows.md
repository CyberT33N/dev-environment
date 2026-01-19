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

## Start services

Windows (using start.ps1):
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
