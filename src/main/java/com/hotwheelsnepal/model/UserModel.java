package com.hotwheelsnepal.model;

import java.time.LocalDate;

/**
 * UserModel is a Plain Old Java Object (POJO) representing a user
 * in the HotWheels Nepal application. Stores personal details and role.
 */
public class UserModel {

    private int userId;
    private String firstName;
    private String lastName;
    private String username;
    private LocalDate dob;
    private String gender;
    private String email;
    private String phoneNumber;
    private String password;
    private String imagePath;
    private String role;   // "admin" or "user"
    private String status; // "active" or "inactive"

    /** Default constructor */
    public UserModel() {}

    /** Constructor for login (username + password only) */
    public UserModel(String username, String password) {
        this.username = username;
        this.password = password;
    }

    /** Full constructor for registration */
    public UserModel(String firstName, String lastName, String username,
                     LocalDate dob, String gender, String email,
                     String phoneNumber, String password, String imagePath) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.username = username;
        this.dob = dob;
        this.gender = gender;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.password = password;
        this.imagePath = imagePath;
    }

    // ---- Getters and Setters ----

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getFirstName() { return firstName; }
    public void setFirstName(String firstName) { this.firstName = firstName; }

    public String getLastName() { return lastName; }
    public void setLastName(String lastName) { this.lastName = lastName; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public LocalDate getDob() { return dob; }
    public void setDob(LocalDate dob) { this.dob = dob; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getImagePath() { return imagePath; }
    public void setImagePath(String imagePath) { this.imagePath = imagePath; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
