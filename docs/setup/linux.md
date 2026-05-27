# Linux setup

## Hosts file

Linux:
```bash
sudo gedit /etc/hosts
```

Add:
```
127.0.0.1 gitlab.local.com
```

## Docker network

Linux:
```bash
docker network create localdev
```

Hint: `start.sh` creates the `localdev` network automatically when it is missing.

## Start services

Linux (using start.sh):
- Hinweis: `start.sh` startet Firebird standardmaessig in Version `2.5.8`.
- Mit `--firebird-version=3` wird die Firebird-3-Variante aktiviert.
- Mit `--firebird-version=5` wird die Firebird-5-Variante auf Basis von `firebirdsql/firebird:5.0.3` aktiviert.
- `start.sh` legt den Firebird-Ordner automatisch an und setzt `FIREBIRD_HOME` fuer den Compose-Aufruf.
- Fuer Firebird fuellt der One-shot-Service `firebird-init` beim ersten Start das versionsspezifische `etc`-Skeleton ein.
- Die Runtime-Dateien wie `system/security2.fdb` bzw. `system/security3.fdb` und `data/testdb.fdb` werden danach vom Firebird-Container selbst erstellt.
- Firebird `5` verwendet den offiziellen Datenpfad `/var/lib/firebird/data` und hoert im reproduktionsnahen Profil auf Port `6431`.
- Fuer Firebird `3` und `5` wird zur Versionsisolierung unterhalb von `FIREBIRD_HOME` automatisch der jeweilige Unterordner verwendet.
- To start all services:
  ```bash
  sudo bash ./start.sh
  ```

- To start only specific services like `mongo`:
  ```bash
  sudo bash ./start.sh --services=mongo
  ```

- Start Firebird 3 only:
  ```bash
  sudo bash ./start.sh --services=firebird --firebird-version=3
  ```

- Start database services with Firebird 3:
  ```bash
  sudo bash ./start.sh --services=firebird,mssql,postgres --firebird-version=3
  ```

- Start Firebird 5 only:
  ```bash
  sudo bash ./start.sh --services=firebird --firebird-version=5
  ```

- Start database services with Firebird 5:
  ```bash
  sudo bash ./start.sh --services=firebird,mssql,postgres --firebird-version=5
  ```

- Start all services with Firebird 3:
  ```bash
  sudo bash ./start.sh --firebird-version=3
  ```

- Start all services with Firebird 5:
  ```bash
  sudo bash ./start.sh --firebird-version=5
  ```

- Start `mongo` and `gitlab`:
  ```bash
  sudo bash ./start.sh --services=mongo,gitlab
  ```

## GitLab root password

Linux:
```bash
sudo docker exec -it gitlab bash
gitlab-rake "gitlab:password:reset[root]"
```
