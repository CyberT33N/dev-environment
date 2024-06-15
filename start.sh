#!/bin/bash

# Dieses Skript startet die Docker-Container für die Services, die in der `docker-compose.yml` Datei definiert sind.
# Es kann mit dem `--services` Flag aufgerufen werden, um nur bestimmte Services zu starten.
# Beispiel:

# sudo bash .start.sh # Startet alle Services
# sudo bash ./start.sh --services=mongo     # Startet nur den `mongo` Service
# sudo bash ./start.sh --services=gitlab     # Startet nur den `gitlab` Service
# sudo bash ./start.sh --services=mongo,gitlab   # Startet `mongo` und `gitlab` Services
# sudo bash ./start.sh --services=gitlab-runner    # Startet nur den `gitlab-runner` Service


# Parameter parsen
for arg in "$@"
do
    case $arg in
        --services=*)
        services="${arg#*=}"
        shift # Nach dem Parsen des Parameters eine Position nach vorne schieben
        ;;
        *)
        # Unbekannte Parameter oder Fehlerbehandlung hier einfügen
        ;;
    esac
done

# Wenn kein --services Flag gesetzt ist, alle Services starten
if [ -z "$services" ]; then
    echo 'docker-compose up all..'
    sudo docker-compose up
    exit 0
fi

# Services verarbeiten und entsprechende Aktionen ausführen
IFS=',' read -ra services_array <<< "$services"
for service in "${services_array[@]}"
do
    case $service in
        mongo)
          echo 'docker-compose up mongo..'
          sudo docker-compose up mongo
        ;;
        gitlab)
          echo 'docker-compose up gitlab..'
          sudo docker-compose up gitlab

          # sudo docker run --detach \
          #   --hostname gitlab.local.com \
          #   --env GITLAB_OMNIBUS_CONFIG="external_url 'http://gitlab.local.com'" \
          #   --publish 443:443 --publish 80:80 --publish 22:22 \
          #   --name gitlab \
          #   --restart always \
          #   --volume $GITLAB_HOME/config:/etc/gitlab:Z \
          #   --volume $GITLAB_HOME/logs:/var/log/gitlab:Z \
          #   --volume $GITLAB_HOME/data:/var/opt/gitlab:Z \
          #   --shm-size 256m \
          #   gitlab/gitlab-ee:latest
        ;;
        gitlab-runner)
          echo 'docker-compose up gitlab-runner..'
          sudo docker-compose up gitlab-runner
        ;;
        *)
          # Fehlerbehandlung für unbekannte Services
          echo "Unbekannter Service: $service"
        ;;
    esac
done

# # Optional: Zeige die Liste der GitLab-Runner an und starte ihn
# sudo docker-compose exec gitlab-runner gitlab-runner list
# sudo docker-compose start gitlab-runner