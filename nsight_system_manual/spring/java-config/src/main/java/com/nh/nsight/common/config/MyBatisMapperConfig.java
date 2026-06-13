package com.nh.nsight.common.config;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.context.annotation.Configuration;

@Configuration
@MapperScan(basePackages = "com.nh.nsight.mapper.rdw", sqlSessionFactoryRef = "rdwSqlSessionFactory")
class RdwMapperScanConfig {
}

@Configuration
@MapperScan(basePackages = "com.nh.nsight.mapper.adw", sqlSessionFactoryRef = "adwSqlSessionFactory")
class AdwMapperScanConfig {
}
