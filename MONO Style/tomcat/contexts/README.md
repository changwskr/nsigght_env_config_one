# Context 배포 안내

`contexts/*.xml` 파일을 Tomcat 서버의 `conf/Catalina/localhost/` 경로에 복사합니다.

예시:
```bash
cp /app/nsight/config/tomcat/contexts/*.xml $CATALINA_HOME/conf/Catalina/localhost/
```

`ROOT.xml`은 `conf/Catalina/localhost/ROOT.xml`로 배치합니다.
