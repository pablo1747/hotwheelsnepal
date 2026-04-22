package com.hotwheelsnepal.util;

import jakarta.servlet.http.HttpServletRequest;

/**
 * ValidationUtil provides reusable validation methods used across
 * the HotWheels Nepal application for input checking.
 */
public class ValidationUtil {

    /**
     * Reads a request parameter and returns it trimmed.
     * Returns an empty string (never null) if the parameter is absent.
     */
    public static String param(HttpServletRequest req, String name) {
        String value = req.getParameter(name);
        return value != null ? value.trim() : "";
    }

    /**
     * Checks if a string is null or empty after trimming.
     *
     * @param value the string to check
     * @return true if null or empty, false otherwise
     */
    public static boolean isNullOrEmpty(String value) {
        return value == null || value.trim().isEmpty();
    }

    /**
     * Validates that a string contains only alphabetic characters and spaces.
     * Used for name fields to prevent numeric input.
     *
     * @param value the string to validate
     * @return true if valid (letters and spaces only), false otherwise
     */
    public static boolean isValidName(String value) {
        if (isNullOrEmpty(value)) return false;
        return value.trim().matches("[a-zA-Z ]+");
    }

    /**
     * Validates a phone number: must be 10 digits (can start with +977).
     *
     * @param phone the phone number string
     * @return true if valid format, false otherwise
     */
    public static boolean isValidPhone(String phone) {
        if (isNullOrEmpty(phone)) return false;
        String digits = phone.trim().replaceAll("^\\+977", "");
        return digits.matches("\\d{10}");
    }

    /**
     * Validates an email address using a basic regex pattern.
     *
     * @param email the email to validate
     * @return true if valid format, false otherwise
     */
    public static boolean isValidEmail(String email) {
        if (isNullOrEmpty(email)) return false;
        return email.trim().matches("^[\\w._%+\\-]+@[\\w.\\-]+\\.[a-zA-Z]{2,}$");
    }

    /**
     * Validates a price string: must be a positive decimal number.
     *
     * @param priceStr the price string to validate
     * @return true if valid positive number, false otherwise
     */
    public static boolean isValidPrice(String priceStr) {
        try {
            double price = Double.parseDouble(priceStr);
            return price > 0;
        } catch (NumberFormatException e) {
            return false;
        }
    }

    /**
     * Validates a stock quantity string: must be a non-negative integer.
     *
     * @param stockStr the stock string to validate
     * @return true if valid non-negative integer, false otherwise
     */
    public static boolean isValidStock(String stockStr) {
        try {
            int stock = Integer.parseInt(stockStr);
            return stock >= 0;
        } catch (NumberFormatException e) {
            return false;
        }
    }

    /**
     * Validates a password: must be at least 8 characters long.
     *
     * @param password the password to validate
     * @return true if valid, false otherwise
     */
    public static boolean isValidPassword(String password) {
        return !isNullOrEmpty(password) && password.length() >= 8;
    }
}
