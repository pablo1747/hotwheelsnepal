package com.hotwheelsnepal.controller;

import com.hotwheelsnepal.dao.UserDAO;
import com.hotwheelsnepal.model.UserModel;
import com.hotwheelsnepal.util.Constants;
import com.hotwheelsnepal.util.FileUploadUtil;
import com.hotwheelsnepal.util.PasswordUtil;
import com.hotwheelsnepal.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.time.LocalDate;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(asyncSupported = true, urlPatterns = { "/EditProfile" })
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize       = 1024 * 1024 * 5,
    maxRequestSize    = 1024 * 1024 * 20
)
public class EditProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(EditProfileServlet.class.getName());

    private static final String UPLOAD_SUBDIR = "images" + File.separator + "users";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute(Constants.SESSION_USERNAME) == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Load fresh user data from DB
        try {
            String username = (String) session.getAttribute(Constants.SESSION_USERNAME);
            UserDAO dao = new UserDAO();
            UserModel user = dao.getUserByUsername(username);
            request.setAttribute("user", user);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
        }

        request.getRequestDispatcher("/WEB-INF/pages/editprofile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute(Constants.SESSION_USERNAME) == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String username  = (String) session.getAttribute(Constants.SESSION_USERNAME);
        String firstName = ValidationUtil.param(request, "firstName");
        String lastName  = ValidationUtil.param(request, "lastName");
        String phone     = ValidationUtil.param(request, "phoneNumber");
        String gender    = ValidationUtil.param(request, "gender");
        String dobStr    = ValidationUtil.param(request, "dob");
        String newPass   = ValidationUtil.param(request, "newPassword");
        String confirmPass = ValidationUtil.param(request, "confirmPassword");

        boolean hasError = false;

        if (!ValidationUtil.isValidName(firstName)) {
            request.setAttribute("errFirstName",
                ValidationUtil.isNullOrEmpty(firstName) ? "First name is required."
                    : "First name must contain letters only.");
            hasError = true;
        }
        if (!ValidationUtil.isValidName(lastName)) {
            request.setAttribute("errLastName",
                ValidationUtil.isNullOrEmpty(lastName) ? "Last name is required."
                    : "Last name must contain letters only.");
            hasError = true;
        }
        if (!ValidationUtil.isValidPhone(phone)) {
            request.setAttribute("errPhone",
                ValidationUtil.isNullOrEmpty(phone) ? "Phone number is required."
                    : "Enter a valid 10-digit phone number.");
            hasError = true;
        }

        // Password change is optional — only validate if they typed something
        String hashedPassword = null;
        if (!ValidationUtil.isNullOrEmpty(newPass)) {
            if (!ValidationUtil.isValidPassword(newPass)) {
                request.setAttribute("errPassword", "Password must be at least 8 characters.");
                hasError = true;
            } else if (!newPass.equals(confirmPass)) {
                request.setAttribute("errConfirm", "Passwords do not match.");
                hasError = true;
            } else {
                hashedPassword = PasswordUtil.hashPassword(newPass);
            }
        }

        LocalDate dob = null;
        if (!ValidationUtil.isNullOrEmpty(dobStr)) {
            try {
                dob = LocalDate.parse(dobStr);
            } catch (Exception ignored) {}
        }

        if (hasError) {
            forwardWithUser(request, response, username, firstName, lastName, phone, gender, dobStr);
            return;
        }

        // Handle profile picture upload
        String newImagePath = null;
        try {
            Part imagePart = request.getPart("profileImage");
            if (imagePart != null && imagePart.getSize() > 0) {
                if (!FileUploadUtil.isImage(imagePart)) {
                    request.setAttribute("errImage", "Profile picture must be a valid image file.");
                    forwardWithUser(request, response, username, firstName, lastName, phone, gender, dobStr);
                    return;
                }
                String ext      = FileUploadUtil.getFileExtension(imagePart.getSubmittedFileName());
                String fileName = username + "_" + System.currentTimeMillis() + ext;
                String uploadDir = getServletContext().getRealPath("/") + UPLOAD_SUBDIR;
                FileUploadUtil.saveFile(imagePart, uploadDir, fileName);
                newImagePath = "images/users/" + fileName;
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
        }

        try {
            UserDAO dao = new UserDAO();
            UserModel current = dao.getUserByUsername(username);
            if (current == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            dao.updateProfile(current.getUserId(), firstName, lastName,
                              phone, gender, dob, newImagePath, hashedPassword);

            // Refresh session with updated values
            session.setAttribute(Constants.SESSION_FIRST_NAME, firstName);
            session.setAttribute(Constants.SESSION_LAST_NAME,  lastName);
            session.setAttribute(Constants.SESSION_PHONE,      phone);
            if (newImagePath != null) {
                session.setAttribute(Constants.SESSION_IMAGE_PATH, newImagePath);
            }

            // Refresh the full user object in session
            UserModel updated = dao.getUserByUsername(username);
            session.setAttribute(Constants.SESSION_LOGGED_USER, updated);

            // Redirect back to the right dashboard with success flag
            String role = (String) session.getAttribute(Constants.SESSION_ROLE);
            if (Constants.ROLE_ADMIN.equals(role)) {
                response.sendRedirect(request.getContextPath() + "/AdminDashboard?profileUpdated=true");
            } else {
                response.sendRedirect(request.getContextPath() + "/UserDashboard?profileUpdated=true");
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
            request.setAttribute("errorMessage", "Could not save changes. Please try again.");
            forwardWithUser(request, response, username, firstName, lastName, phone, gender, dobStr);
        }
    }

    private void forwardWithUser(HttpServletRequest request, HttpServletResponse response,
                                 String username, String firstName, String lastName,
                                 String phone, String gender, String dobStr)
            throws ServletException, IOException {
        try {
            UserModel user = new UserDAO().getUserByUsername(username);
            request.setAttribute("user", user);
        } catch (Exception ignored) {}
        request.setAttribute("valFirstName", firstName);
        request.setAttribute("valLastName",  lastName);
        request.setAttribute("valPhone",     phone);
        request.setAttribute("valGender",    gender);
        request.setAttribute("valDob",       dobStr);
        request.getRequestDispatcher("/WEB-INF/pages/editprofile.jsp").forward(request, response);
    }
}
