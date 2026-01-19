# 🏃‍♂️ Register GitLab Runner (Optional)

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

<br><br>

---

<br><br>
