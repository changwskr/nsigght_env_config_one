package com.nh.nsight.common.session;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.Instant;

public class AbsoluteSessionTimeoutFilter implements Filter {

  private static final String LOGIN_TIME = "NSIGHT_LOGIN_TIME";
  private final long absoluteTimeoutSeconds;

  public AbsoluteSessionTimeoutFilter(int absoluteTimeoutMinutes) {
    this.absoluteTimeoutSeconds = (long) absoluteTimeoutMinutes * 60;
  }

  @Override
  public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
      throws IOException, ServletException {
    HttpServletRequest req = (HttpServletRequest) request;
    HttpServletResponse res = (HttpServletResponse) response;
    HttpSession session = req.getSession(false);
    if (session != null) {
      Object loginTime = session.getAttribute(LOGIN_TIME);
      if (loginTime == null) {
        session.setAttribute(LOGIN_TIME, Instant.now().getEpochSecond());
      } else if (Instant.now().getEpochSecond() - (Long) loginTime > absoluteTimeoutSeconds) {
        session.invalidate();
        res.sendError(HttpServletResponse.SC_UNAUTHORIZED, "ABSOLUTE_SESSION_TIMEOUT");
        return;
      }
    }
    chain.doFilter(request, response);
  }
}
