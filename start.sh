#!/bin/bash

echo 'docker-compose down init..'
sudo docker-compose down
echo '\n\n'

# If you get Error: find: '/data/db/diagnostic.data/metrics.interim': No such file or directory
# We delete the folder diagnostic.data from our mounted volume and then mongo will re-create it
# sudo rm -rf /srv/mongo/diagnostic.data

echo 'docker-compose up init..'
sudo docker-compose up -d
echo '\n\n'

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

sudo docker-compose exec gitlab-runner gitlab-runner list
sudo docker-compose start gitlab-runner
