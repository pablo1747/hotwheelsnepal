package com.hotwheelsnepal.service;

import com.hotwheelsnepal.dao.UserDAO;
import com.hotwheelsnepal.model.UserModel;
import com.hotwheelsnepal.util.PasswordUtil;

public class RegisterService {

    private final UserDAO userDAO = new UserDAO();

    public boolean registerUser(UserModel user) throws Exception {

        // Check username uniqueness
        if (userDAO.getUserByUsername(user.getUsername()) != null) {
            throw new IllegalArgumentException("Username already taken. Please choose a different one.");
        }

        // Check email uniqueness
        if (userDAO.getUserByEmail(user.getEmail()) != null) {
            throw new IllegalArgumentException("An account with this email already exists.");
        }

        // Check phone number uniqueness
        if (userDAO.getUserByPhone(user.getPhoneNumber()) != null) {
            throw new IllegalArgumentException("An account with this phone number already exists.");
        }

        // Hash the password before saving to the database
        String hashedPassword = PasswordUtil.hashPassword(user.getPassword());
        user.setPassword(hashedPassword);

        return userDAO.insertUser(user);
    }
}
