# NSIGHT Tomcat 전체 설정 파일

## 구조

```text
nh.marketing.com → Apache (Sticky) → Tomcat Cluster(2노드) → 16 WAR
```

## 세션

- **Spring Session JDBC** → SESSIONDB (`SPRING_SESSION` 테이블)
- **Tomcat DeltaManager 미사용** (server.xml Cluster 없음)
- Apache Sticky Session: `JSESSIONID` + Tomcat `jvmRoute` (성능 최적화용, 필수 아님)

## 전제

- 모든 Tomcat 노드에 동일한 **16개 WAR** 배포
- Context XML: `conf/Catalina/localhost/*.xml`
- `RemoteIpValve`: Apache `X-Forwarded-Proto` 반영
- 세션 객체는 Serializable 권장, 대량 데이터 세션 저장 금지
