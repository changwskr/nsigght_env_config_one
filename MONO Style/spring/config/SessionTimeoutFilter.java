package com.nh.nsight.config;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.time.Instant;

/**
 * Absolute Session 8시간 강제 만료 Filter (MONO Style)
 *
 * <p>세션 만료 정책 (이중 적용):
 * <ul>
 *   <li>Idle Timeout 60분 — server.servlet.session.timeout / web.xml session-timeout</li>
 *   <li>Absolute Timeout 8시간 — 본 Filter (nsight.session.absolute-timeout-hours)</li>
 * </ul>
 *
 * <p>MONO Style 은 Tomcat DeltaManager 로 세션 복제.
 * Spring Session JDBC 는 사용하지 않으며, HttpSession 기반으로 동작.
 *
 * <p>설정: application-common.yml {@code nsight.session.absolute-timeout-hours: 8}
 */
@Component
public class SessionTimeoutFilter implements Filter {

    /** 세션 최초 생성 시각을 저장하는 HttpSession 속성명 */
    private static final String SESSION_START_ATTR = "NSIGHT_SESSION_START";

    /** Absolute Session 만료 시간(시간). 기본값 8시간 */
    @Value("${nsight.session.absolute-timeout-hours:8}")
    private int absoluteTimeoutHours;

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        // 기존 세션이 있을 때만 검사 (없으면 신규 생성하지 않음)
        HttpSession session = httpRequest.getSession(false);

        if (session != null) {
            Long startMillis = (Long) session.getAttribute(SESSION_START_ATTR);

            if (startMillis == null) {
                // 최초 요청 — 세션 시작 시각 기록
                session.setAttribute(SESSION_START_ATTR, Instant.now().toEpochMilli());
            } else {
                // 경과 시간(시간) 계산 — 8시간 초과 시 세션 강제 만료
                long elapsedHours = (Instant.now().toEpochMilli() - startMillis) / (1000 * 60 * 60);
                if (elapsedHours >= absoluteTimeoutHours) {
                    session.invalidate();
                }
            }
        }

        chain.doFilter(request, response);
    }
}
