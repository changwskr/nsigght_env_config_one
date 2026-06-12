# NSIGHT 개발 환경 — Mono Style (32-256-1eo)

## 1. 구성 목적

**32 vCPU / 256GB VM 1대**에서 Apache + Tomcat + 17 WAR를 모두 구동하는 **개발(Dev) 전용** 환경설정입니다.

운영용 `Mono Style(32-256-2eo)`와 달리 **Tomcat Cluster·DeltaManager·Sticky Session을 사용하지 않습니다.**

```text
[개발자 PC / Browser]
        ↓ https://nh.marketing.com (또는 hosts 로컬)
[Apache HTTPD 2.4]  ─┐
        ↓              │ 동일 VM (32 vCPU / 256GB)
[Tomcat localhost:8080]─┘
        ↓ 17 WAR
[Spring Boot WAR / HikariCP / MyBatis]
        ↓
[개발 DB — RDW / APPLOG]
```

## 2. 기준 전제

| 항목 | 기준 |
|---|---|
| VM | **1대**, 32 vCPU / 256GB |
| 배포 | Apache + Tomcat 동일 서버 |
| Tomcat 노드 | **1대** (`127.0.0.1:8080`) |
| JVM Heap | **48GB** (동시 3,600·트랜잭션 3초 산정, 풀부하 테스트 시 64GB) |
| 세션 복제 | **미사용** (단일 Tomcat) |
| Sticky Session | **미사용** |
| Spring Profile | `dev` |
| Tomcat Thread | `maxThreads=1600`, `maxConnections=20000` |
| HikariCP RDW | max **32** (dev) |
| HikariCP APPLOG | max **16** (dev) |
| WAR autoDeploy | `true` (개발 편의) |

## 3. 2eo(운영)와 차이

| 항목 | 1eo (개발) | 2eo (운영) |
|------|------------|------------|
| VM 수 | 1대 | 2대 |
| Cluster | 없음 | DeltaManager |
| Apache | `127.0.0.1:8080` 직접 Proxy | Balancer + Sticky |
| Heap | 48GB | 64GB/노드 |
| Profile | dev | prod |
| distributable | 선택 (운영 전환 시 필수) | 필수 |

## 4. 적용 순서

1. `00-inventory/tomcat-nodes.csv` 확인 (dev-vm 단일 노드)
2. Apache 설정 반영 후 `apachectl -t` (`20-proxy`/`40-security`는 VirtualHost에서만 로드)
3. `02-tomcat/bin/setenv.sh` → Tomcat 기동
4. `05-deploy/deploy-war-layout.sh`로 17 WAR + Context XML 배포
5. `05-deploy/validate-endpoints.sh`로 헬스체크
6. `/etc/hosts`에 `127.0.0.1 nh.marketing.com` 추가 (로컬 SSL 테스트 시)

## 5. 핵심 개발 원칙

- 세션 복제 테스트는 **2eo 환경**에서 수행
- 개발 VM에서는 `autoDeploy=true`로 WAR 교체 편의 제공
- DB는 개발 스키마(`DEV_RDW`, `DEV_APPLOG`) 사용
- 운영 배포 전 `2eo` 설정으로 전환·검증 필수
