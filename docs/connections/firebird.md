# Firebird

## Create data folder

```powershell
# C:\Users\<DeinBenutzername>\data\firebird
New-Item -ItemType Directory -Path "$env:USERPROFILE\data\firebird" -Force
```

## Verbindungsparameter

- Host: localhost
- Port: 3050
- Database/Path: /var/lib/firebird/data/testdb.fdb
- SYSDBA Credentials:
  - Username: SYSDBA
  - Password: masterkey
- Test User Credentials:
  - Username: test
  - Password: test
