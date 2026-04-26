package com.hotwheelsnepal.service;

import com.hotwheelsnepal.dao.UserDAO;
import com.hotwheelsnepal.model.UserModel;
import com.hotwheelsnepal.util.Constants;
import com.hotwheelsnepal.util.PasswordUtil;
import com.hotwheelsnepal.util.ValidationUtil;

public class LoginService {

    private final UserDAO userDAO = new UserDAO();

    public UserModel authenticate(String username, String password) throws Exception {

        // Validate fields not empty
        if (ValidationUtil.isNullOrEmpty(username)) {
            throw new IllegalArgumentException("Username is required.");
        }
        if (ValidationUtil.isNullOrEmpty(password)) {
            throw new IllegalArgumentException("Password is required.");
        }

        // Fetch user from database
        UserModel user = userDAO.getUserByUsername(username.trim());
        if (user == null) {
            throw new IllegalArgumentException("No account found with that username.");
        }

        // Verify password
        boolean isMatch = PasswordUtil.checkPassword(password, user.getPassword());
        if (!isMatch) {
            throw new IllegalArgumentException("Incorrect password. Please try again.");
        }

        // Block inactive accounts (new registrations or admin-deactivated)
        if (Constants.STATUS_INACTIVE.equals(user.getStatus())) {
            throw new IllegalArgumentException("Your account is pending admin approval. Please wait for an administrator to activate your account.");
        }

        return user;
    }
}