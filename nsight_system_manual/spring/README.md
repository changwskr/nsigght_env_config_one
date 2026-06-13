# NSIGHT Spring JDBC Session 전체 설정 파일

## 변경 기준
기존 Redis Session 기준을 제거하고, Spring Session JDBC 기반으로 세션을 관리합니다.

## 구조
```text
nh.marketing.com
  ↓
Apache (Sticky, HSTS)
  ↓
Tomcat Cluster (2노드, DeltaManager 없음)
  ↓
16 WAR (/cc ~ /mg)
  ↓
Spring Boot + java-config
  ↓
Spring Session JDBC
  ↓
SESSIONDB
```

## 핵심 원칙
- Redis 미사용
- Spring Session JDBC 사용 (`@EnableJdbcHttpSession`, sessiondbDataSource)
- Tomcat DeltaManager 미사용
- 단일 도메인 기준 JSESSIONID 쿠키 (path=/)
- 모든 WAR가 동일 SESSIONDB를 바라봄
- Absolute Session 8시간: `AbsoluteSessionTimeoutFilter`
- 대량 조회 결과·고객목록 등 세션 저장 금지 (deny-list는 애플리케이션에서 구현)

## 포함 파일
- `spring/config/common/*.yml` — 공통 설정
- `spring/config/dev|stg|prd/*.yml` — 프로필별 override
- `spring/java-config/` — DataSource 4종, Session JDBC, MyBatis, Filter (Maven)
- `spring/sql/spring-session-schema-oracle.sql` — SESSIONDB 선행 DDL
- `spring/logback/logback-spring.xml`
- `spring/templates/web.xml`

## WAR 적용 방법
1. `spring/java-config` 빌드 후 공통 JAR를 각 WAR `WEB-INF/lib`에 포함
2. Tomcat `setenv.sh`에 `-Dspring.config.additional-location=file:/app/nsight/config/` 설정
3. `05-deploy/env/nsight-env.template` 기반 DB 계정 주입
4. SESSIONDB에 `spring-session-schema-oracle.sql` 선행 실행

## 배포·검증
- `00-inventory/war-contexts.csv` — 16 WAR 정의
- `05-deploy/deploy-war-layout.sh` — WAR + Context XML 배포
- `05-deploy/validate-endpoints.sh` — context별 health check
