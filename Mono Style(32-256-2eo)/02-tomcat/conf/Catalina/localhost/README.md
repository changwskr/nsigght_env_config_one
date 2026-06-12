# Tomcat Context 배포 (운영 2노드)

`war-contexts.csv` 기준 17개 Context XML. 운영용 `reloadable="false"`.

배포:
```bash
cp conf/Catalina/localhost/*.xml $CATALINA_BASE/conf/Catalina/localhost/
```

또는 `05-deploy/deploy-war-layout.sh` 실행.

`path`는 Apache `20-proxy-balancer-17war.conf` ProxyPass 와 동일해야 합니다.
