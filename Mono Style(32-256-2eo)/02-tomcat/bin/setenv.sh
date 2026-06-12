#!/usr/bin/env bash
# NSIGHT Tomcat JVM — 32 vCPU / 256GB / 노드 2대 (tc01, tc02)
#
# Heap 산정 (64GB / 노드):
#   지점 6,000 × 지점당 6명 = 36,000 사용자
#   동시접속 10% = 3,600
#   DB 트랜잭션 타임아웃 3초 (db-query-seconds: 3)
#   ├ 세션: 3,600 × 64KB ≈ 0.25GB (max-session-size-kb: 5 + Tomcat 오버헤드)
#   ├ 처리중 요청(피크 40%): 1,440 × 1.5MB ≈ 2.2GB
#   ├ 17 WAR Spring 기동·캐시: ≈ 12GB
#   └ 피크 2배 + G1 여유(65%) → 단일 노드 장애복구(전량 3,600) 수용 시 64GB
export JAVA_HOME=/usr/lib/jvm/java-17
export CATALINA_BASE=/app/tomcat-nsight
export CATALINA_HOME=/opt/tomcat
export JVM_ROUTE=${JVM_ROUTE:-tc01}
export HTTP_PORT=${HTTP_PORT:-8080}
export SHUTDOWN_PORT=${SHUTDOWN_PORT:-8005}
export CLUSTER_BIND_ADDRESS=${CLUSTER_BIND_ADDRESS:-10.10.20.11}
export CLUSTER_RECEIVER_PORT=${CLUSTER_RECEIVER_PORT:-4000}
export NODE_NAME=${NODE_NAME:-nsight-tomcat}

export CATALINA_OPTS="$CATALINA_OPTS -Dfile.encoding=UTF-8 -Duser.timezone=Asia/Seoul"
export CATALINA_OPTS="$CATALINA_OPTS -DjvmRoute=$JVM_ROUTE -Dhttp.port=$HTTP_PORT -Dshutdown.port=$SHUTDOWN_PORT"
export CATALINA_OPTS="$CATALINA_OPTS -Dcluster.bind.address=$CLUSTER_BIND_ADDRESS -Dcluster.receiver.port=$CLUSTER_RECEIVER_PORT"

# Heap 64GB
export CATALINA_OPTS="$CATALINA_OPTS -Xms64g -Xmx64g -Xss512k"

# G1GC
export CATALINA_OPTS="$CATALINA_OPTS -XX:+UseG1GC -XX:MaxGCPauseMillis=200"
export CATALINA_OPTS="$CATALINA_OPTS -XX:InitiatingHeapOccupancyPercent=40"
export CATALINA_OPTS="$CATALINA_OPTS -XX:G1HeapRegionSize=16m -XX:G1ReservePercent=15"
export CATALINA_OPTS="$CATALINA_OPTS -XX:ParallelGCThreads=32 -XX:ConcGCThreads=8"
export CATALINA_OPTS="$CATALINA_OPTS -XX:MetaspaceSize=1g -XX:MaxMetaspaceSize=4g"
export CATALINA_OPTS="$CATALINA_OPTS -XX:ReservedCodeCacheSize=1g"
export CATALINA_OPTS="$CATALINA_OPTS -XX:MaxDirectMemorySize=8g"

export CATALINA_OPTS="$CATALINA_OPTS -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/logs/dump/heapdump-${NODE_NAME}-%t.hprof -XX:+ExitOnOutOfMemoryError"
export CATALINA_OPTS="$CATALINA_OPTS -Xlog:gc*,gc+heap=debug:file=/logs/gc/gc-${NODE_NAME}-%t.log:time,uptime,level,tags:filecount=30,filesize=200M"
