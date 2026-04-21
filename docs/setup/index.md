# Setup

## 📋 Dependencies

### Windows

#### **Docker Desktop**
- Muss installiert werden, da docker-compose mit Docker Desktop mitgeliefert wird.

#### **Firebird Datenordner**
- Die Startskripte `start.ps1` und `start.sh` legen den Firebird-Basisordner und die Unterordner `data`, `system` und `etc` automatisch an.
- Beim ersten Start fuellt der One-shot-Service `firebird-init` das benoetigte Firebird-`etc`-Skeleton aus `services/firebird/bootstrap/etc` ein.
- Danach erstellt der Firebird-Container seine Runtime-Dateien wie `system/security2.fdb` und `data/testdb.fdb` selbst.
- Optional kannst du den Pfad ueber `FIREBIRD_HOME` vorgeben. Ohne Override wird standardmaessig `~/data/firebird` verwendet.

<br><br>

### Linux
- **Docker Engine**
- **Docker Compose**
- **Hinweis zu Firebird:** Der Firebird-Ordner muss nicht manuell angelegt oder vorbefuellt werden. Das uebernehmen die Startskripte und `firebird-init` automatisch.

<br><br>
