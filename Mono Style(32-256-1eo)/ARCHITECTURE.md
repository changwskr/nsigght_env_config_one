# 개발용 단일 VM 아키텍처 (32-256-1eo)

## 1. 목표 구조

```text
nh.marketing.com (hosts 또는 dev DNS)
   ↓
Apache HTTPD 2.4  (동일 VM)
   ↓  ProxyPass → http://127.0.0.1:8080
Tomcat 단일 인스턴스 (dev-vm)
   ↓
17 Spring Boot WAR
   ↓
HikariCP / MyBatis / 개발 DB
```

## 2. 세션 방식

- **단일 Tomcat** — 로컬 `HttpSession` (복제 없음)
- Idle 60분 / Absolute 8시간 (`AbsoluteSessionTimeoutFilter`)
- `JSESSIONID` 쿠키 (`secure=false` — 로컬 HTTP 허용)

## 3. DeltaManager

개발 VM에서는 **비활성**. 운영 전환 시 `Mono Style(32-256-2eo)`의 `server.xml` Cluster 설정을 적용합니다.

## 4. WAR 목록

`00-inventory/war-contexts.csv` 참고 (17개)

## 5. 검증 포인트 (개발)

| 항목 | 확인 방법 |
|---|---|
| Apache Syntax | `apachectl -t` |
| Tomcat 기동 | `curl http://127.0.0.1:8080/portal/actuator/health` |
| 17 WAR 라우팅 | `validate-endpoints.sh` |
| DB 연결 | Actuator health / 로그 |

세션 복제·Sticky·장애전환 테스트는 **2eo** 환경에서 수행합니다.
