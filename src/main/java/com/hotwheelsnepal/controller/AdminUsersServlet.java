package com.hotwheelsnepal.controller;

import com.hotwheelsnepal.dao.UserDAO;
import com.hotwheelsnepal.model.UserModel;
import com.hotwheelsnepal.util.Constants;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(asyncSupported = true, urlPatterns = { "/AdminUsers" })
public class AdminUsersServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            UserDAO dao = new UserDAO();
            List<UserModel> users = dao.getAllUsers();
            request.setAttribute("users", users);
        } catch (Exception e) {
            request.setAttribute("error", "Failed to load users.");
        }
        request.getRequestDispatcher("/WEB-INF/pages/adminusers.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("toggleStatus".equals(action)) {
            try {
                int userId = Integer.parseInt(request.getParameter("userId"));
                String currentStatus = request.getParameter("currentStatus");
                String newStatus = Constants.STATUS_ACTIVE.equals(currentStatus)
                        ? Constants.STATUS_INACTIVE
                        : Constants.STATUS_ACTIVE;
                UserDAO dao = new UserDAO();
                boolean updated = dao.updateUserStatus(userId, newStatus);
                if (updated) {
                    request.setAttribute("success", "User status updated to " + newStatus + ".");
                } else {
                    request.setAttribute("error", "Failed to update user status.");
                }
            } catch (Exception e) {
                request.setAttribute("error", "Error updating user status.");
            }
        }
        doGet(request, response);
    }
}