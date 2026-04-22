package com.hotwheelsnepal.util;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * CookieUtil provides helper methods for creating, reading, and deleting
 * HTTP cookies in the HotWheels Nepal application.
 */
public class CookieUtil {

    /**
     * Creates and adds a cookie to the response.
     *
     * @param response      the HTTP response
     * @param name          the cookie name
     * @param value         the cookie value
     * @param maxAgeSeconds how long the cookie persists in seconds
     */
    public static void addCookie(HttpServletResponse response, String name, String value, int maxAgeSeconds) {
        Cookie cookie = new Cookie(name, value);
        cookie.setPath("/");
        cookie.setMaxAge(maxAgeSeconds);
        cookie.setHttpOnly(true); // Prevents XSS access to the cookie
        // cookie.setSecure(true); // Uncomment when using HTTPS
        response.addCookie(cookie);
    }

    /**
     * Deletes a cookie by setting its max age to 0.
     *
     * @param response the HTTP response
     * @param name     the cookie name to delete
     */
    public static void deleteCookie(HttpServletResponse response, String name) {
        Cookie cookie = new Cookie(name, "");
        cookie.setPath("/");
        cookie.setMaxAge(0);
        response.addCookie(cookie);
    }

    /**
     * Retrieves a cookie value by name from the incoming request.
     *
     * @param request the HTTP request
     * @param name    the cookie name to look up
     * @return the cookie value, or null if not found
     */
    public static String getCookieValue(HttpServletRequest request, String name) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (name.equals(cookie.getName())) {
                    return cookie.getValue();
                }
            }
        }
        return null;
    }
}
