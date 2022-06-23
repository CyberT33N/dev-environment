# Known problems

<br><br>

## Mongo

### find: '/data/db/diagnostic.data/metrics.interim': No such file or directory
- We delete the folder diagnostic.data from our mounted volume and then mongo will re-create it:
```
sudo rm -rf /srv/mongo/diagnostic.data
```
