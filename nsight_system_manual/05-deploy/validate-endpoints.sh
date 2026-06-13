#!/usr/bin/env bash
set -euo pipefail
BASE_URL=${BASE_URL:-https://nh.marketing.com}
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INVENTORY="${SCRIPT_DIR}/../00-inventory/war-contexts.csv"

tail -n +2 "$INVENTORY" | while IFS=, read -r no war_file context_path description health_check; do
  ctx="${context_path#/}"
  ctx="${ctx%/}"
  echo "== /$ctx =="
  curl -k -fsS "$BASE_URL/$ctx/actuator/health" || echo "health check failed: /$ctx"
done
