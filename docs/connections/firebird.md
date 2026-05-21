# Firebird

## Data folder bootstrap

- Standardmaessig starten die Startskripte `start.ps1` und `start.sh` Firebird `2.5.8`.
- Mit `--firebird-version=3` wird die Firebird-3-Variante gestartet.
- Die Startskripte legen den Firebird-Basisordner sowie die Unterordner `data`, `system` und `etc` automatisch an.
- Der One-shot-Service `firebird-init` kopiert beim ersten Start das versionsspezifische Firebird-`etc`-Skeleton in das Zielverzeichnis.
- Der Firebird-Container erzeugt anschliessend seine Runtime-Dateien selbst, insbesondere `system/security2.fdb` bzw. `system/security3.fdb` und `data/testdb.fdb`.
- Optional kannst du den Speicherort ueber `FIREBIRD_HOME` setzen. Ohne Override wird `~/data/firebird` verwendet. Fuer Firebird `3` wird darunter automatisch `~/data/firebird/3` genutzt.

## Versionsauswahl

- Firebird `2.5.8` bleibt der Default.
- Firebird `3` startest du mit:
  ```bash
  sudo bash ./start.sh --services=firebird --firebird-version=3
  ```

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
