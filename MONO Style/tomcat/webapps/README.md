# 17개 WAR 배포 구조

```
webapps/
 ├─ cc.war      → context-path: /cc
 ├─ ic.war      → context-path: /ic
 ├─ pc.war      → context-path: /pc
 ├─ bc.war      → context-path: /bc
 ├─ ms.war      → context-path: /ms
 ├─ sv.war      → context-path: /sv
 ├─ pd.war      → context-path: /pd
 ├─ cm.war      → context-path: /cm
 ├─ eb.war      → context-path: /eb
 ├─ ep.war      → context-path: /ep
 ├─ bp.war      → context-path: /bp
 ├─ bd.war      → context-path: /bd
 ├─ ss.war      → context-path: /ss
 ├─ cs.war      → context-path: /cs
 ├─ ct.war      → context-path: /ct
 ├─ mg.war      → context-path: /mg
 └─ ROOT.war    → context-path: /  (root.war → ROOT.war 로 배포)
```

## 배포 규칙
- Tomcat-01, Tomcat-02 동일 WAR 세트 배포
- `autoDeploy=false` — 수동/CI 배포 권장
- 각 WAR `WEB-INF/web.xml`에 `<distributable/>` 필수
- Context 개별 설정: `tomcat/contexts/` 참고
