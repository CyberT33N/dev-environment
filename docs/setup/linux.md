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
- Hinweis: `start.sh` legt den Firebird-Ordner automatisch an und setzt `FIREBIRD_HOME` fuer den Compose-Aufruf.
- Fuer Firebird fuellt der One-shot-Service `firebird-init` beim ersten Start das benoetigte `etc`-Skeleton ein.
- Die Runtime-Dateien wie `system/security2.fdb` und `data/testdb.fdb` werden danach vom Firebird-Container selbst erstellt.
- To start all services:
  ```bash
  sudo bash ./start.sh
  ```

- To start only specific services like `mongo`:
  ```bash
  sudo bash ./start.sh --services=mongo
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
