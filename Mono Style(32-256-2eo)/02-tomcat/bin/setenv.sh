#!/usr/bin/env bash
# NSIGHT Tomcat JVM — 32 vCPU / 256GB / 노드 2대 (tc01, tc02)
# Heap 192GB (OS·DeltaManager·Off-heap 여유 64GB)
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

# Heap 192GB
export CATALINA_OPTS="$CATALINA_OPTS -Xms192g -Xmx192g -Xss512k"

# G1GC (대용량 Heap)
export CATALINA_OPTS="$CATALINA_OPTS -XX:+UseG1GC -XX:MaxGCPauseMillis=200"
export CATALINA_OPTS="$CATALINA_OPTS -XX:InitiatingHeapOccupancyPercent=40"
export CATALINA_OPTS="$CATALINA_OPTS -XX:G1HeapRegionSize=16m -XX:G1ReservePercent=15"
export CATALINA_OPTS="$CATALINA_OPTS -XX:ParallelGCThreads=32 -XX:ConcGCThreads=8"
export CATALINA_OPTS="$CATALINA_OPTS -XX:MetaspaceSize=1g -XX:MaxMetaspaceSize=4g"
export CATALINA_OPTS="$CATALINA_OPTS -XX:ReservedCodeCacheSize=1g"
export CATALINA_OPTS="$CATALINA_OPTS -XX:MaxDirectMemorySize=8g"

export CATALINA_OPTS="$CATALINA_OPTS -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/logs/dump/heapdump-${NODE_NAME}-%t.hprof -XX:+ExitOnOutOfMemoryError"
export CATALINA_OPTS="$CATALINA_OPTS -Xlog:gc*,gc+heap=debug:file=/logs/gc/gc-${NODE_NAME}-%t.log:time,uptime,level,tags:filecount=30,filesize=200M"
