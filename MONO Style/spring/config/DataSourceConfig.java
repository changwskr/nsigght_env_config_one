package com.nh.nsight.config;

import com.zaxxer.hikari.HikariDataSource;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;

import javax.sql.DataSource;

/**
 * HikariCP RDW / ADW 이중 DataSource 구성 (MONO Style)
 *
 * <p>설정 바인딩: application-common.yml
 * <ul>
 *   <li>spring.datasource.rdw — OLTP Read/Write (Primary)</li>
 *   <li>spring.datasource.adw — Analytics Read-only</li>
 * </ul>
 *
 * <p>연동: MyBatisConfig 에서 rdwSqlSessionFactory / adwSqlSessionFactory 가 각각 참조
 */
@Configuration
public class DataSourceConfig {

    /**
     * RDW DataSource (Primary)
     * - 일반 업무 트랜잭션·CRUD 에 사용
     * - @Primary : DataSource 단일 주입 시 기본값
     * - Pool 설정: maximum-pool-size 200, connection-timeout 3초 (32C/256GB 기준)
     */
    @Primary
    @Bean(name = "rdwDataSource")
    @ConfigurationProperties(prefix = "spring.datasource.rdw")
    public DataSource rdwDataSource() {
        return DataSourceBuilder.create()
                .type(HikariDataSource.class)
                .build();
    }

    /**
     * ADW DataSource (Analytics)
     * - 리포트·통계·대량 조회 등 Read-only 용도
     * - hikari.read-only: true (application-common.yml)
     * - Pool 설정: maximum-pool-size 128
     */
    @Bean(name = "adwDataSource")
    @ConfigurationProperties(prefix = "spring.datasource.adw")
    public DataSource adwDataSource() {
        return DataSourceBuilder.create()
                .type(HikariDataSource.class)
                .build();
    }
}
