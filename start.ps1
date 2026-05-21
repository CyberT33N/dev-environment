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
#   .\start.ps1 -services "firebird" -firebirdVersion "3"
#   .\start.ps1 -services "mssql"
#   .\start.ps1 -services "postgres"

param(
    [string]$services = "",
    [string]$firebirdVersion = "2.5.8"
)

function Resolve-FirebirdVersion {
    param(
        [string]$Version
    )

    $normalizedInput = if ($null -eq $Version) { "" } else { $Version.Trim() }

    switch -Regex ($normalizedInput) {
        '^(default|2\.5|2\.5\.8|2\.5\.8-ss|v2\.5\.8|v2\.5\.8-ss)$' { return "2.5.8" }
        '^(3|3\.0|v3|v3\.0)$' { return "3" }
        default {
            throw "Unsupported Firebird version '$Version'. Supported versions: 2.5.8, 3"
        }
    }
}

$script:OriginalFirebirdHome = [Environment]::GetEnvironmentVariable("FIREBIRD_HOME")

function Resolve-FirebirdBaseHomeFromEnvironment {
    param(
        [string]$ConfiguredPath
    )

    if ([string]::IsNullOrWhiteSpace($ConfiguredPath)) {
        return (Join-Path $env:USERPROFILE "data\firebird")
    }

    $trimmedPath = $ConfiguredPath.TrimEnd('\', '/')
    $pathLeaf = Split-Path $trimmedPath -Leaf
    $v3ConfigMarker = Join-Path $trimmedPath "etc\databases.conf"

    if ($pathLeaf -eq "3" -and (Test-Path $v3ConfigMarker)) {
        return (Split-Path $trimmedPath -Parent)
    }

    return $ConfiguredPath
}

function Get-FirebirdBaseHome {
    return Resolve-FirebirdBaseHomeFromEnvironment -ConfiguredPath $script:OriginalFirebirdHome
}

function Get-FirebirdHome {
    $basePath = Get-FirebirdBaseHome
    if ($env:FIREBIRD_VERSION -eq "3") {
        return (Join-Path $basePath "3")
    }

    return $basePath
}

function Set-FirebirdRuntime {
    $env:FIREBIRD_VERSION = Resolve-FirebirdVersion -Version $firebirdVersion

    switch ($env:FIREBIRD_VERSION) {
        "3" {
            $env:FIREBIRD_SERVICE_FILE = "services/firebird/service-3.yml"
            $env:FIREBIRD_BOOTSTRAP_ETC_DIR = "./services/firebird/bootstrap-3/etc"
        }
        default {
            $env:FIREBIRD_SERVICE_FILE = "services/firebird/service.yml"
            $env:FIREBIRD_BOOTSTRAP_ETC_DIR = "./services/firebird/bootstrap/etc"
        }
    }

    $env:FIREBIRD_HOME = Get-FirebirdHome
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

function Initialize-DockerNetwork {
    $networkName = "localdev"
    $existingNetwork = docker network ls --format "{{.Name}}" | Where-Object { $_ -eq $networkName }
    if (-not $existingNetwork) {
        docker network create $networkName | Out-Null
        Write-Host "Created Docker network '$networkName'." -ForegroundColor Yellow
    }
}

# ==================== SERVICE START LOGIC ====================
# If no services were provided, start all.
Set-FirebirdRuntime

if ([string]::IsNullOrEmpty($services)) {
    Initialize-FirebirdHome | Out-Null
    Initialize-DockerNetwork
    Write-Host "Starting all services with docker-compose (Firebird $($env:FIREBIRD_VERSION))..." -ForegroundColor Cyan
    docker-compose up -d
    exit 0
}

# Process the selected services.
$servicesArray = $services -split ','
foreach ($service in $servicesArray) {
    switch ($service.Trim()) {
        "mongo" {
            Initialize-DockerNetwork
            Write-Host "Starting MongoDB service..." -ForegroundColor Cyan
            docker-compose up -d mongo
        }
        "gitlab" {
            Initialize-DockerNetwork
            Write-Host "Starting GitLab service..." -ForegroundColor Cyan
            docker-compose up -d gitlab
        }
        "gitlab-runner" {
            Initialize-DockerNetwork
            Write-Host "Starting GitLab Runner service..." -ForegroundColor Cyan
            docker-compose up -d gitlab-runner
        }
        "firebird" {
            Initialize-FirebirdHome | Out-Null
            Initialize-DockerNetwork
            Write-Host "Starting Firebird service (version $($env:FIREBIRD_VERSION))..." -ForegroundColor Cyan
            docker-compose up -d firebird
        }
        "mssql" {
            Initialize-DockerNetwork
            Write-Host "Starting MS SQL Server service..." -ForegroundColor Cyan
            # Also run the one-shot post-start config (max server memory) to avoid OOM/TCP disconnects during heavy imports.
            docker-compose up -d mssql mssql-config
        }
        "postgres" {
            Initialize-DockerNetwork
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

