package com.hotwheelsnepal.util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import com.hotwheelsnepal.util.Constants;

/**
 * SessionUtil provides helper methods for managing HTTP sessions
 * throughout the HotWheels Nepal application.
 */
public class SessionUtil {

    /**
     * Retrieves a session attribute by name.
     *
     * @param request   the HTTP request
     * @param attribute the attribute name to retrieve
     * @return the attribute value, or null if not found
     */
    public static Object getAttribute(HttpServletRequest request, String attribute) {
        HttpSession session = request.getSession(false);
        if (session == null) return null;
        return session.getAttribute(attribute);
    }

    /**
     * Sets a session attribute.
     *
     * @param request   the HTTP request
     * @param attribute the attribute name
     * @param value     the value to store
     */
    public static void setAttribute(HttpServletRequest request, String attribute, Object value) {
        request.getSession(true).setAttribute(attribute, value);
    }

    /**
     * Sets a session attribute and configures the session inactivity timeout.
     *
     * @param request   the HTTP request
     * @param attribute the attribute name
     * @param value     the value to store
     * @param seconds   max inactive interval in seconds before the session expires
     */
    public static void setAttribute(HttpServletRequest request, String attribute, Object value, int seconds) {
        HttpSession session = request.getSession(true);
        session.setAttribute(attribute, value);
        session.setMaxInactiveInterval(seconds);
    }

    /**
     * Invalidates the current session, effectively logging out the user.
     *
     * @param request the HTTP request
     */
    public static void invalidateSession(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
    }

    /**
     * Checks whether a user is currently logged in.
     *
     * @param request the HTTP request
     * @return true if the user has an active session with a username, false otherwise
     */
    public static boolean isLoggedIn(HttpServletRequest request) {
        return getAttribute(request, Constants.SESSION_USERNAME) != null;
    }

    /**
     * Returns the role of the currently logged-in user.
     *
     * @param request the HTTP request
     * @return the role string ("admin" or "user"), or null if not logged in
     */
    public static String getRole(HttpServletRequest request) {
        Object role = getAttribute(request, Constants.SESSION_ROLE);
        return role != null ? role.toString() : null;
    }
}
