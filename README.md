# Start
1. Run `sudo gedit /etc/hosts` and add `127.0.0.1 gitlab.local.com`

2. If you run this for the first time run `docker network create localdev`. 

3. Then `bash start.sh`

```shell
# sudo bash .start.sh # Startet alle Services
# sudo bash ./start.sh --service=mongo     # Startet nur den `mongo` Service
# sudo bash ./start.sh --service=mongo,gitlab   # Startet `mongo` und `gitlab` Services
# sudo bash ./start.sh --service=gitlab-runner    # Startet nur den `gitlab-runner` Service
```

4. Change root password for gitlab
```shell
sudo docker exec -it gitlab bash
gitlab-rake "gitlab:password:reset[root]"
```






<br><br>

## Register Gitlab Runner
- Maybe not needed
```
## ------------------------------------------------------- ##

#echo 'register gitlab-runner..'
#sudo docker-compose exec gitlab-runner gitlab-runner register \
#--non-interactive \
#--url http://gitlab.local.com/ \
#--tag-list "test" \
#--registration-token xxxxxxxxxxxxx \
#--executor docker \
#--docker-image node:18.2.0 \
#--docker-network-mode localdev

# Alternative you can use the interactive mode:
# sudo docker-compose exec gitlab-runner gitlab-runner register

## ------------------------------------------------------- ##
```









<br><br>
<br><br>
______________________________________________
______________________________________________

<br><br>
<br><br>

# URL's

<br><br>

## MongoDB
- mongodb://test:test@localhost:27017/?authSource=admin&readPreference=primary&appname=MongoDB%20Compass&directConnection=true&ssl=false

<br><br>

## Gitlab
- https://gitlab.local.com
- http://10.0.1.2










<br><br>
<br><br>
______________________________________________
______________________________________________

<br><br>
<br><br>

# Useful Docker commands

<br><br>

## Show active container
```
sudo docker logs mongo
sudo docker logs gitlab
sudo docker logs gitlab-runner
```
















<br><br>
<br><br>
______________________________________________
______________________________________________

<br><br>
<br><br>


#  Troubleshooting

<br><br>

## Gitlab

<br><br>

### Reset Password
```bash
sudo docker exec -it gitlab bash
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