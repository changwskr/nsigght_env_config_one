package com.nh.nsight.common.config;

import com.zaxxer.hikari.HikariDataSource;
import javax.sql.DataSource;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;

@Configuration
public class DataSourceConfig {

  @Primary
  @Bean(name = "rdwDataSource")
  @ConfigurationProperties(prefix = "spring.datasource.rdw")
  public DataSource rdwDataSource() {
    return DataSourceBuilder.create().type(HikariDataSource.class).build();
  }

  @Bean(name = "adwDataSource")
  @ConfigurationProperties(prefix = "spring.datasource.adw")
  public DataSource adwDataSource() {
    return DataSourceBuilder.create().type(HikariDataSource.class).build();
  }

  @Bean(name = "sessiondbDataSource")
  @ConfigurationProperties(prefix = "spring.datasource.sessiondb")
  public DataSource sessiondbDataSource() {
    return DataSourceBuilder.create().type(HikariDataSource.class).build();
  }

  @Bean(name = "logdbDataSource")
  @ConfigurationProperties(prefix = "spring.datasource.logdb")
  public DataSource logdbDataSource() {
    return DataSourceBuilder.create().type(HikariDataSource.class).build();
  }
}
