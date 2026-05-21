# Firebird 3 bootstrap assets

This directory contains the versioned bootstrap input for a fresh Firebird 3 checkout.

## What belongs here

- `etc/`: static skeleton files copied from `jacobalberty/firebird:v3`
- `etc/firebird.conf`: preconfigured for legacy-client compatibility with the existing dev setup

## What does not belong here

- `data/*.fdb`: runtime database files
- `system/security3.fdb`: generated security database
- `log/*`: runtime logs
- ad-hoc backups or machine-specific snapshots from `tmp/`

## Current policy

The repository versions only the canonical `etc` skeleton for Firebird 3. The shared one-shot bootstrap logic remains in `services/firebird/bootstrap/init.sh` and mounts this directory as its version-specific `etc` input.
