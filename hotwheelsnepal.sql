-- ============================================================
--  HotWheels Nepal - MySQL Database Schema
--  Database : hotwheelsnepal
--  Run this file in phpMyAdmin (XAMPP) or MySQL Workbench
-- ============================================================

CREATE DATABASE IF NOT EXISTS hotwheelsnepal
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

USE hotwheelsnepal;

-- ============================================================
-- 1. USERS TABLE
-- ============================================================
CREATE TABLE IF NOT EXISTS users (
    user_id      INT          NOT NULL AUTO_INCREMENT,
    first_name   VARCHAR(50)  NOT NULL,
    last_name    VARCHAR(50)  NOT NULL,
    username     VARCHAR(50)  NOT NULL UNIQUE,
    dob          DATE         NOT NULL,
    gender       VARCHAR(10)  NOT NULL,
    email        VARCHAR(100) NOT NULL UNIQUE,
    phone_number VARCHAR(15)  NOT NULL,
    password     VARCHAR(255) NOT NULL,          -- BCrypt hash
    image_path   VARCHAR(255) DEFAULT NULL,
    role         VARCHAR(10)  NOT NULL DEFAULT 'user',  -- 'admin' or 'user'
    created_at   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (user_id),
    CONSTRAINT chk_role CHECK (role IN ('admin', 'user'))
) ENGINE=InnoDB;

-- ============================================================
-- 2. PRODUCTS TABLE
-- ============================================================
CREATE TABLE IF NOT EXISTS products (
    product_id   INT            NOT NULL AUTO_INCREMENT,
    name         VARCHAR(100)   NOT NULL,
    description  TEXT           DEFAULT NULL,
    price        DECIMAL(10, 2) NOT NULL,
    stock        INT            NOT NULL DEFAULT 0,
    image_name   VARCHAR(255)   DEFAULT NULL,
    series       VARCHAR(100)   DEFAULT NULL,
    created_at   TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (product_id),
    CONSTRAINT chk_price CHECK (price > 0),
    CONSTRAINT chk_stock CHECK (stock >= 0)
) ENGINE=InnoDB;

-- ============================================================
-- 3. CONTACT MESSAGES TABLE
-- ============================================================
CREATE TABLE IF NOT EXISTS contact_messages (
    message_id  INT          NOT NULL AUTO_INCREMENT,
    name        VARCHAR(100) NOT NULL,
    email       VARCHAR(100) NOT NULL,
    subject     VARCHAR(200) DEFAULT NULL,
    message     TEXT         NOT NULL,
    sent_at     TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (message_id)
) ENGINE=InnoDB;

-- ============================================================
-- SEED DATA
-- ============================================================

-- Default admin account
-- Password: Admin@1234  (BCrypt hash below)
INSERT INTO users (first_name, last_name, username, dob, gender, email, phone_number, password, role)
VALUES (
    'Admin',
    'MiniMotors',
    'admin',
    '1990-01-01',
    'Other',
    'admin@minimotors.com',
    '9800000000',
    '$2a$12$7QH6q1V1g0VEVThVV0cN8.H3jz0zLy7PJnbHXb2KHjVfG4EXL3lNG',
    'admin'
);

-- Sample Hot Wheels products
INSERT INTO products (name, description, price, stock, image_name, series) VALUES
('Bone Shaker',
 'Classic collectible car with iconic skull design, a must-have for every collector.',
 6.99, 25, 'img1.jpg', 'Mainline'),

('Twin Mill',
 'Iconic twin-engine car, speed-ready for your Hot Wheels tracks.',
 7.99, 20, 'img2.jpeg', 'Car Culture'),

('Hot Truck',
 'Cool truck design with oversized wheels, great for stunts and track fun.',
 8.49, 15, 'img3.jpeg', 'Mainline'),

('Speed Racer',
 'High-speed race car built for dominating any Hot Wheels track.',
 9.99, 30, 'img4.jpeg', 'Hot Wheels Premium'),

('Dragon Blaster',
 'Fire-themed dragster with aggressive styling and chrome details.',
 11.99, 10, 'img5.jpeg', 'Treasure Hunt'),

('Street Shaker',
 'Low-profile street car with slick matte finish, perfect for collectors.',
 7.49, 18, 'img1.jpg', 'Mainline'),

('Nitro Doorslammer',
 'Quarter-mile dominator with oversized rear tyres and drag race livery.',
 12.99, 8, 'img2.jpeg', 'Super Treasure Hunt'),

('Canyon Carver',
 'Off-road beast with lifted suspension and mud terrain tyres.',
 8.99, 22, 'img3.jpeg', 'Team Transport');
