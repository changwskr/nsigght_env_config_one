package com.nh.nsight.common.config;

import javax.sql.DataSource;
import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.transaction.PlatformTransactionManager;

@Configuration
public class MyBatisConfig {

  @Primary
  @Bean(name = "rdwTransactionManager")
  public PlatformTransactionManager rdwTransactionManager(@Qualifier("rdwDataSource") DataSource ds) {
    DataSourceTransactionManager tm = new DataSourceTransactionManager(ds);
    tm.setDefaultTimeout(5);
    return tm;
  }

  @Primary
  @Bean(name = "rdwSqlSessionFactory")
  public SqlSessionFactory rdwSqlSessionFactory(@Qualifier("rdwDataSource") DataSource ds) throws Exception {
    return buildSessionFactory(ds, "classpath:/mapper/rdw/**/*.xml");
  }

  @Bean(name = "adwSqlSessionFactory")
  public SqlSessionFactory adwSqlSessionFactory(@Qualifier("adwDataSource") DataSource ds) throws Exception {
    return buildSessionFactory(ds, "classpath:/mapper/adw/**/*.xml");
  }

  private SqlSessionFactory buildSessionFactory(DataSource dataSource, String mapperLocation)
      throws Exception {
    SqlSessionFactoryBean factoryBean = new SqlSessionFactoryBean();
    factoryBean.setDataSource(dataSource);
    factoryBean.setMapperLocations(
        new PathMatchingResourcePatternResolver().getResources(mapperLocation));
    factoryBean.setTypeAliasesPackage("com.nh.nsight");
    return factoryBean.getObject();
  }
}
