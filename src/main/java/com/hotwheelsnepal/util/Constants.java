package com.hotwheelsnepal.util;

public final class Constants {

    private Constants() {}

    // Roles
    public static final String ROLE_ADMIN = "admin";
    public static final String ROLE_USER  = "user";

    // User status
    public static final String STATUS_ACTIVE   = "active";
    public static final String STATUS_INACTIVE = "inactive";

    // Session attribute keys
    public static final String SESSION_USERNAME    = "username";
    public static final String SESSION_FIRST_NAME  = "firstName";
    public static final String SESSION_LAST_NAME   = "lastName";
    public static final String SESSION_EMAIL       = "email";
    public static final String SESSION_PHONE       = "phone";
    public static final String SESSION_ROLE        = "role";
    public static final String SESSION_LOGGED_USER = "loggedUser";
    public static final String SESSION_IMAGE_PATH  = "imagePath";

    // Cookie names
    public static final String COOKIE_LAST_LOGIN = "last_login";

    // URL paths
    public static final String URL_LOGIN           = "/login";
    public static final String URL_USER_DASHBOARD  = "/UserDashboard";
    public static final String URL_ADMIN_DASHBOARD = "/AdminDashboard";
}
