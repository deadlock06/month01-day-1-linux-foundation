#!/usr/bin/env bash
set -euo pipefail
# scripts/backup.sh
# Usage: ./scripts/backup.sh [SRC_DIR] [DEST_DIR] [RETENTION]

SRC_DIR="${1:-./data}"
DEST_DIR="${2:-./backups}"
RETENTION="${3:-7}"    # keep last 7 backups

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
mkdir -p "$DEST_DIR"

# create archive
ARCHIVE="${DEST_DIR}/backup_${TIMESTAMP}.tar.gz"

if [ ! -d "$SRC_DIR" ]; then
  echo "ERROR: source directory '$SRC_DIR' does not exist" >&2
  exit 2
fi

tar -czf "$ARCHIVE" -C "$(dirname "$SRC_DIR")" "$(basename "$SRC_DIR")"

# log
LOGFILE="${DEST_DIR}/backup.log"
echo "$(date --iso-8601=seconds) Backup created: $ARCHIVE" >> "$LOGFILE"

# rotate - keep newest $RETENTION backups
ls -1t "${DEST_DIR}"/backup_*.tar.gz 2>/dev/null | tail -n +$((RETENTION+1)) | xargs -r rm --

echo "OK: $ARCHIVE"
