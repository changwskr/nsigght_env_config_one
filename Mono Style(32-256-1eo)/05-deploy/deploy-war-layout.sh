#!/usr/bin/env bash
set -euo pipefail
CATALINA_BASE=${CATALINA_BASE:-/app/tomcat-nsight}
WAR_SOURCE=${WAR_SOURCE:-/app/artifacts}
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONTEXT_SOURCE="${SCRIPT_DIR}/../02-tomcat/conf/Catalina/localhost"

mkdir -p "$CATALINA_BASE/webapps"
mkdir -p "$CATALINA_BASE/conf/Catalina/localhost"

# 17 WAR 배포
for war in nsight-auth.war nsight-portal.war nsight-customer-service.war nsight-singleview-service.war nsight-campaign-service.war nsight-event-service.war nsight-platform-service.war nsight-ebm-service.war nsight-message-service.war nsight-segment-service.war nsight-report-service.war nsight-stat-service.war nsight-admin-service.war nsight-code-service.war nsight-file-service.war nsight-audit-service.war nsight-batch-admin.war; do
  cp "$WAR_SOURCE/$war" "$CATALINA_BASE/webapps/$war"
done

# Context XML — Apache ProxyPass path 와 일치 (war-contexts.csv 기준)
cp "$CONTEXT_SOURCE"/*.xml "$CATALINA_BASE/conf/Catalina/localhost/"
echo "Deployed 17 WARs and Context XML to $CATALINA_BASE"
