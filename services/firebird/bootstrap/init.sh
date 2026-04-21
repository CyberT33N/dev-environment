#!/bin/sh
set -eu

mkdir -p /firebird/data /firebird/system /firebird/etc

for source in /bootstrap/etc/*; do
    name="$(basename "$source")"
    target="/firebird/etc/$name"

    if [ ! -e "$target" ]; then
        cp -R "$source" "$target"
    fi
done

find /firebird/etc -maxdepth 1 -type f -exec chmod 644 {} \;
if [ -f /firebird/etc/SYSDBA.password ]; then
    chmod 666 /firebird/etc/SYSDBA.password
fi
