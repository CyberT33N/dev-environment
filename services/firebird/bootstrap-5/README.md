# Firebird 5 bootstrap assets

This directory contains the versioned bootstrap input for a fresh Firebird 5 checkout.

## What belongs here

- `etc/`: selected config files copied from `firebirdsql/firebird:5.0.3`
- `etc/firebird.conf`: adjusted to mirror the observed practice-side Firebird 5 network settings

## What does not belong here

- `data/*.fdb`: runtime database files
- `security5.fdb`: runtime security database managed by the official image under `/opt/firebird`
- `log/*`: runtime logs
- ad-hoc backups or machine-specific snapshots from `tmp/`

## Current policy

The repository versions the Firebird 5 config files that are mounted back into `/opt/firebird` at runtime. The shared one-shot bootstrap logic still seeds the host-side `etc` directory via `services/firebird/bootstrap/init.sh`, but the Firebird 5 image keeps its persistent database files under `/var/lib/firebird/data`.
