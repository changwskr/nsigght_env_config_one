#!/bin/sh
# NSIGHT Tomcat JVM Options
# WAS1: export JVM_ROUTE=was1
# WAS2: export JVM_ROUTE=was2

export SERVICE_NAME=${SERVICE_NAME:-nsight-marketing}
export JVM_ROUTE=${JVM_ROUTE:-was1}

export CATALINA_OPTS="$CATALINA_OPTS -Dfile.encoding=UTF-8"
export CATALINA_OPTS="$CATALINA_OPTS -Duser.timezone=Asia/Seoul"
export CATALINA_OPTS="$CATALINA_OPTS -Djava.security.egd=file:/dev/./urandom"
export CATALINA_OPTS="$CATALINA_OPTS -DJVM_ROUTE=${JVM_ROUTE}"

# Spring Boot 외부 YAML (spring/config → /app/nsight/config/ 복사)
export CATALINA_OPTS="$CATALINA_OPTS -Dspring.config.additional-location=file:/app/nsight/config/common/,file:/app/nsight/config/${SPRING_PROFILES_ACTIVE:-prd}/"
export CATALINA_OPTS="$CATALINA_OPTS -Dspring.profiles.active=${SPRING_PROFILES_ACTIVE:-prd}"

# 8Core/32GB 기준. 16Core/64GB, 32Core/256GB는 별도 산정 후 조정.
export CATALINA_OPTS="$CATALINA_OPTS -Xms12g -Xmx12g -Xss512k"
export CATALINA_OPTS="$CATALINA_OPTS -XX:+UseG1GC"
export CATALINA_OPTS="$CATALINA_OPTS -XX:MaxGCPauseMillis=200"
export CATALINA_OPTS="$CATALINA_OPTS -XX:MetaspaceSize=256m -XX:MaxMetaspaceSize=1g"
export CATALINA_OPTS="$CATALINA_OPTS -XX:ReservedCodeCacheSize=256m"
export CATALINA_OPTS="$CATALINA_OPTS -XX:+HeapDumpOnOutOfMemoryError"
export CATALINA_OPTS="$CATALINA_OPTS -XX:HeapDumpPath=/app/logs/${SERVICE_NAME}/dump"
export CATALINA_OPTS="$CATALINA_OPTS -XX:+ExitOnOutOfMemoryError"
export CATALINA_OPTS="$CATALINA_OPTS -Xlog:gc*:file=/app/logs/${SERVICE_NAME}/gc/gc-%t.log:time,uptime,level,tags:filecount=10,filesize=100M"
