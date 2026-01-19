# Gitlab

### 🔄 Reset GitLab Password

```bash
sudo docker exec -it gitlab bash
gitlab-rake "gitlab:password:reset[root]"
```


<br><br>

## GitLab

### 🚫 GitLab Offline?

- Try running the `start.sh` script again.

<br>

### 🕒 GitLab Takes Too Long to Respond (502 Error)

- GitLab can take 5-10 minutes to initialize on slow computers. In some cases, it may require multiple restarts to resolve.

- Adjust CPU resources for `gitlab` and `gitlab_runner` if the issue persists.
