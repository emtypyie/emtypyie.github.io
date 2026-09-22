#!/usr/bin/env bash
set -euo pipefail

# Server-side health check for emtypyie.in infrastructure.
# Maps HTTP responses to states:
#   200          -> ok      (operational)
#   3xx / 404    -> maint   (down for maintenance / not yet public)
#   other/error  -> down    (unreachable)
# Emits sites/main/status/status.json only when the set of states changed,
# so the status workflow only commits on real changes.

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUT="$DIR/status.json"
TMP="$OUT.new"

SERVICES=(
  "backend|cluster0|https://cluster0.emtypyie.in/ping"
  "backend|cluster1|https://cluster1.emtypyie.in/ping"
  "backend|auth|https://auth.emtypyie.in/ping"
  "sites|wiki|https://wiki.emtypyie.in"
  "sites|research|https://research.emtypyie.in"
  "sites|emtypyie|https://emtypyie.in"
  "sites|cdn|https://cdn.emtypyie.in"
  "sites|auth|https://auth.emtypyie.in"
)

declare -A STATE
declare -A CODE

for entry in "${SERVICES[@]}"; do
  IFS='|' read -r _group name url <<< "$entry"
  code=$(curl -s -o /dev/null -w '%{http_code}' --max-time 15 "$url" || echo 000)
  case "$code" in
    200)    state="ok" ;;
    3*|404) state="maint" ;;
    *)      state="down" ;;
  esac
  STATE["$name"]="$state"
  CODE["$name"]="$code"
done

list=$(
  for entry in "${SERVICES[@]}"; do
    IFS='|' read -r group name url <<< "$entry"
    jq -nc --arg g "$group" --arg n "$name" --arg u "$url" \
      --arg s "${STATE[$name]}" --arg c "${CODE[$name]}" \
      '{name:$n, group:$g, url:$u, state:$s, code:$c}'
  done | jq -s '.'
)

generated=$(date -u -Iseconds)
jq -n --arg t "$generated" --argjson svc "$list" \
  '{generated_at:$t, services:$svc}' > "$TMP"

if [ -f "$OUT" ] && jq -e -n \
  --slurpfile n "$TMP" --slurpfile c "$OUT" \
  '($n[0].services | map({name,state,code})) == ($c[0].services | map({name,state,code}))' >/dev/null 2>&1; then
  rm -f "$TMP"
  echo "status unchanged"
else
  mv "$TMP" "$OUT"
  echo "status updated"
fi