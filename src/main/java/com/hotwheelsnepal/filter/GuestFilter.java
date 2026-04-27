package com.hotwheelsnepal.filter;

import java.io.IOException;

import com.hotwheelsnepal.util.Constants;
import com.hotwheelsnepal.util.SessionUtil;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Redirects already-logged-in users away from guest-only pages (login, register).
 * Also sets Cache-Control headers so the browser back button cannot show
 * protected pages after logout.
 *
 * Ported pattern from workshop (java_web_app) and adapted for HotWheels Nepal.
 */
@WebFilter(asyncSupported = true, urlPatterns = { "/login", "/Registration" })
public class GuestFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  req = (HttpServletRequest)  request;
        HttpServletResponse res = (HttpServletResponse) response;

        res.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        res.setHeader("Pragma", "no-cache");
        res.setDateHeader("Expires", 0);

        boolean isLoggedIn = SessionUtil.isLoggedIn(req);

        if (isLoggedIn) {
            String role = SessionUtil.getRole(req);
            if (Constants.ROLE_ADMIN.equals(role)) {
                res.sendRedirect(req.getContextPath() + Constants.URL_ADMIN_DASHBOARD);
            } else {
                res.sendRedirect(req.getContextPath() + Constants.URL_USER_DASHBOARD);
            }
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}
