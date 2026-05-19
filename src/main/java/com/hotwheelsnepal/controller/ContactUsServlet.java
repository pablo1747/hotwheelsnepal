package com.hotwheelsnepal.controller;

import com.hotwheelsnepal.model.UserModel;
import com.hotwheelsnepal.util.Constants;
import com.hotwheelsnepal.util.DbConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(asyncSupported = true, urlPatterns = { "/ContactUs" })
public class ContactUsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(ContactUsServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("WEB-INF/pages/contactus.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name    = request.getParameter("name");
        String email   = request.getParameter("email");
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");

        // Resolve optional user_id for logged-in users
        HttpSession session = request.getSession(false);
        UserModel loggedUser = session != null
                ? (UserModel) session.getAttribute(Constants.SESSION_LOGGED_USER)
                : null;

        String sql = "INSERT INTO contact_messages (user_id, name, email, subject, message) "
                   + "VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DbConfig.getDbConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            if (loggedUser != null) stmt.setInt(1, loggedUser.getUserId());
            else                    stmt.setNull(1, java.sql.Types.INTEGER);
            stmt.setString(2, name);
            stmt.setString(3, email);
            stmt.setString(4, subject);
            stmt.setString(5, message);
            stmt.executeUpdate();

            request.setAttribute("successMsg", "Your message has been sent. We will get back to you soon!");
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
            request.setAttribute("errorMsg", "Could not send your message. Please try again.");
        }

        request.getRequestDispatcher("WEB-INF/pages/contactus.jsp").forward(request, response);
    }
}
