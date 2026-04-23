package com.hotwheelsnepal.controller;

import com.hotwheelsnepal.util.Constants;
import com.hotwheelsnepal.util.CookieUtil;
import com.hotwheelsnepal.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(asyncSupported = true, urlPatterns = { "/logout" })
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Invalidate the session
        SessionUtil.invalidateSession(request);

        // Remove the last_login cookie from the browser
        CookieUtil.deleteCookie(response, Constants.COOKIE_LAST_LOGIN);

        response.sendRedirect(request.getContextPath() + Constants.URL_LOGIN);
    }
}
