#!/bin/sh
# ============================================================
# NSIGHT Tomcat JVM Options (MONO) - 32 vCPU / 256GB 기준
# JVM_ROUTE: tomcat01 (Tomcat-01) / tomcat02 (Tomcat-02)
# Heap 192GB (OS·DeltaManager·Off-heap 여유 64GB)
# ============================================================

export JVM_ROUTE=${JVM_ROUTE:-tomcat01}
export NODE_NAME=${NODE_NAME:-nsight-tomcat-mono}

export CATALINA_OPTS="$CATALINA_OPTS -Dfile.encoding=UTF-8"
export CATALINA_OPTS="$CATALINA_OPTS -Duser.timezone=Asia/Seoul"
export CATALINA_OPTS="$CATALINA_OPTS -Djava.security.egd=file:/dev/./urandom"
export CATALINA_OPTS="$CATALINA_OPTS -DJVM_ROUTE=${JVM_ROUTE}"
export CATALINA_OPTS="$CATALINA_OPTS -Dspring.profiles.active=prod"
export CATALINA_OPTS="$CATALINA_OPTS -Dspring.config.additional-location=/app/nsight/config/"

# Heap 192GB (256GB 중 약 75%)
export CATALINA_OPTS="$CATALINA_OPTS -Xms192g -Xmx192g -Xss512k"

# G1GC (대용량 Heap)
export CATALINA_OPTS="$CATALINA_OPTS -XX:+UseG1GC"
export CATALINA_OPTS="$CATALINA_OPTS -XX:MaxGCPauseMillis=200"
export CATALINA_OPTS="$CATALINA_OPTS -XX:InitiatingHeapOccupancyPercent=40"
export CATALINA_OPTS="$CATALINA_OPTS -XX:G1HeapRegionSize=16m"
export CATALINA_OPTS="$CATALINA_OPTS -XX:G1ReservePercent=15"
export CATALINA_OPTS="$CATALINA_OPTS -XX:ParallelGCThreads=32"
export CATALINA_OPTS="$CATALINA_OPTS -XX:ConcGCThreads=8"
export CATALINA_OPTS="$CATALINA_OPTS -XX:MetaspaceSize=1g -XX:MaxMetaspaceSize=4g"
export CATALINA_OPTS="$CATALINA_OPTS -XX:ReservedCodeCacheSize=1g"

# Direct Memory / NIO (DeltaManager·Connector)
export CATALINA_OPTS="$CATALINA_OPTS -XX:MaxDirectMemorySize=8g"

# Heap Dump / OOM
export CATALINA_OPTS="$CATALINA_OPTS -XX:+HeapDumpOnOutOfMemoryError"
export CATALINA_OPTS="$CATALINA_OPTS -XX:HeapDumpPath=/app/logs/tomcat/dump/heapdump-${NODE_NAME}-%t.hprof"
export CATALINA_OPTS="$CATALINA_OPTS -XX:+ExitOnOutOfMemoryError"

# GC Log
export CATALINA_OPTS="$CATALINA_OPTS -Xlog:gc*,gc+heap=debug,gc+age=trace:file=/app/logs/tomcat/gc/gc-${NODE_NAME}-%t.log:time,uptime,level,tags:filecount=30,filesize=200M"
