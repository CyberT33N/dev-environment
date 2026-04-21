#!/bin/bash

# ==================== DOCKER SERVICE MANAGER ====================
# Script to manage Docker containers defined in docker-compose.yml.
# Usage examples:
#
# Start all services:
#   sudo bash ./start.sh
#
# Start specific services (e.g. mongo, gitlab, gitlab-runner, firebird, mssql, postgres):
#   sudo bash ./start.sh --services=mongo
#   sudo bash ./start.sh --services=gitlab
#   sudo bash ./start.sh --services=gitlab-runner
#   sudo bash ./start.sh --services=mongo,gitlab
#   sudo bash ./start.sh --services=firebird
#   sudo bash ./start.sh --services=mssql
#   sudo bash ./start.sh --services=postgres

resolve_firebird_home() {
    if [ -n "${FIREBIRD_HOME:-}" ]; then
        printf '%s\n' "$FIREBIRD_HOME"
        return
    fi

    printf '%s\n' "$HOME/data/firebird"
}

initialize_firebird_home() {
    local firebird_home

    firebird_home="$(resolve_firebird_home)"
    mkdir -p "$firebird_home/data" "$firebird_home/system" "$firebird_home/etc"
    export FIREBIRD_HOME="$firebird_home"
}

ensure_docker_network() {
    if ! sudo docker network inspect localdev >/dev/null 2>&1; then
        sudo docker network create localdev >/dev/null
        echo "Created Docker network 'localdev'."
    fi
}

run_compose() {
    sudo FIREBIRD_HOME="${FIREBIRD_HOME:-}" docker-compose "$@"
}

# ==================== PARAMETER PARSING ====================
for arg in "$@"; do
    case $arg in
        --services=*)
            services="${arg#*=}"
            shift
        ;;
        *)
            echo "Warning: unrecognized parameter '$arg'"
        ;;
    esac
done

# ==================== SERVICE START LOGIC ====================
if [ -z "$services" ]; then
    initialize_firebird_home
    ensure_docker_network
    echo "Starting all services with docker-compose..."
    run_compose up -d
    exit 0
fi

IFS=',' read -ra services_array <<< "$services"
for service in "${services_array[@]}"; do
    case "$service" in
        mongo)
            ensure_docker_network
            echo "Starting mongo service..."
            run_compose up -d mongo
        ;;
        gitlab)
            ensure_docker_network
            echo "Starting gitlab service..."
            run_compose up -d gitlab
        ;;
        gitlab-runner)
            ensure_docker_network
            echo "Starting gitlab-runner service..."
            run_compose up -d gitlab-runner
        ;;
        firebird)
            initialize_firebird_home
            ensure_docker_network
            echo "Starting Firebird service..."
            run_compose up -d firebird
        ;;
        mssql)
            ensure_docker_network
            echo "Starting MS SQL Server service..."
            run_compose up -d mssql mssql-config
        ;;
        postgres)
            ensure_docker_network
            echo "Starting PostgreSQL service..."
            run_compose up -d postgres
        ;;
        *)
            echo "Error: unknown service '$service'"
        ;;
    esac
done

# ==================== OPTIONAL COMMANDS ====================
# Optional: List GitLab runners (if needed)
# sudo docker-compose exec gitlab-runner gitlab-runner list
# sudo docker-compose start gitlab-runner
