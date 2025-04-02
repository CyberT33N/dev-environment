#!/bin/bash

# ==================== DOCKER SERVICE MANAGER ====================
# Script to manage Docker containers defined in docker-compose.yml.
# Usage examples:

# 🔄 Start all services: 
#   sudo bash ./start.sh

# 🔄 Start specific services (e.g., mongo, gitlab, gitlab-runner, firebird, mssql, postgres): 
#   sudo bash ./start.sh --services=mongo
#   sudo bash ./start.sh --services=gitlab
#   sudo bash ./start.sh --services=gitlab-runner
#   sudo bash ./start.sh --services=mongo,gitlab
#   sudo bash ./start.sh --services=firebird
#   sudo bash ./start.sh --services=mssql
#   sudo bash ./start.sh --services=postgres
#
# This script allows selective service starts using the --services flag.

# ==================== PARAMETER PARSING ====================
# Parse parameters
for arg in "$@"; do
    case $arg in
        --services=*)
            services="${arg#*=}"   # Extract services after '='
            shift                   # Move to the next argument
        ;;
        *)
            # Handle unrecognized parameters (extendable)
            echo "⚠️ Warning: Unrecognized parameter '$arg'"
        ;;
    esac
done

# ==================== SERVICE START LOGIC ====================
# If no --services flag is provided, start all services
if [ -z "$services" ]; then
    echo '🔄 Starting all services with docker-compose...'
    sudo docker-compose up -d
    exit 0
fi

# Process the provided services
IFS=',' read -ra services_array <<< "$services"  # Split the services by commas
for service in "${services_array[@]}"; do
    case $service in
        mongo)
            echo '🔄 Starting mongo service...'
            sudo docker-compose up -d mongo
        ;;
        gitlab)
            echo '🔄 Starting gitlab service...'
            sudo docker-compose up -d gitlab

            # Uncomment this section to manually run the gitlab container
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
            echo '🔄 Starting gitlab-runner service...'
            sudo docker-compose up -d gitlab-runner
        ;;
        firebird)
            echo '🔄 Starting Firebird service...'
            sudo docker-compose up -d firebird
        ;;
        mssql)
            echo '🔄 Starting MS SQL Server service...'
            sudo docker-compose up -d mssql
        ;;
        postgres)
            echo '🔄 Starting PostgreSQL service...'
            sudo docker-compose up -d postgres
        ;;
        *)
            # Handle unrecognized services
            echo "❌ Error: Unknown service '$service'"
        ;;
    esac
done

# ==================== OPTIONAL COMMANDS ====================
# Optional: List GitLab runners (if needed)
# sudo docker-compose exec gitlab-runner gitlab-runner list
# sudo docker-compose start gitlab-runner
