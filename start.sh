#!/bin/bash

# Dieses Skript startet die Docker-Container für die Services, die in der `docker-compose.yml` Datei definiert sind.
# Es kann mit dem `--services` Flag aufgerufen werden, um nur bestimmte Services zu starten.
# Beispiel:
# sudo bash .start.sh # Startet alle Services
# sudo bash ./start.sh --service=mongo     # Startet nur den `mongo` Service
# sudo bash ./start.sh --service=mongo,gitlab   # Startet `mongo` und `gitlab` Services
# sudo bash ./start.sh --service=gitlab-runner    # Startet nur den `gitlab-runner` Service


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
    sudo docker-compose up -d
    exit 0
fi

# Services verarbeiten und entsprechende Aktionen ausführen
IFS=',' read -ra services_array <<< "$services"
for service in "${services_array[@]}"
do
    case $service in
        mongo)
          echo 'docker-compose up mongo..'
          sudo docker-compose up -d mongo
        ;;
        gitlab)
          echo 'docker-compose up gitlab..'
          sudo docker-compose up -d gitlab
        ;;
        gitlab-runner)
          echo 'docker-compose up gitlab-runner..'
          sudo docker-compose up -d gitlab-runner
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