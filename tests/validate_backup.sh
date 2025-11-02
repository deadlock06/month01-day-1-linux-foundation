#!/usr/bin/env bash
set -euo pipefail
PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$PROJECT_ROOT"

# prepare demo files
rm -rf data backups
./src/setup_demo_files.sh

# run backup
./scripts/backup.sh ./data ./backups 3

# check archive exists
ARCHIVE_COUNT=$(ls -1 backups/backup_*.tar.gz 2>/dev/null | wc -l || echo 0)
if [ "$ARCHIVE_COUNT" -lt 1 ]; then
  echo "FAIL: No backup archive created" >&2
  exit 1
fi

# check log contains OK
if ! grep -q "Backup created" backups/backup.log; then
  echo "FAIL: backups/backup.log missing entry" >&2
  exit 2
fi

echo "PASS: backup validation"
