package com.nh.nsight.config;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.context.annotation.Configuration;

/**
 * MyBatis Mapper 인터페이스 스캔 설정 (MONO Style)
 *
 * <p>RDW / ADW Mapper 를 SqlSessionFactory 별로 분리 스캔.
 * MyBatisConfig 의 Factory Bean 이름과 sqlSessionFactoryRef 가 일치해야 함.
 *
 * <p>Mapper 패키지 규칙:
 * <ul>
 *   <li>com.nh.nsight.mapper.rdw — RDW(OLTP) Mapper</li>
 *   <li>com.nh.nsight.mapper.adw — ADW(Analytics) Mapper</li>
 * </ul>
 */

/**
 * RDW Mapper 스캔 — rdwSqlSessionFactory 에 바인딩
 */
@Configuration
@MapperScan(basePackages = "com.nh.nsight.mapper.rdw", sqlSessionFactoryRef = "rdwSqlSessionFactory")
class RdwMapperScanConfig {
}

/**
 * ADW Mapper 스캔 — adwSqlSessionFactory 에 바인딩
 */
@Configuration
@MapperScan(basePackages = "com.nh.nsight.mapper.adw", sqlSessionFactoryRef = "adwSqlSessionFactory")
class AdwMapperScanConfig {
}
