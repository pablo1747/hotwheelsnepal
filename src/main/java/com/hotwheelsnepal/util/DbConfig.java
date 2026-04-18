package com.hotwheelsnepal.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * DbConfig provides a centralized database connection for the HotWheels Nepal application.
 * Manages JDBC connections to the MySQL database.
 */
public class DbConfig {

    private static final String DB_NAME = "hotwheelsnepal";
    private static final String URL = "jdbc:mysql://127.0.0.1:3306/" + DB_NAME
            + "?serverTimezone=UTC&useSSL=false&allowPublicKeyRetrieval=true";
    private static final String USERNAME = "root";
    private static final String PASSWORD = "";

    /**
     * Establishes and returns a connection to the MySQL database.
     *
     * @return Connection object for the database
     * @throws SQLException           if a database access error occurs
     * @throws ClassNotFoundException if the JDBC driver class is not found
     */
    public static Connection getDbConnection() throws SQLException, ClassNotFoundException {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }
}
