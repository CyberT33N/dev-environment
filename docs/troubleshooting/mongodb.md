# MongoDB

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
