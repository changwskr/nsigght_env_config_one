# NSIGHT Marketing Platform — 운영 설정 패키지

`nh.marketing.com` 기준 Apache + Tomcat Cluster + Spring Session JDBC 운영 매뉴얼·설정 템플릿입니다.

## 구조

```text
nsight_system_manual/
├── doc/                  PDF 운영 매뉴얼
├── 00-inventory/         war-contexts.csv, tomcat-nodes.csv
├── 05-deploy/            배포·검증 스크립트, env 템플릿
├── apache/               httpd, vhost, balancer (16 WAR)
├── tomcat/               server.xml (JDBC Session, Cluster 없음)
└── spring/
    ├── config/           YAML 프로필 (common/dev/stg/prd)
    ├── java-config/      공통 Java Config (Maven)
    └── sql/              Spring Session DDL
```

## 세션 정책

| 항목 | 값 |
|------|-----|
| 방식 | **Spring Session JDBC** (SESSIONDB) |
| Tomcat DeltaManager | **미사용** |
| WAR | **16개** (`/cc` ~ `/mg`) |
| Idle | 60분 |
| Absolute | 8시간 (Filter) |

## 빠른 시작

1. SESSIONDB에 `spring/sql/spring-session-schema-oracle.sql` 실행
2. `spring/config/` → `/app/nsight/config/` 복사 (common + prd)
3. `05-deploy/env/nsight-env.template` → DB 계정 설정
4. `spring/java-config` Maven 빌드 → WAR에 JAR 포함
5. `05-deploy/deploy-war-layout.sh` 실행
6. `05-deploy/validate-endpoints.sh` 로 health 확인

## Mono Style과의 차이

| 항목 | nsight_system_manual | Mono Style(32-256-*) |
|------|---------------------|----------------------|
| Context | `/cc`, `/ic` … (16) | `/auth`, `/portal` … (17) |
| 세션 | Spring Session JDBC | DeltaManager (2eo) / 로컬 (1eo) |
| 서버 | 8C/32GB, Heap 12GB | 32C/256GB |

자세한 적용 절차: `spring/README/apply-guide.txt`
