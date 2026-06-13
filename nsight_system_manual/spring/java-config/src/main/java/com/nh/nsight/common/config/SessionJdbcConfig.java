package com.nh.nsight.common.config;

import javax.sql.DataSource;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.session.jdbc.config.annotation.web.http.EnableJdbcHttpSession;

@Configuration
@EnableJdbcHttpSession(tableName = "SPRING_SESSION")
public class SessionJdbcConfig {

  @Bean(name = "springSessionDataSource")
  public DataSource springSessionDataSource(
      @Qualifier("sessiondbDataSource") DataSource sessiondbDataSource) {
    return sessiondbDataSource;
  }
}
