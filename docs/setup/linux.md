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

## Start services

Linux (using start.sh):
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
