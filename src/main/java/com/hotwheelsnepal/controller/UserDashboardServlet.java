package com.hotwheelsnepal.controller;

import com.hotwheelsnepal.dao.OrderDAO;
import com.hotwheelsnepal.model.UserModel;
import com.hotwheelsnepal.util.Constants;
import com.hotwheelsnepal.util.CookieUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(asyncSupported = true, urlPatterns = { "/UserDashboard" })
public class UserDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Read the last_login cookie and pass it to the JSP
        String lastLogin = CookieUtil.getCookieValue(request, Constants.COOKIE_LAST_LOGIN);
        if (lastLogin != null) {
            request.setAttribute("lastLogin", lastLogin.replace("_", " "));
        }

        // Real stats
        jakarta.servlet.http.HttpSession sess = request.getSession(false);
        UserModel loggedUser = sess != null
                ? (UserModel) sess.getAttribute(Constants.SESSION_LOGGED_USER)
                : null;
        int totalOrders = 0;
        if (loggedUser != null) {
            totalOrders = new OrderDAO().getOrderCountByUser(loggedUser.getUserId());
        }

        @SuppressWarnings("unchecked")
        List<?> cart = sess != null ? (List<?>) sess.getAttribute("cart") : null;
        int cartCount = cart != null ? cart.size() : 0;

        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("cartCount",   cartCount);

        request.getRequestDispatcher("/WEB-INF/pages/userdashboard.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
