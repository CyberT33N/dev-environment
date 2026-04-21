# ==================== DOCKER SERVICE MANAGER ====================
# PowerShell script to manage Docker containers from docker-compose.yml
# Beispiele zur Verwendung:

# Start all services:
#   .\start.ps1

# Start specific services (e.g. mongo, gitlab, gitlab-runner, firebird, mssql, postgres):
#   .\start.ps1 -services "mongo"
#   .\start.ps1 -services "gitlab"
#   .\start.ps1 -services "gitlab-runner"
#   .\start.ps1 -services "mongo,gitlab"
#   .\start.ps1 -services "firebird"
#   .\start.ps1 -services "mssql"
#   .\start.ps1 -services "postgres"

param(
    [string]$services = ""
)

function Get-FirebirdHome {
    $configuredPath = [Environment]::GetEnvironmentVariable("FIREBIRD_HOME")
    if (-not [string]::IsNullOrWhiteSpace($configuredPath)) {
        return $configuredPath
    }

    return (Join-Path $env:USERPROFILE "data\firebird")
}

function Initialize-FirebirdHome {
    $firebirdHome = Get-FirebirdHome
    $dataPath = Join-Path $firebirdHome "data"
    $systemPath = Join-Path $firebirdHome "system"
    $etcPath = Join-Path $firebirdHome "etc"

    foreach ($path in @($firebirdHome, $dataPath, $systemPath, $etcPath)) {
        if (-not (Test-Path $path)) {
            New-Item -ItemType Directory -Path $path -Force | Out-Null
        }
    }

    $env:FIREBIRD_HOME = $firebirdHome
    return $firebirdHome
}

function Ensure-DockerNetwork {
    $networkName = "localdev"
    $existingNetwork = docker network ls --format "{{.Name}}" | Where-Object { $_ -eq $networkName }
    if (-not $existingNetwork) {
        docker network create $networkName | Out-Null
        Write-Host "Created Docker network '$networkName'." -ForegroundColor Yellow
    }
}

# ==================== SERVICE START LOGIC ====================
# If no services were provided, start all.
if ([string]::IsNullOrEmpty($services)) {
    Initialize-FirebirdHome | Out-Null
    Ensure-DockerNetwork
    Write-Host "Starting all services with docker-compose..." -ForegroundColor Cyan
    docker-compose up -d
    exit 0
}

# Process the selected services.
$servicesArray = $services -split ','
foreach ($service in $servicesArray) {
    switch ($service.Trim()) {
        "mongo" {
            Ensure-DockerNetwork
            Write-Host "Starting MongoDB service..." -ForegroundColor Cyan
            docker-compose up -d mongo
        }
        "gitlab" {
            Ensure-DockerNetwork
            Write-Host "Starting GitLab service..." -ForegroundColor Cyan
            docker-compose up -d gitlab
        }
        "gitlab-runner" {
            Ensure-DockerNetwork
            Write-Host "Starting GitLab Runner service..." -ForegroundColor Cyan
            docker-compose up -d gitlab-runner
        }
        "firebird" {
            Initialize-FirebirdHome | Out-Null
            Ensure-DockerNetwork
            Write-Host "Starting Firebird service..." -ForegroundColor Cyan
            docker-compose up -d firebird
        }
        "mssql" {
            Ensure-DockerNetwork
            Write-Host "Starting MS SQL Server service..." -ForegroundColor Cyan
            # Also run the one-shot post-start config (max server memory) to avoid OOM/TCP disconnects during heavy imports.
            docker-compose up -d mssql mssql-config
        }
        "postgres" {
            Ensure-DockerNetwork
            Write-Host "Starting PostgreSQL service..." -ForegroundColor Cyan
            docker-compose up -d postgres
        }
        default {
            Write-Host "Error: unknown service '$service'" -ForegroundColor Red
        }
    }
}

# ==================== OPTIONAL COMMANDS ====================
# Optional: GitLab Runner auflisten (bei Bedarf)
# docker-compose exec gitlab-runner gitlab-runner list
# docker-compose start gitlab-runner

