package com.hotwheelsnepal.controller;

import com.hotwheelsnepal.model.UserModel;
import com.hotwheelsnepal.service.RegisterService;
import com.hotwheelsnepal.util.FileUploadUtil;
import com.hotwheelsnepal.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.time.LocalDate;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(asyncSupported = true, urlPatterns = { "/Registration" })
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,        // 1 MB — buffer in memory before writing to disk
    maxFileSize       = 1024 * 1024 * 5,    // 5 MB max single file
    maxRequestSize    = 1024 * 1024 * 20    // 20 MB max total request
)
public class RegistrationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(RegistrationServlet.class.getName());

    /** Directory (relative to webapp root) where profile images are stored. */
    private static final String UPLOAD_SUBDIR = "images" + File.separator + "users";

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/pages/registration.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ── 1. Read all form parameters ──────────────────────────────────────
        String firstName  = ValidationUtil.param(request, "firstName");
        String lastName   = ValidationUtil.param(request, "lastName");
        String username   = ValidationUtil.param(request, "username");
        String dobStr     = ValidationUtil.param(request, "dob");
        String gender     = ValidationUtil.param(request, "gender");
        String email      = ValidationUtil.param(request, "email");
        String phone      = ValidationUtil.param(request, "phoneNumber");
        String password   = ValidationUtil.param(request, "password");
        String rePassword = ValidationUtil.param(request, "rePassword");

        boolean hasError = false;

        // ── 2. Field-level validation ────────────────────────────────────────

        // First name – letters and spaces only
        if (!ValidationUtil.isValidName(firstName)) {
            request.setAttribute("errFirstName",
                ValidationUtil.isNullOrEmpty(firstName)
                    ? "First name is required."
                    : "First name must contain letters only (no numbers or symbols).");
            hasError = true;
        }

        // Last name – letters and spaces only
        if (!ValidationUtil.isValidName(lastName)) {
            request.setAttribute("errLastName",
                ValidationUtil.isNullOrEmpty(lastName)
                    ? "Last name is required."
                    : "Last name must contain letters only (no numbers or symbols).");
            hasError = true;
        }

        // Username – not empty
        if (ValidationUtil.isNullOrEmpty(username)) {
            request.setAttribute("errUsername", "Username is required.");
            hasError = true;
        }

        // Date of birth – required and parseable
        LocalDate dob = null;
        if (ValidationUtil.isNullOrEmpty(dobStr)) {
            request.setAttribute("errDob", "Date of birth is required.");
            hasError = true;
        } else {
            try {
                dob = LocalDate.parse(dobStr);
                if (dob.isAfter(LocalDate.now())) {
                    request.setAttribute("errDob", "Date of birth cannot be in the future.");
                    hasError = true;
                }
            } catch (Exception e) {
                request.setAttribute("errDob", "Invalid date format.");
                hasError = true;
            }
        }

        // Email – valid format
        if (!ValidationUtil.isValidEmail(email)) {
            request.setAttribute("errEmail",
                ValidationUtil.isNullOrEmpty(email)
                    ? "Email address is required."
                    : "Please enter a valid email address (e.g. name@example.com).");
            hasError = true;
        }

        // Phone – valid Nepali/10-digit format
        if (!ValidationUtil.isValidPhone(phone)) {
            request.setAttribute("errPhone",
                ValidationUtil.isNullOrEmpty(phone)
                    ? "Phone number is required."
                    : "Phone must be a valid 10-digit number (optionally starting with +977).");
            hasError = true;
        }

        // Password – minimum 8 characters
        if (!ValidationUtil.isValidPassword(password)) {
            request.setAttribute("errPassword",
                ValidationUtil.isNullOrEmpty(password)
                    ? "Password is required."
                    : "Password must be at least 8 characters long.");
            hasError = true;
        }

        // Re-password – must match (only check if password itself passed validation)
        if (!ValidationUtil.isNullOrEmpty(password) && !password.equals(rePassword)) {
            request.setAttribute("errRePassword", "Passwords do not match.");
            hasError = true;
        }

        // ── 3. Re-populate form on validation failure ────────────────────────
        if (hasError) {
            request.setAttribute("valFirstName", firstName);
            request.setAttribute("valLastName",  lastName);
            request.setAttribute("valUsername",  username);
            request.setAttribute("valDob",       dobStr);
            request.setAttribute("valGender",    gender);
            request.setAttribute("valEmail",     email);
            request.setAttribute("valPhone",     phone);
            request.getRequestDispatcher("/WEB-INF/pages/registration.jsp").forward(request, response);
            return;
        }

        // ── 4. Handle optional profile image upload ──────────────────────────
        String imagePath = null;
        try {
            Part imagePart = request.getPart("profileImage");
            if (imagePart != null && imagePart.getSize() > 0) {
                if (!FileUploadUtil.isImage(imagePart)) {
                    request.setAttribute("errImage",
                        "Profile picture must be a valid image file (jpg, png, gif, etc.).");
                    request.setAttribute("valFirstName", firstName);
                    request.setAttribute("valLastName",  lastName);
                    request.setAttribute("valUsername",  username);
                    request.setAttribute("valDob",       dobStr);
                    request.setAttribute("valGender",    gender);
                    request.setAttribute("valEmail",     email);
                    request.setAttribute("valPhone",     phone);
                    request.getRequestDispatcher("/WEB-INF/pages/registration.jsp").forward(request, response);
                    return;
                }
                String ext      = FileUploadUtil.getFileExtension(imagePart.getSubmittedFileName());
                String fileName = FileUploadUtil.buildFileName(username, ext);
                String uploadDir = getServletContext().getRealPath("/") + UPLOAD_SUBDIR;
                FileUploadUtil.saveFile(imagePart, uploadDir, fileName);
                imagePath = "images/users/" + fileName;
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
            // Image upload failure is non-fatal; proceed without image
        }

        // ── 5. Build model and register ──────────────────────────────────────
        UserModel user = new UserModel(
            firstName, lastName, username,
            dob, gender, email, phone, password, imagePath
        );

        try {
            RegisterService service = new RegisterService();
            boolean success = service.registerUser(user);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/login?registered=true");
            } else {
                request.setAttribute("errorMessage", "Registration failed. Please try again.");
                request.getRequestDispatcher("/WEB-INF/pages/registration.jsp").forward(request, response);
            }

        } catch (IllegalArgumentException e) {
            // Duplicate username / email / phone from RegisterService
            request.setAttribute("errorMessage", e.getMessage());
            request.setAttribute("valFirstName", firstName);
            request.setAttribute("valLastName",  lastName);
            request.setAttribute("valUsername",  username);
            request.setAttribute("valDob",       dobStr);
            request.setAttribute("valGender",    gender);
            request.setAttribute("valEmail",     email);
            request.setAttribute("valPhone",     phone);
            request.getRequestDispatcher("/WEB-INF/pages/registration.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
            request.setAttribute("errorMessage", "An unexpected error occurred. Please try again.");
            request.getRequestDispatcher("/WEB-INF/pages/registration.jsp").forward(request, response);
        }
    }
}
