#!/usr/bin/env bash
set -euo pipefail
mkdir -p data/demo
echo "hello" > data/demo/file1.txt
echo "secret" > data/demo/file2.txt
# Create a group and user only if running as root / sudo
if [ "$(id -u)" -eq 0 ]; then
  groupadd -f cloudlearn
  id -u student &>/dev/null || useradd -m -G cloudlearn student || true
  chown -R student:cloudlearn data
  chmod 640 data/demo/file1.txt
  chmod 600 data/demo/file2.txt
fi
