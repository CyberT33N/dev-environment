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
#   sudo bash ./start.sh --services=firebird --firebird-version=3
#   sudo bash ./start.sh --services=mssql
#   sudo bash ./start.sh --services=postgres

# Firebird defaults to 2.5.8. Use --firebird-version=3 to switch to Firebird 3.

DEFAULT_FIREBIRD_VERSION="2.5.8"
ORIGINAL_FIREBIRD_HOME="${FIREBIRD_HOME:-}"
firebird_version="$DEFAULT_FIREBIRD_VERSION"

resolve_firebird_base_home() {
    local configured_path="${ORIGINAL_FIREBIRD_HOME:-}"
    local trimmed_path

    if [ -z "$configured_path" ]; then
        printf '%s\n' "$HOME/data/firebird"
        return
    fi

    trimmed_path="${configured_path%/}"
    if [ "${trimmed_path##*/}" = "3" ] && [ -f "$trimmed_path/etc/databases.conf" ]; then
        printf '%s\n' "${trimmed_path%/3}"
        return
    fi

    printf '%s\n' "$configured_path"
}

resolve_firebird_home() {
    local firebird_base_home

    firebird_base_home="$(resolve_firebird_base_home)"

    case "$FIREBIRD_VERSION" in
        3)
            printf '%s\n' "$firebird_base_home/3"
        ;;
        *)
            printf '%s\n' "$firebird_base_home"
        ;;
    esac
}

normalize_firebird_version() {
    case "${1:-$DEFAULT_FIREBIRD_VERSION}" in
        default|2.5|2.5.8|2.5.8-ss|v2.5.8|v2.5.8-ss)
            printf '%s\n' "$DEFAULT_FIREBIRD_VERSION"
        ;;
        3|3.0|v3|v3.0)
            printf '%s\n' "3"
        ;;
        *)
            echo "Error: unsupported Firebird version '$1'. Supported versions: $DEFAULT_FIREBIRD_VERSION, 3" >&2
            exit 1
        ;;
    esac
}

configure_firebird_runtime() {
    FIREBIRD_VERSION="$(normalize_firebird_version "${firebird_version:-$DEFAULT_FIREBIRD_VERSION}")"

    case "$FIREBIRD_VERSION" in
        3)
            FIREBIRD_SERVICE_FILE="services/firebird/service-3.yml"
            FIREBIRD_BOOTSTRAP_ETC_DIR="./services/firebird/bootstrap-3/etc"
        ;;
        *)
            FIREBIRD_SERVICE_FILE="services/firebird/service.yml"
            FIREBIRD_BOOTSTRAP_ETC_DIR="./services/firebird/bootstrap/etc"
        ;;
    esac

    FIREBIRD_HOME="$(resolve_firebird_home)"
    export FIREBIRD_VERSION FIREBIRD_HOME FIREBIRD_SERVICE_FILE FIREBIRD_BOOTSTRAP_ETC_DIR
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
    sudo FIREBIRD_VERSION="${FIREBIRD_VERSION:-}" \
        FIREBIRD_HOME="${FIREBIRD_HOME:-}" \
        FIREBIRD_SERVICE_FILE="${FIREBIRD_SERVICE_FILE:-}" \
        FIREBIRD_BOOTSTRAP_ETC_DIR="${FIREBIRD_BOOTSTRAP_ETC_DIR:-}" \
        docker-compose "$@"
}

# ==================== PARAMETER PARSING ====================
for arg in "$@"; do
    case $arg in
        --services=*)
            services="${arg#*=}"
        ;;
        --firebird-version=*)
            firebird_version="${arg#*=}"
        ;;
        *)
            echo "Warning: unrecognized parameter '$arg'"
        ;;
    esac
done

configure_firebird_runtime

# ==================== SERVICE START LOGIC ====================
if [ -z "$services" ]; then
    initialize_firebird_home
    ensure_docker_network
    echo "Starting all services with docker-compose (Firebird ${FIREBIRD_VERSION})..."
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
            echo "Starting Firebird service (version ${FIREBIRD_VERSION})..."
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
