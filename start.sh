echo 'docker-compose down init..'
sudo docker-compose down
echo '\n\n'

echo 'docker-compose up init..'
sudo docker-compose up -d
echo '\n\n'

echo 'start gitlab-runner..'
#sudo docker-compose exec gitlab-runner gitlab-runner register
sudo docker-compose start gitlab-runner
