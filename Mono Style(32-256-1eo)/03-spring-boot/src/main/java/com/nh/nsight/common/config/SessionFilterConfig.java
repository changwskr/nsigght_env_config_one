package com.nh.nsight.common.config;

import com.nh.nsight.common.session.AbsoluteSessionTimeoutFilter;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.Ordered;

@Configuration
public class SessionFilterConfig {

  @Bean
  public FilterRegistrationBean<AbsoluteSessionTimeoutFilter> absoluteSessionTimeoutFilter(
      @Value("${nsight.session.absolute-timeout-minutes:480}") int absoluteTimeoutMinutes) {
    FilterRegistrationBean<AbsoluteSessionTimeoutFilter> registration =
        new FilterRegistrationBean<>(new AbsoluteSessionTimeoutFilter(absoluteTimeoutMinutes));
    registration.addUrlPatterns("/*");
    registration.setOrder(Ordered.HIGHEST_PRECEDENCE + 10);
    registration.setName("absoluteSessionTimeoutFilter");
    return registration;
  }
}
