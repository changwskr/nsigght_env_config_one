#!/bin/sh
# ============================================================
# NSIGHT Tomcat JVM Options - 8 vCPU / 32GB 기준
# SERVICE_NAME and JVM_ROUTE must be changed per server.
# ============================================================

export SERVICE_NAME=${SERVICE_NAME:-customer-service}
export JVM_ROUTE=${JVM_ROUTE:-cust1}

export CATALINA_OPTS="$CATALINA_OPTS -Dfile.encoding=UTF-8"
export CATALINA_OPTS="$CATALINA_OPTS -Duser.timezone=Asia/Seoul"
export CATALINA_OPTS="$CATALINA_OPTS -Djava.security.egd=file:/dev/./urandom"
export CATALINA_OPTS="$CATALINA_OPTS -DJVM_ROUTE=${JVM_ROUTE}"
export CATALINA_OPTS="$CATALINA_OPTS -Dspring.profiles.active=prod"
export CATALINA_OPTS="$CATALINA_OPTS -Dspring.config.location=/app/nsight/config/${SERVICE_NAME}/application.yml"

export CATALINA_OPTS="$CATALINA_OPTS -Xms12g -Xmx12g -Xss512k"
export CATALINA_OPTS="$CATALINA_OPTS -XX:+UseG1GC"
export CATALINA_OPTS="$CATALINA_OPTS -XX:MaxGCPauseMillis=200"
export CATALINA_OPTS="$CATALINA_OPTS -XX:MetaspaceSize=256m -XX:MaxMetaspaceSize=1g"
export CATALINA_OPTS="$CATALINA_OPTS -XX:ReservedCodeCacheSize=256m"
export CATALINA_OPTS="$CATALINA_OPTS -XX:+HeapDumpOnOutOfMemoryError"
export CATALINA_OPTS="$CATALINA_OPTS -XX:HeapDumpPath=/app/logs/${SERVICE_NAME}/dump"
export CATALINA_OPTS="$CATALINA_OPTS -XX:+ExitOnOutOfMemoryError"
export CATALINA_OPTS="$CATALINA_OPTS -Xlog:gc*:file=/app/logs/${SERVICE_NAME}/gc/gc-%t.log:time,uptime,level,tags:filecount=10,filesize=100M"
