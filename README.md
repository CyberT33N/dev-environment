# 🚀 dev-environment

This project provides a streamlined environment for managing most needed developer services locally using docker-compose. It includes a custom bash script to control Docker containers and a simple configuration guide to quickly get GitLab, MongoDB, and GitLab Runner up and running.

### 🛠️ Key Features:
- **Local GitLab and MongoDB:** Easily spin up GitLab and MongoDB services for development and testing.
- **Service Control:** Use the `start.sh` script to selectively start specific services (like `mongo` or `gitlab-runner`) without starting the entire stack.
- **GitLab Runner Management:** Option to register a GitLab Runner for CI/CD pipelines in non-interactive or interactive mode.

This setup is ideal for developers looking to test, build, and experiment with GitLab CI pipelines and MongoDB databases in a controlled local environment.

1. 🖥️ Open the `/etc/hosts` file and add the following line:

   ```bash
   sudo gedit /etc/hosts
   ```

   Add:

   ```
   127.0.0.1 gitlab.local.com
   ```

2. 🛠️ If this is your first run, create the Docker network:

   ```bash
   docker network create localdev
   ```

3. 📜 Start services with the `start.sh` script:

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

   - Start `gitlab-runner`:

     ```bash
     sudo bash ./start.sh --services=gitlab-runner
     ```

4. 🔐 Change the root password for GitLab:

   ```bash
   sudo docker exec -it gitlab bash
   gitlab-rake "gitlab:password:reset[root]"
   ```

---

## 🏃‍♂️ Register GitLab Runner (Optional)

```bash
## ------------------------------------------------------- ##

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

## ------------------------------------------------------- ##
```

---

# 🌐 URLs

- MongoDB:

  ```
  mongodb://test:test@localhost:27017/?authSource=admin&readPreference=primary&appname=MongoDB%20Compass&directConnection=true&ssl=false
  ```

- GitLab:

  - [https://gitlab.local.com](https://gitlab.local.com)
  - [http://10.0.1.2](http://10.0.1.2)

---

# 🛠️ Useful Docker Commands

```bash
sudo docker logs mongo
sudo docker logs gitlab
sudo docker logs gitlab-runner
```

---

# ⚙️ Troubleshooting

### 🔄 Reset GitLab Password

```bash
sudo docker exec -it gitlab bash
gitlab-rake "gitlab:password:reset[root]"
```

---

# ⚠️ Known Issues

### 🐘 MongoDB: Missing Metrics Interim File

If you encounter the following error:

```
find: '/data/db/diagnostic.data/metrics.interim': No such file or directory
```

Fix by deleting the `diagnostic.data` folder from the mounted volume:

```bash
sudo rm -rf /srv/mongo/diagnostic.data
```

### 🚫 GitLab Offline?

- Try running the `start.sh` script again.

### 🕒 GitLab Takes Too Long to Respond (502 Error)

- GitLab can take 5-10 minutes to initialize on slow computers. In some cases, it may require multiple restarts to resolve.

- Adjust CPU resources for `gitlab` and `gitlab_runner` if the issue persists.