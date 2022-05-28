echo 'docker-compose down init..'
sudo docker-compose down
echo '\n\n'

echo 'docker-compose up init..'
sudo docker-compose up -d
echo '\n\n'

# echo 'register gitlab-runner..'
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

# sudo docker-compose exec gitlab-runner gitlab-runner list
# sudo docker-compose start gitlab-runner
