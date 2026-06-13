#!/usr/bin/env bash
set -euo pipefail
CATALINA_BASE=${CATALINA_BASE:-/app/tomcat-nsight}
WAR_SOURCE=${WAR_SOURCE:-/app/nsight/war}
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONTEXT_SOURCE="${SCRIPT_DIR}/../tomcat/conf/Catalina/localhost"
INVENTORY="${SCRIPT_DIR}/../00-inventory/war-contexts.csv"

mkdir -p "$CATALINA_BASE/webapps"
mkdir -p "$CATALINA_BASE/conf/Catalina/localhost"

tail -n +2 "$INVENTORY" | while IFS=, read -r no war_file context_path description health_check; do
  src="$WAR_SOURCE/$war_file"
  if [[ ! -f "$src" ]]; then
    echo "WARN: missing WAR $src" >&2
    continue
  fi
  cp "$src" "$CATALINA_BASE/webapps/$war_file"
done

cp "$CONTEXT_SOURCE"/*.xml "$CATALINA_BASE/conf/Catalina/localhost/"
echo "Deployed 16 WARs and Context XML to $CATALINA_BASE"
