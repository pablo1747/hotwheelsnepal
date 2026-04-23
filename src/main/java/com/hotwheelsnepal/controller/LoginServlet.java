package com.hotwheelsnepal.controller;

import com.hotwheelsnepal.model.UserModel;
import com.hotwheelsnepal.service.LoginService;
import com.hotwheelsnepal.util.Constants;
import com.hotwheelsnepal.util.CookieUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(asyncSupported = true, urlPatterns = { "/login" })
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(LoginServlet.class.getName());

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Pass last_login cookie value to JSP so it can be displayed
        String lastLogin = CookieUtil.getCookieValue(request, Constants.COOKIE_LAST_LOGIN);
        if (lastLogin != null) {
            request.setAttribute("lastLogin", lastLogin.replace("_", " "));
        }
        // Retain registered=true message from redirect
        if ("true".equals(request.getParameter("registered"))) {
            request.setAttribute("successMessage", "Registration successful! Your account is pending admin approval. You will be able to log in once an administrator activates your account.");
        }
        request.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            LoginService loginService = new LoginService();
            UserModel user = loginService.authenticate(username, password);

            if (user != null) {
                // Store individual session attributes (used by filter and JSPs)
                request.getSession().setAttribute(Constants.SESSION_USERNAME,    user.getUsername());
                request.getSession().setAttribute(Constants.SESSION_FIRST_NAME,  user.getFirstName());
                request.getSession().setAttribute(Constants.SESSION_LAST_NAME,   user.getLastName());
                request.getSession().setAttribute(Constants.SESSION_EMAIL,       user.getEmail());
                request.getSession().setAttribute(Constants.SESSION_PHONE,       user.getPhoneNumber());
                request.getSession().setAttribute(Constants.SESSION_ROLE,        user.getRole());
                request.getSession().setAttribute(Constants.SESSION_IMAGE_PATH,  user.getImagePath());

                // Store full user object for dashboard use
                request.getSession().setAttribute(Constants.SESSION_LOGGED_USER, user);

                // Clear any cart left over from a previous user's session
                request.getSession().removeAttribute("cart");

                // Record last login time as a cookie (expires in 30 days)
                String loginTime = LocalDateTime.now()
                        .format(DateTimeFormatter.ofPattern("yyyy-MM-dd_HH:mm:ss"));
                CookieUtil.addCookie(response, Constants.COOKIE_LAST_LOGIN, loginTime, 60 * 60 * 24 * 30);

                // Redirect to intended destination if set (e.g. checkout triggered login)
                String redirect = (String) request.getSession().getAttribute("redirectAfterLogin");
                if (redirect != null) {
                    request.getSession().removeAttribute("redirectAfterLogin");
                    response.sendRedirect(request.getContextPath() + redirect);
                } else if (Constants.ROLE_ADMIN.equals(user.getRole())) {
                    response.sendRedirect(request.getContextPath() + Constants.URL_ADMIN_DASHBOARD);
                } else {
                    response.sendRedirect(request.getContextPath() + Constants.URL_USER_DASHBOARD);
                }
            } else {
                request.setAttribute("errorMessage", "Invalid username or password.");
                request.setAttribute("typedUser", username);
                request.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(request, response);
            }

        } catch (IllegalArgumentException e) {
            request.setAttribute("errorMessage", e.getMessage());
            request.setAttribute("typedUser", username);
            request.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
            request.setAttribute("errorMessage", "Something went wrong. Please try again.");
            request.setAttribute("typedUser", username);
            request.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(request, response);
        }
    }
}
