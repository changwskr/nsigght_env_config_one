package com.nh.nsight.config;

import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;

import javax.sql.DataSource;

/**
 * MyBatis SqlSessionFactory — RDW(Primary) / ADW 분리 (MONO Style)
 *
 * <p>Mapper XML 위치:
 * <ul>
 *   <li>classpath:/mapper/rdw/ (하위 모든 .xml) — RDW 쿼리</li>
 *   <li>classpath:/mapper/adw/ (하위 모든 .xml) — ADW 쿼리</li>
 * </ul>
 *
 * <p>Query Timeout: application-common.yml — default-statement-timeout 3초
 *
 * <p>Mapper 인터페이스 스캔: MyBatisMapperConfig 참고
 */
@Configuration
public class MyBatisConfig {

    /**
     * RDW용 SqlSessionFactory (Primary)
     * - DataSourceConfig.rdwDataSource 연결
     * - 업무 트랜잭션 Mapper 가 기본으로 사용
     */
    @Primary
    @Bean(name = "rdwSqlSessionFactory")
    public SqlSessionFactory rdwSqlSessionFactory(
            @Qualifier("rdwDataSource") DataSource rdwDataSource) throws Exception {
        return buildSessionFactory(rdwDataSource, "classpath:/mapper/rdw/**/*.xml");
    }

    /**
     * ADW용 SqlSessionFactory
     * - DataSourceConfig.adwDataSource 연결
     * - 분석·리포트 전용 Mapper 에 사용
     */
    @Bean(name = "adwSqlSessionFactory")
    public SqlSessionFactory adwSqlSessionFactory(
            @Qualifier("adwDataSource") DataSource adwDataSource) throws Exception {
        return buildSessionFactory(adwDataSource, "classpath:/mapper/adw/**/*.xml");
    }

    /**
     * SqlSessionFactory 공통 생성
     *
     * @param dataSource     RDW 또는 ADW DataSource
     * @param mapperLocation Mapper XML classpath 패턴
     */
    private SqlSessionFactory buildSessionFactory(DataSource dataSource, String mapperLocation)
            throws Exception {
        SqlSessionFactoryBean factoryBean = new SqlSessionFactoryBean();
        factoryBean.setDataSource(dataSource);
        factoryBean.setMapperLocations(
                new PathMatchingResourcePatternResolver().getResources(mapperLocation));
        // Type Alias — com.nh.nsight 패키지 DTO 자동 매핑
        factoryBean.setTypeAliasesPackage("com.nh.nsight");
        return factoryBean.getObject();
    }
}
