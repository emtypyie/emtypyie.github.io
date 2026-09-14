#!/usr/bin/env bash
set -euo pipefail

URL="https://cluster0.emtypyie.in/ping"
LOG_DIR="sites/heartbeat/logs"
LOG_FILE="$LOG_DIR/error.log"

mkdir -p "$LOG_DIR"

CODE=$(curl -s -o /dev/null -w "%{http_code}" --max-time 30 "$URL")

if [ "$CODE" = "200" ]; then
  echo "heartbeat ok [$CODE]"
  exit 0
fi

TIMESTAMP=$(date -Iseconds)
printf '%s\t%s\n' "$TIMESTAMP" "$CODE" >> "$LOG_FILE"
echo "heartbeat failed [$CODE] logged to $LOG_FILE" >&2
exit 1