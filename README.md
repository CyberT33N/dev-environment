# 🚀 dev-environment

This project provides a streamlined environment for managing most needed developer services locally using docker-compose. It includes custom scripts (PowerShell for Windows, Bash for Linux) to control Docker containers and a simple configuration guide to quickly get GitLab, MongoDB, and GitLab Runner up and running.

### 🛠️ Key Features:
- **Local GitLab and MongoDB:** Easily spin up GitLab and MongoDB services for development and testing.
- **Service Control:** Use the `start.sh` (Linux) or `start.ps1` (Windows) script to selectively start specific services.
- **GitLab Runner Management:** Option to register a GitLab Runner for CI/CD pipelines in non-interactive or interactive mode.
- **Cross-Platform Support:** Works on both Windows and Linux systems.

This setup is ideal for developers looking to test, build, and experiment with GitLab CI pipelines and MongoDB databases in a controlled local environment.

1. 🖥️ Open the `/etc/hosts` file and add the following line:

   Linux:
   ```bash
   sudo gedit /etc/hosts
   ```

   Windows (Open terminal as admin):
   ```powershell
   notepad C:\Windows\System32\drivers\etc\hosts
   ```

   Add:
   ```
   127.0.0.1 gitlab.local.com
   ```

2. 🛠️ If this is your first run, create the Docker network:

   Linux:
   ```bash
   docker network create localdev
   ```

   Windows:
   ```powershell
   docker network create localdev
   ```

3. 📜 Start services with the script:

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

4. 🔐 Change the root password for GitLab:

   Linux:
   ```bash
   sudo docker exec -it gitlab bash
   gitlab-rake "gitlab:password:reset[root]"
   ```

   Windows:
   ```powershell
   docker exec -it gitlab bash
   gitlab-rake "gitlab:password:reset[root]"
   ```





<br><br><br><br>

# 🌐 URLs

- MongoDB:

  ```
  mongodb://test:test@localhost:27017/?authSource=admin&readPreference=primary&appname=MongoDB%20Compass&directConnection=true&ssl=false
  ```

<br>

- PostgreSQL:

  ```
  postgresql://test:test@localhost:5432/testdb
  ```

  Verbindungsparameter für pgAdmin:
  - Host: localhost
  - Port: 5432
  - Database: testdb
  - Username: test
  - Password: test

<br>

- Firebird:
  - Create this folder:
  ```powershell
  New-Item -ItemType Directory -Path "$env:USERPROFILE\data\firebird" -Force
  ```

  Verbindungsparameter:
  - Host: localhost
  - Port: 3050
  - Database/Path: /var/lib/firebird/data/testdb.fdb
  - SYSDBA Credentials:
    - Username: SYSDBA
    - Password: masterkey
  - Test User Credentials:
    - Username: test
    - Password: test

<br>

- GitLab:

  - [https://gitlab.local.com](https://gitlab.local.com)
  - [http://10.0.1.2](http://10.0.1.2)







<br><br><br><br>

## 🏃‍♂️ Register GitLab Runner (Optional)

```bash
# Register the GitLab runner using non-interactive mode
sudo docker-compose exec gitlab-runner gitlab-runner register \
--non-interactive \
--url http://gitlab.local.com/ \
--tag-list "test" \
--registration-token xxxxxxxxxxxxx \
--executor docker \
--docker-image node:18.2.0 \
--docker-network-mode localdev

# Alternatively, use interactive mode:
sudo docker-compose exec gitlab-runner gitlab-runner register

```








<br><br><br><br>

# 🛠️ Useful Docker Commands

```bash
sudo docker logs mongo
sudo docker logs gitlab
sudo docker logs gitlab-runner
```









<br><br><br><br>

# ⚙️ Troubleshooting

## Gitlab

### 🔄 Reset GitLab Password

```bash
sudo docker exec -it gitlab bash
gitlab-rake "gitlab:password:reset[root]"
```






<br><br><br><br>

# ⚠️ Known Issues

## MongoDB

### 🐘 MongoDB: Missing Metrics Interim File

If you encounter the following error:

```
find: '/data/db/diagnostic.data/metrics.interim': No such file or directory
```

Fix by deleting the `diagnostic.data` folder from the mounted volume:

```bash
sudo rm -rf /srv/mongo/diagnostic.data
```

<br>

## GitLab

### 🚫 GitLab Offline?

- Try running the `start.sh` script again.

<br>

### 🕒 GitLab Takes Too Long to Respond (502 Error)

- GitLab can take 5-10 minutes to initialize on slow computers. In some cases, it may require multiple restarts to resolve.

- Adjust CPU resources for `gitlab` and `gitlab_runner` if the issue persists.