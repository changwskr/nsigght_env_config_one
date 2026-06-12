#!/usr/bin/env bash
# NSIGHT Tomcat JVM — 개발용 단일 VM (32 vCPU / 256GB)
# Apache + Tomcat 동일 서버 — Heap 160GB (OS·Apache 여유 ~96GB)
export JAVA_HOME=/usr/lib/jvm/java-17
export CATALINA_BASE=/app/tomcat-nsight
export CATALINA_HOME=/opt/tomcat
export HTTP_PORT=${HTTP_PORT:-8080}
export SHUTDOWN_PORT=${SHUTDOWN_PORT:-8005}
export NODE_NAME=${NODE_NAME:-nsight-tomcat-dev}

export CATALINA_OPTS="$CATALINA_OPTS -Dfile.encoding=UTF-8 -Duser.timezone=Asia/Seoul"
export CATALINA_OPTS="$CATALINA_OPTS -Dhttp.port=$HTTP_PORT -Dshutdown.port=$SHUTDOWN_PORT"
export CATALINA_OPTS="$CATALINA_OPTS -Dspring.profiles.active=dev"

# Heap 160GB (단일 VM — Apache와 메모리 공유)
export CATALINA_OPTS="$CATALINA_OPTS -Xms160g -Xmx160g -Xss512k"

# G1GC
export CATALINA_OPTS="$CATALINA_OPTS -XX:+UseG1GC -XX:MaxGCPauseMillis=200"
export CATALINA_OPTS="$CATALINA_OPTS -XX:InitiatingHeapOccupancyPercent=40"
export CATALINA_OPTS="$CATALINA_OPTS -XX:G1HeapRegionSize=16m -XX:G1ReservePercent=15"
export CATALINA_OPTS="$CATALINA_OPTS -XX:ParallelGCThreads=32 -XX:ConcGCThreads=8"
export CATALINA_OPTS="$CATALINA_OPTS -XX:MetaspaceSize=512m -XX:MaxMetaspaceSize=2g"
export CATALINA_OPTS="$CATALINA_OPTS -XX:ReservedCodeCacheSize=512m"
export CATALINA_OPTS="$CATALINA_OPTS -XX:MaxDirectMemorySize=4g"

export CATALINA_OPTS="$CATALINA_OPTS -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/logs/dump/heapdump-${NODE_NAME}-%t.hprof -XX:+ExitOnOutOfMemoryError"
export CATALINA_OPTS="$CATALINA_OPTS -Xlog:gc*:file=/logs/gc/gc-${NODE_NAME}-%t.log:time,uptime,level,tags:filecount=10,filesize=100M"
