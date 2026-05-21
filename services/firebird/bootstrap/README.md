# Firebird bootstrap assets

This directory contains the versioned bootstrap input for a fresh Firebird 2.5.8 checkout.

## What belongs here

- `etc/`: static skeleton files copied from `jacobalberty/firebird:2.5.8-ss`
- `init.sh`: one-shot bootstrap script used by the `firebird-init` Compose service

## What does not belong here

- `data/*.fdb`: runtime database files
- `system/security2.fdb`: generated security database
- `log/*`: runtime logs
- ad-hoc backups or machine-specific snapshots from `tmp/`

## Current policy

The repository versions only the canonical `etc` skeleton for the default Firebird 2.5.8 runtime. It does not currently version a Firebird restore artifact or sample database. A future restore flow should live under `services/firebird/bootstrap/restore/` instead of `tmp/`.
