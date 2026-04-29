package com.hotwheelsnepal.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.hotwheelsnepal.model.UserModel;
import com.hotwheelsnepal.util.Constants;
import com.hotwheelsnepal.util.DbConfig;

/**
 * UserDAO handles all database operations related to users in the
 * HotWheels Nepal application (CRUD + lookup).
 */
public class UserDAO {

    private static final Logger LOGGER = Logger.getLogger(UserDAO.class.getName());

    private Connection dbConn;
    private boolean isConnectionError = false;

    /**
     * Constructor initializes the database connection.
     */
    public UserDAO() {
        try {
            dbConn = DbConfig.getDbConnection();
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
            isConnectionError = true;
        }
    }

    /**
     * Retrieves a user from the database by username.
     *
     * @param username the username to search for
     * @return UserModel object if found, null otherwise
     * @throws Exception if a database error occurs
     */
    public UserModel getUserByUsername(String username) throws Exception {
        if (isConnectionError) return null;
        String query = "SELECT * FROM users WHERE username = ?";
        try (PreparedStatement stmt = dbConn.prepareStatement(query)) {
            stmt.setString(1, username);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        }
        return null;
    }

    /**
     * Retrieves a user from the database by user ID.
     *
     * @param userId the user's primary key
     * @return UserModel object if found, null otherwise
     * @throws Exception if a database error occurs
     */
    public UserModel getUserById(int userId) throws Exception {
        if (isConnectionError) return null;
        String query = "SELECT * FROM users WHERE user_id = ?";
        try (PreparedStatement stmt = dbConn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        }
        return null;
    }

    /**
     * Retrieves a user from the database by phone number.
     * Used during registration to enforce phone number uniqueness.
     *
     * @param phone the phone number to search for
     * @return UserModel if found, null otherwise
     * @throws Exception if a database error occurs
     */
    public UserModel getUserByPhone(String phone) throws Exception {
        if (isConnectionError) return null;
        String query = "SELECT * FROM users WHERE phone_number = ?";
        try (PreparedStatement stmt = dbConn.prepareStatement(query)) {
            stmt.setString(1, phone);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        }
        return null;
    }

    /**
     * Retrieves a user from the database by email address.
     *
     * @param email the email to search for
     * @return UserModel if found, null otherwise
     * @throws Exception if a database error occurs
     */
    public UserModel getUserByEmail(String email) throws Exception {
        if (isConnectionError) return null;
        String query = "SELECT * FROM users WHERE email = ?";
        try (PreparedStatement stmt = dbConn.prepareStatement(query)) {
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        }
        return null;
    }

