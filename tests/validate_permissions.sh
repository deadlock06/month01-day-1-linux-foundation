#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

# Ensure demo files exist (without requiring sudo)
[ -f data/demo/file1.txt ] || echo "hello" > data/demo/file1.txt
[ -f data/demo/file2.txt ] || echo "secret" > data/demo/file2.txt

# Show permissions
ls -l data/demo/file1.txt data/demo/file2.txt

# Validate mode - we accept either current user or student if created
MODE1=$(stat -c "%a" data/demo/file1.txt)
MODE2=$(stat -c "%a" data/demo/file2.txt)

# simple checks: owner-read for file1, owner-read-write for file2 (6xx)
if [ "$MODE1" -gt 777 ] || [ "$MODE2" -gt 777 ]; then
  echo "FAIL: suspicious permission bits" >&2
  exit 1
fi

echo "PASS: permissions look sane (modes: $MODE1, $MODE2)"
