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

@WebFilter(asyncSupported = true, urlPatterns = "/*")
public class AuthenticationFilter implements Filter {

    private static final String LOGIN           = "/login";
    private static final String REGISTRATION    = "/Registration";
    private static final String HOME            = "/Home";
    private static final String ROOT            = "/";
    private static final String SHOP            = "/Shop";
    private static final String ABOUT_US        = "/AboutUs";
    private static final String CONTACT_US      = "/ContactUs";
    private static final String CART            = "/Cart";
    private static final String CHECKOUT        = "/Checkout";

    private static final String USER_DASHBOARD   = "/UserDashboard";
    private static final String ADMIN_DASHBOARD  = "/AdminDashboard";
    private static final String EDIT_PROFILE     = "/EditProfile";
    private static final String ADMIN_PRODUCTS   = "/AdminProducts";
    private static final String ADMIN_USERS      = "/AdminUsers";
    private static final String ADD_PRODUCT      = "/AddProduct";
    private static final String EDIT_PRODUCT     = "/EditProduct";
    private static final String DELETE_PRODUCT   = "/DeleteProduct";

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req  = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String uri         = req.getRequestURI();
        String contextPath = req.getContextPath();
        String path        = uri.substring(contextPath.length());

        // Allow static resources
        if (path.matches(".*\\.(css|js|png|jpg|jpeg|gif|ico|avif|webp|woff2?|ttf|svg)$")) {
            chain.doFilter(request, response);
            return;
        }

        boolean isLoggedIn = SessionUtil.isLoggedIn(req);
        String  role       = SessionUtil.getRole(req);

        boolean isPublicPage = path.equalsIgnoreCase(LOGIN)
                || path.equalsIgnoreCase(REGISTRATION)
                || path.equalsIgnoreCase(HOME)
                || path.equalsIgnoreCase(ROOT)
                || path.equalsIgnoreCase(SHOP)
                || path.equalsIgnoreCase(ABOUT_US)
                || path.equalsIgnoreCase(CONTACT_US)
                || path.equalsIgnoreCase(CART)
                || path.equalsIgnoreCase(CHECKOUT)
                || path.equalsIgnoreCase("/Error")
                || path.equalsIgnoreCase("/Sanjeev")
                || path.equalsIgnoreCase("/Pratik")
                || path.equalsIgnoreCase("/Aryan")
                || path.equalsIgnoreCase("/Rochan")
                || path.equalsIgnoreCase("/Rojan")
                || path.equalsIgnoreCase("/logout")
                || path.startsWith("/images/")
                || path.startsWith("/css/");

        boolean isProtectedUserPage = path.equalsIgnoreCase(EDIT_PROFILE)
                || path.equalsIgnoreCase(USER_DASHBOARD);

        boolean isAdminOnlyPage = path.equalsIgnoreCase(ADMIN_DASHBOARD)
                || path.equalsIgnoreCase(ADMIN_PRODUCTS)
                || path.equalsIgnoreCase(ADMIN_USERS)
                || path.equalsIgnoreCase(ADD_PRODUCT)
                || path.equalsIgnoreCase(EDIT_PRODUCT)
                || path.equalsIgnoreCase(DELETE_PRODUCT)
                || path.startsWith("/admin");

        // Redirect already logged in users away from login/register
        if (isLoggedIn && (path.equalsIgnoreCase(LOGIN) || path.equalsIgnoreCase(REGISTRATION))) {
            if (Constants.ROLE_ADMIN.equals(role)) {
                res.sendRedirect(contextPath + ADMIN_DASHBOARD);
            } else {
                res.sendRedirect(contextPath + Constants.URL_USER_DASHBOARD);
            }
            return;
        }

        // Allow public pages
        if (isPublicPage) {
            chain.doFilter(request, response);
            return;
        }

        // Not logged in — only block KNOWN protected paths; unknown paths pass through
        // so Tomcat can generate a 404 routed to the custom error page.
        if (!isLoggedIn) {
            if (isProtectedUserPage || isAdminOnlyPage) {
                res.sendRedirect(contextPath + LOGIN);
                return;
            }
            // Unknown path — let Tomcat handle it (will 404 → error page)
            chain.doFilter(request, response);
            return;
        }

        // Admin only pages - block regular users
        if (isAdminOnlyPage && !Constants.ROLE_ADMIN.equals(role)) {
            res.sendRedirect(contextPath + Constants.URL_USER_DASHBOARD);
            return;
        }

        // Redirect admin away from user dashboard back to admin dashboard
        if (path.equalsIgnoreCase(USER_DASHBOARD) && Constants.ROLE_ADMIN.equals(role)) {
            res.sendRedirect(contextPath + ADMIN_DASHBOARD);
            return;
        }

        // Prevent browser from caching protected pages — back button after logout re-hits server
        res.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        res.setHeader("Pragma", "no-cache");
        res.setDateHeader("Expires", 0);

        // All checks passed
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}