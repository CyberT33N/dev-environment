# Maybe usefully

<br><br>

## Gitlab

<br><br>

### Reset Password
```
sudo docker exec -it gitlab-ce bash
gitlab-rake "gitlab:password:reset[root]"
```












<br><br>
<br><br>
______________________________________________
______________________________________________

<br><br>
<br><br>

# Known problems

<br><br>

## Mongo

<br><br>

### find: '/data/db/diagnostic.data/metrics.interim': No such file or directory
- We delete the folder diagnostic.data from our mounted volume and then mongo will re-create it:
```
sudo rm -rf /srv/mongo/diagnostic.data
```

<br><br>

## gitlab.local.com is offline
- Try to run again start.sh

<br><br>

## 502 - Whoops, GitLab is taking too much time to respond
- Gitlab will take a lot of time max 5-10 minutes to fully initialise after starting the docker container.
  - In some cases it will not load does not matter how long you will wait. In my case the problem resolved itself by a fe restarts. Still not sure why it was randomly working again. However, I was editing the cpu resources for gitlab & gitlab_runner. Maybe this was the reason.