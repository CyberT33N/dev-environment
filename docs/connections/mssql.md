# MSSQL

<details><summary>Click to expand..</summary>


```
# 🎯 Standard DBI-Verbindung (lokales Development)
Host:     localhost
Port:     1433  
Database: master          # Default System-DB
Username: sa              # System Administrator
Password: Test1234!       # Wie in service.yml konfiguriert
```



## **📝 MSSQL DBI-Verbindungsdaten - Enterprise-Dokumentation**

**✅ Ihre Verbindungsdaten sind KORREKT:**

```yaml
# 🎯 Standard DBI-Verbindung (lokales Development)
Host:     localhost
Port:     1433  
Database: master          # Default System-DB
Username: sa              # System Administrator
Password: Test1234!       # Wie in service.yml konfiguriert
```

### **🔧 Zusätzliche Verbindungsoptionen:**

```yaml
# Alternative Hosts (je nach Setup):
Host Alternativen:
  - localhost           # ✅ Standard (Host → Container)
  - 127.0.0.1          # ✅ IP-Adresse
  - mssql-dev           # ❌ Nur container-intern

# Erweiterte Verbindungsparameter:
Instance:     ""          # Leer (keine Named Instance)
Schema:       dbo         # Default Schema
Encryption:   Optional    # -No Flag im Healthcheck
Trust Cert:   Yes         # Für Development
```


### **🔧 Microsoft SQL Server Management Studio**

Ansicht > Objekt Explorer  > Neu > Abfrage mit aktueller Verbindung

Server Type: Datenbank-Engine
```yaml
Server Type: Datenbank-Engine
Server Name: localhost,1433
Authentifizierung: SQL Server-Authentifizierung
Username: sa              # System Administrator
Password: Test1234!       # Wie in service.yml konfiguriert

Verschlüsellung: Obligatorisch
- Check at Trust Server Zertifikat
```


### **📋 Connection String-Varianten:**

**ODBC Connection String:**
```
Driver={ODBC Driver 18 for SQL Server};Server=localhost,1433;Database=master;UID=sa;PWD=Test1234!;Encrypt=Optional;TrustServerCertificate=Yes;
```

**ADO.NET Connection String:**
```
Server=localhost,1433;Database=master;User Id=sa;Password=Test1234!;Encrypt=Optional;TrustServerCertificate=True;
```

**JDBC URL:**
```
jdbc:sqlserver://localhost:1433;database=master;user=sa;password=Test1234!;encrypt=optional;trustServerCertificate=true;
```

### **🗄️ Verfügbare Standard-Datenbanken:**

```sql
-- System-Datenbanken (immer vorhanden):
master    -- ✅ Ihre Auswahl - System-Metadaten
model     -- Template für neue DBs  
msdb      -- SQL Agent, Backups, Jobs
tempdb    -- Temporäre Objekte
```

### **🧪 Verbindungstest via Terminal:**

```powershell
# Test der Verbindung:
docker exec -it mssql-dev /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P Test1234! -No -Q "SELECT @@VERSION"
```

### **💾 Persistenz / Storage (wichtig für Windows/WSL2)**

- MSSQL verwendet standardmäßig ein **Docker-managed Named Volume** `mssql-data` statt eines Windows-Bind-Mounts.
- Hintergrund: SQL Server 2022 läuft im Container als **non-root** User `mssql` (UID **10001**) und braucht Schreibrechte auf `/var/opt/mssql`.
- Dafür gibt es einen **one-shot Init-Container** `mssql-dev-init`, der die Volume-Rechte einmalig korrekt setzt (SQL selbst läuft weiterhin non-root).

### **🧯 Troubleshooting: `Access is denied` / `HRESULT 0x80070005` beim Start**

Symptom (Logs):

```
Setup FAILED copying system data file ... to '/var/opt/mssql/data/master.mdf': 5(Access is denied.)
BootstrapSystemDataDirectories() failure (HRESULT 0x80070005)
```

Ursache:
- Fast immer ein **Permission-Problem** durch einen **Windows-Bind-Mount** nach `/var/opt/mssql/...` (z.B. Projekt liegt unter `C:\...`).

Fix:
- Stelle sicher, dass du die aktuelle Konfiguration nutzt (Named Volume + `mssql-dev-init`).
- Falls du “Altlasten” entfernen willst:

```powershell
# Stop + Cleanup (löscht auch DB-Daten im Volume!)
docker compose down -v
docker compose up -d mssql
```

</details>
