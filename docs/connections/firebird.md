# Firebird

## Data folder bootstrap

- Die Startskripte `start.ps1` und `start.sh` legen den Firebird-Basisordner sowie die Unterordner `data`, `system` und `etc` automatisch an.
- Der One-shot-Service `firebird-init` kopiert beim ersten Start das versionierte Firebird-`etc`-Skeleton aus `services/firebird/bootstrap/etc` in das Zielverzeichnis.
- Der Firebird-Container erzeugt anschliessend seine Runtime-Dateien selbst, insbesondere `system/security2.fdb` und `data/testdb.fdb`.
- Optional kannst du den Speicherort ueber `FIREBIRD_HOME` setzen. Ohne Override wird `~/data/firebird` verwendet.

## Verbindungsparameter

- Host: localhost
- Port: 3050
- Database/Path: /firebird/data/testdb.fdb
- SYSDBA Credentials:
  - Username: SYSDBA
  - Password: masterkey
- Test User Credentials:
  - Username: test
  - Password: test