    /**
     * Inserts a new user record into the database.
     *
     * @param user the UserModel containing all registration details
     * @return true if insertion was successful, false otherwise
     * @throws Exception if a database error occurs
     */
    public boolean insertUser(UserModel user) throws Exception {
        if (isConnectionError) return false;
        String query = "INSERT INTO users (first_name, last_name, username, dob, gender, email, phone_number, password, image_path, role, status) "
                     + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = dbConn.prepareStatement(query)) {
            stmt.setString(1, user.getFirstName());
            stmt.setString(2, user.getLastName());
            stmt.setString(3, user.getUsername());
            stmt.setDate(4, Date.valueOf(user.getDob()));
            stmt.setString(5, user.getGender());
            stmt.setString(6, user.getEmail());
            stmt.setString(7, user.getPhoneNumber());
            stmt.setString(8, user.getPassword());
            stmt.setString(9, user.getImagePath());
            stmt.setString(10, Constants.ROLE_USER);
            stmt.setString(11, Constants.STATUS_INACTIVE);
            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Updates an existing user's profile in the database.
     *
     * @param user the UserModel with updated details
     * @return true if update was successful, false otherwise
     * @throws Exception if a database error occurs
     */
    public boolean updateUser(UserModel user) throws Exception {
        if (isConnectionError) return false;
        String query = "UPDATE users SET first_name=?, last_name=?, username=?, dob=?, gender=?, email=?, phone_number=?, password=?"
                     + (user.getImagePath() != null ? ", image_path=?" : "")
                     + " WHERE user_id=?";
        try (PreparedStatement stmt = dbConn.prepareStatement(query)) {
            stmt.setString(1, user.getFirstName());
            stmt.setString(2, user.getLastName()); 
            stmt.setString(3, user.getUsername());
            stmt.setDate(4, Date.valueOf(user.getDob()));
            stmt.setString(5, user.getGender());
            stmt.setString(6, user.getEmail());
            stmt.setString(7, user.getPhoneNumber());
            stmt.setString(8, user.getPassword());
            if (user.getImagePath() != null) {
                stmt.setString(9, user.getImagePath());
                stmt.setInt(10, user.getUserId());
            } else {
                stmt.setInt(9, user.getUserId());
            }
            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Toggles a user's status between 'active' and 'inactive' (soft delete).
     *
     * @param userId    the user's primary key
     * @param newStatus the new status value ("active" or "inactive")
     * @return true if the update was successful, false otherwise
     * @throws Exception if a database error occurs
     */
    /**
     * Updates only the profile fields a user is allowed to edit.
     * Username and email are never changed here.
     * Pass null for newImagePath or newHashedPassword to keep the existing values.
     */
    public boolean updateProfile(int userId, String firstName, String lastName,
                                 String phoneNumber, String gender, java.time.LocalDate dob,
                                 String newImagePath, String newHashedPassword) throws Exception {
        if (isConnectionError) return false;
        String query = "UPDATE users SET first_name=?, last_name=?, phone_number=?, gender=?, dob=?, "
                     + "image_path = COALESCE(?, image_path), "
                     + "password   = COALESCE(?, password) "
                     + "WHERE user_id=?";
        try (PreparedStatement stmt = dbConn.prepareStatement(query)) {
            stmt.setString(1, firstName);
            stmt.setString(2, lastName);
            stmt.setString(3, phoneNumber);
            stmt.setString(4, gender);
            stmt.setDate(5, dob != null ? Date.valueOf(dob) : null);
            stmt.setString(6, newImagePath);       // null → COALESCE keeps old value
            stmt.setString(7, newHashedPassword);  // null → COALESCE keeps old value
            stmt.setInt(8, userId);
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean updateUserStatus(int userId, String newStatus) throws Exception {
        if (isConnectionError) return false;
        String query = "UPDATE users SET status = ? WHERE user_id = ?";
        try (PreparedStatement stmt = dbConn.prepareStatement(query)) {
            stmt.setString(1, newStatus);
            stmt.setInt(2, userId);
            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Retrieves all users from the database (for admin view).
     *
     * @return list of all UserModel objects
     * @throws Exception if a database error occurs
     */
    public List<UserModel> getAllUsers() throws Exception {
        List<UserModel> users = new ArrayList<>();
        if (isConnectionError) return users;
        String query = "SELECT * FROM users ORDER BY user_id DESC";
        try (PreparedStatement stmt = dbConn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
        }
        return users;
    }

    /**
     * Returns the total number of registered users.
     *
     * @return count of users, 0 on error
     */
    public int getTotalUsers() {
        if (isConnectionError) return 0;
        String query = "SELECT COUNT(*) FROM users WHERE role = 'user'";
        try (PreparedStatement stmt = dbConn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
        }
        return 0;
    }

    /**
     * Maps a ResultSet row to a UserModel object.
     *
     * @param rs the ResultSet positioned at the current row
     * @return populated UserModel
     * @throws SQLException if column access fails
     */
    private UserModel mapResultSetToUser(ResultSet rs) throws SQLException {
        UserModel user = new UserModel();
        user.setUserId(rs.getInt("user_id"));
        user.setFirstName(rs.getString("first_name"));
        user.setLastName(rs.getString("last_name"));
        user.setUsername(rs.getString("username"));
        Date dob = rs.getDate("dob");
        if (dob != null) user.setDob(dob.toLocalDate());
        user.setGender(rs.getString("gender"));
        user.setEmail(rs.getString("email"));
        user.setPhoneNumber(rs.getString("phone_number"));
        user.setPassword(rs.getString("password"));
        user.setImagePath(rs.getString("image_path"));
        user.setRole(rs.getString("role"));
        user.setStatus(rs.getString("status"));
        return user;
    }
}
