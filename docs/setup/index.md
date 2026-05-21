# Setup

## 📋 Dependencies

### Windows

#### **Docker Desktop**
- Muss installiert werden, da docker-compose mit Docker Desktop mitgeliefert wird.

#### **Firebird Datenordner**
- Standardmaessig starten die Startskripte Firebird `2.5.8`.
- Mit `--firebird-version=3` wird statt des Default-Service die Firebird-3-Variante aktiviert.
- Die Startskripte `start.ps1` und `start.sh` legen den Firebird-Basisordner und die Unterordner `data`, `system` und `etc` automatisch an.
- Beim ersten Start fuellt der One-shot-Service `firebird-init` das versionsspezifische Firebird-`etc`-Skeleton ein (`services/firebird/bootstrap/etc` fuer `2.5.8`, `services/firebird/bootstrap-3/etc` fuer `3`).
- Danach erstellt der Firebird-Container seine Runtime-Dateien wie `system/security2.fdb` bzw. `system/security3.fdb` und `data/testdb.fdb` selbst.
- Optional kannst du den Pfad ueber `FIREBIRD_HOME` vorgeben. Ohne Override wird standardmaessig `~/data/firebird` verwendet. Fuer Firebird `3` wird zur Versionsisolierung darunter automatisch der Unterordner `3` verwendet.

<br><br>

### Linux
- **Docker Engine**
- **Docker Compose**
- **Hinweis zu Firebird:** Der Firebird-Ordner muss nicht manuell angelegt oder vorbefuellt werden. Das uebernehmen die Startskripte und `firebird-init` automatisch.

<br><br>
