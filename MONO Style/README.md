# NSIGHT Marketing Platform — MONO Style 환경 구성

## 서버 사양
- **32 vCPU / 256GB RAM** (Tomcat-01, Tomcat-02 동일 스펙)
- JVM Heap 192GB, OS·DeltaManager·Off-heap 여유 64GB

## 구성 목적
단일 도메인 `nh.marketing.com` 기준으로 **하나의 Tomcat에 17개 WAR**를 배포하고,  
**Tomcat DeltaManager**로 세션을 복제하는 MONO(모놀리식 통합 배포) 샘플 환경파일입니다.

MSA Style과 달리 서비스별 Tomcat 분리 없이 **Tomcat-01 / Tomcat-02** 각각 동일 17 WAR 세트를 운영합니다.

## 운영 구조
```text
nh.marketing.com
        │
        ▼
Apache Cluster
  · SSL 종료
  · 17개 업무 ProxyPass
  · Sticky Session (jvmRoute)
  · GUID / Trace Access Log
        │
        ▼
L4 Sticky Session
        │
        ▼
Tomcat-01 (17 WAR)          Tomcat-02 (17 WAR)
  jvmRoute=tomcat01           jvmRoute=tomcat02
        │
        └── DeltaManager Session Replication
                │
                ▼
          RDW / ADW (Oracle)
```

## WAR 배포 구조
```text
webapps/
 ├─ cc.war   (/cc)
 ├─ ic.war   (/ic)
 ├─ pc.war   (/pc)
 ├─ bc.war   (/bc)
 ├─ ms.war   (/ms)
 ├─ sv.war   (/sv)
 ├─ pd.war   (/pd)
 ├─ cm.war   (/cm)
 ├─ eb.war   (/eb)
 ├─ ep.war   (/ep)
 ├─ bp.war   (/bp)
 ├─ bd.war   (/bd)
 ├─ ss.war   (/ss)
 ├─ cs.war   (/cs)
 ├─ ct.war   (/ct)
 ├─ mg.war   (/mg)
 └─ ROOT.war (/)   ← root.war 배포 시 ROOT.war 로 rename
```

## 디렉터리 구성
```text
MONO Style/
├── README.md
├── apache/
│   ├── httpd.conf
│   └── extra/
│       ├── nsight-mpm.conf          # mpm_event
│       ├── nsight-balancer.conf     # Sticky Session + Tomcat Cluster
│       └── nsight-vhost.conf        # SSL + 17 ProxyPass
├── tomcat/
│   ├── common/server.xml            # DeltaManager Cluster
│   ├── cluster/static-membership.xml
│   ├── bin/setenv.sh                # JVM 192GB / G1GC / GC Log / Heap Dump
│   ├── conf/web.xml                 # distributable 가이드
│   ├── contexts/                    # 17 Context 설정
│   └── webapps/README.md
└── spring/
    ├── application-common.yml       # Session / HikariCP / MyBatis
    ├── application-prod.yml
    ├── application-dev.yml
    ├── config/                      # DataSource / MyBatis Java Config
    └── apps/                        # WAR별 application.yml (17개)
```

## MSA Style 대비 핵심 차이

| 항목 | MSA Style | MONO Style |
|------|-----------|------------|
| Tomcat | 서비스별 분리 (5 Cluster) | 단일 Tomcat 17 WAR |
| Session | Spring Session JDBC | DeltaManager Replication |
| Apache 라우팅 | 5개 서비스 Prefix | 17개 업무 Prefix |
| DB Session 테이블 | SPRING_SESSION 필요 | 불필요 |
| web.xml | 일반 | `<distributable/>` 필수 |

## 포함 설정 요약

### 1. Apache
- `httpd.conf` — 메인 설정
- `nsight-mpm.conf` — mpm_event
- `nsight-vhost.conf` — SSL VirtualHost, 17 ProxyPass
- `nsight-balancer.conf` — Sticky Session (`stickysession=JSESSIONID`)
- Access Log — GUID(`X-GUID`), Trace(`X-Trace-Id`) 포함

### 2. Tomcat
- `server.xml` — DeltaManager, Membership, Receiver/Sender, ClusterListener
- `jvmRoute` — `tomcat01` / `tomcat02` (setenv.sh `JVM_ROUTE`)
- `contexts/*.xml` — 17 WAR Context
- `web.xml` — `<distributable/>` 가이드

### 3. Spring Boot
- Idle Session 60분 (`server.servlet.session.timeout`)
- Absolute Session 8시간 (`SessionTimeoutFilter`)
- Transaction Timeout 5초
- Cookie 보안 (http-only, secure, same-site)
- Profile 분리 (`prod` / `dev`)

### 4. HikariCP
- RDW — Read/Write Pool (max 200, min-idle 64)
- ADW — Analytics Read Pool (max 128, min-idle 32, read-only)
- Connection Timeout 3초

### 5. MyBatis
- RDW / ADW SqlSessionFactory 분리
- Mapper 패키지 분리 (`mapper.rdw` / `mapper.adw`)
- Query Timeout 3초

### 6. JVM (setenv.sh) — 32 vCPU / 256GB
- Heap 192GB (`-Xms192g -Xmx192g`)
- G1GC (`ParallelGCThreads=32`, `G1HeapRegionSize=16m`)
- DirectMemory 8GB (`MaxDirectMemorySize`)
- Metaspace max 4GB
- GC Log (`/app/logs/tomcat/gc/`)
- Heap Dump on OOM (`/app/logs/tomcat/dump/`)

### 7. Tomcat Connector / Apache MPM
- Tomcat `maxThreads` 3200, `maxConnections` 50000
- Apache `MaxRequestWorkers` 4096 (32 x 128)

## 반영 시 확인
- IP/Port, jvmRoute, Multicast 주소를 실제 서버 기준으로 변경
- 운영 환경은 Multicast 대신 `tomcat/cluster/static-membership.xml` 참고하여 Static Membership 적용 권장
- SSL 인증서 경로 변경
- RDW/ADW DB 접속정보 변경 (`CHANGEME` 교체)
- 모든 WAR `WEB-INF/web.xml`에 `<distributable/>` 추가
- 반영 전 `apachectl configtest`, Tomcat 기동 및 세션 복제 테스트 수행

## 서버별 환경 변수

| 서버 | JVM_ROUTE | NODE_NAME |
|------|-----------|-----------|
| Tomcat-01 | tomcat01 | nsight-tomcat-01 |
| Tomcat-02 | tomcat02 | nsight-tomcat-02 |
