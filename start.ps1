# ==================== DOCKER SERVICE MANAGER ====================
# PowerShell-Skript zum Verwalten von Docker-Containern aus docker-compose.yml
# Beispiele zur Verwendung:

# 🔄 Alle Services starten: 
#   .\start.ps1

# 🔄 Spezifische Services starten (z.B. mongo, gitlab, gitlab-runner, firebird, mssql, postgres): 
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

# ==================== SERVICE START LOGIC ====================
# Wenn keine Services angegeben wurden, starte alle
if ([string]::IsNullOrEmpty($services)) {
    Write-Host "🔄 Starte alle Services mit docker-compose..." -ForegroundColor Cyan
    docker-compose up -d
    exit 0
}

# Verarbeite die angegebenen Services
$servicesArray = $services -split ','
foreach ($service in $servicesArray) {
    switch ($service.Trim()) {
        "mongo" {
            Write-Host "🔄 Starte MongoDB Service..." -ForegroundColor Cyan
            docker-compose up -d mongo
        }
        "gitlab" {
            Write-Host "🔄 Starte GitLab Service..." -ForegroundColor Cyan
            docker-compose up -d gitlab
        }
        "gitlab-runner" {
            Write-Host "🔄 Starte GitLab Runner Service..." -ForegroundColor Cyan
            docker-compose up -d gitlab-runner
        }
        "firebird" {
            Write-Host "🔄 Starte Firebird Service..." -ForegroundColor Cyan
            docker-compose up -d firebird
        }
        "mssql" {
            Write-Host "🔄 Starte MS SQL Server Service..." -ForegroundColor Cyan
            docker-compose up -d mssql
        }
        "postgres" {
            Write-Host "🔄 Starte PostgreSQL Service..." -ForegroundColor Cyan
            docker-compose up -d postgres
        }
        default {
            Write-Host "❌ Fehler: Unbekannter Service '$service'" -ForegroundColor Red
        }
    }
}

# ==================== OPTIONAL COMMANDS ====================
# Optional: GitLab Runner auflisten (bei Bedarf)
# docker-compose exec gitlab-runner gitlab-runner list
# docker-compose start gitlab-runner 