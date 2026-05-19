-- ============================================================
--  HotWheels Nepal  –  MySQL Database Schema  (12 entities)
--  Database : hotwheelsnepal
--  Import in phpMyAdmin: Database > Import > select this file
-- ============================================================

CREATE DATABASE IF NOT EXISTS hotwheelsnepal
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

USE hotwheelsnepal;

-- ============================================================
-- TABLE 1 : users
--   Stores every registered customer and admin account.
-- ============================================================
CREATE TABLE IF NOT EXISTS users (
    user_id      INT          NOT NULL AUTO_INCREMENT,
    first_name   VARCHAR(50)  NOT NULL,
    last_name    VARCHAR(50)  NOT NULL,
    username     VARCHAR(50)  NOT NULL,
    dob          DATE         NOT NULL,
    gender       VARCHAR(10)  NOT NULL,
    email        VARCHAR(100) NOT NULL,
    phone_number VARCHAR(15)  NOT NULL,
    password     VARCHAR(255) NOT NULL,
    image_path   VARCHAR(255) DEFAULT NULL,
    role         VARCHAR(10)  NOT NULL DEFAULT 'user',
    status       VARCHAR(10)  NOT NULL DEFAULT 'inactive',
    created_at   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (user_id),
    UNIQUE KEY uq_username (username),
    UNIQUE KEY uq_email    (email),
    CONSTRAINT chk_users_role   CHECK (role   IN ('admin', 'user')),
    CONSTRAINT chk_users_status CHECK (status IN ('active', 'inactive'))
) ENGINE=InnoDB;

-- ============================================================
-- TABLE 2 : categories
--   Hot Wheels series / collection names.
--   Replaces the old free-text "series" column in products.
-- ============================================================
CREATE TABLE IF NOT EXISTS categories (
    category_id  INT          NOT NULL AUTO_INCREMENT,
    name         VARCHAR(100) NOT NULL,
    description  TEXT         DEFAULT NULL,
    created_at   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (category_id),
    UNIQUE KEY uq_category_name (name)
) ENGINE=InnoDB;

-- ============================================================
-- TABLE 3 : coupons
--   Promotional discount codes that can be applied at checkout.
--   category_id (FK → categories) optionally restricts the
--   coupon to a specific Hot Wheels series.  NULL = applies to
--   all products regardless of category.
-- ============================================================
CREATE TABLE IF NOT EXISTS coupons (
    coupon_id      INT            NOT NULL AUTO_INCREMENT,
    category_id    INT            DEFAULT NULL,
    code           VARCHAR(50)    NOT NULL,
    discount_type  VARCHAR(10)    NOT NULL DEFAULT 'percentage',
    discount_value DECIMAL(10,2)  NOT NULL,
    min_order_amt  DECIMAL(10,2)  NOT NULL DEFAULT 0.00,
    max_uses       INT            DEFAULT NULL,
    uses_count     INT            NOT NULL DEFAULT 0,
    is_active      TINYINT(1)     NOT NULL DEFAULT 1,
    expires_at     DATETIME       DEFAULT NULL,
    created_at     TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (coupon_id),
    UNIQUE KEY uq_coupon_code (code),
    CONSTRAINT fk_coupons_category
        FOREIGN KEY (category_id) REFERENCES categories(category_id)
        ON DELETE SET NULL,
    CONSTRAINT chk_discount_type  CHECK (discount_type  IN ('percentage', 'fixed')),
    CONSTRAINT chk_discount_value CHECK (discount_value > 0)
) ENGINE=InnoDB;

-- ============================================================
-- TABLE 4 : products
--   Individual Hot Wheels die-cast cars available in the store.
--   category_id references categories (SET NULL if deleted).
-- ============================================================
CREATE TABLE IF NOT EXISTS products (
    product_id   INT            NOT NULL AUTO_INCREMENT,
    category_id  INT            DEFAULT NULL,
    name         VARCHAR(100)   NOT NULL,
    description  TEXT           DEFAULT NULL,
    price        DECIMAL(10,2)  NOT NULL,
    stock        INT            NOT NULL DEFAULT 0,
    image_name   VARCHAR(255)   DEFAULT NULL,
    created_at   TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (product_id),
    CONSTRAINT fk_products_category
        FOREIGN KEY (category_id) REFERENCES categories(category_id)
        ON DELETE SET NULL,
    CONSTRAINT chk_product_price CHECK (price  >  0),
    CONSTRAINT chk_product_stock CHECK (stock  >= 0)
) ENGINE=InnoDB;

-- ============================================================
-- TABLE 5 : product_images
--   Supports multiple images per product.
--   is_primary = 1 marks the main display image.
-- ============================================================
CREATE TABLE IF NOT EXISTS product_images (
    image_id     INT          NOT NULL AUTO_INCREMENT,
    product_id   INT          NOT NULL,
    image_name   VARCHAR(255) NOT NULL,
    is_primary   TINYINT(1)   NOT NULL DEFAULT 0,
    sort_order   INT          NOT NULL DEFAULT 0,
    uploaded_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (image_id),
    CONSTRAINT fk_product_images_product
        FOREIGN KEY (product_id) REFERENCES products(product_id)
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- ============================================================
-- TABLE 6 : addresses
--   Saved delivery addresses belonging to a user.
--   is_default = 1 marks the preferred shipping address.
-- ============================================================
CREATE TABLE IF NOT EXISTS addresses (
    address_id   INT          NOT NULL AUTO_INCREMENT,
    user_id      INT          NOT NULL,
    full_name    VARCHAR(100) NOT NULL,
    phone        VARCHAR(20)  NOT NULL,
    address_line VARCHAR(255) NOT NULL,
    city         VARCHAR(100) NOT NULL,
    postal_code  VARCHAR(20)  DEFAULT NULL,
    is_default   TINYINT(1)   NOT NULL DEFAULT 0,
    created_at   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (address_id),
    CONSTRAINT fk_addresses_user
        FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- ============================================================
-- TABLE 7 : orders
--   One row per completed checkout session.
--   address_id  = optional link to the saved address used.
--   coupon_id   = optional coupon that was applied.
--   Delivery snapshot fields are always stored so order
--   history stays intact even if the saved address is removed.
-- ============================================================
CREATE TABLE IF NOT EXISTS orders (
    order_id         INT            NOT NULL AUTO_INCREMENT,
    user_id          INT            NOT NULL,
    address_id       INT            DEFAULT NULL,
    coupon_id        INT            DEFAULT NULL,
    order_ref        VARCHAR(20)    NOT NULL,
    status           VARCHAR(20)    NOT NULL DEFAULT 'pending',
    subtotal         DECIMAL(10,2)  NOT NULL,
    discount_amount  DECIMAL(10,2)  NOT NULL DEFAULT 0.00,
    shipping         DECIMAL(10,2)  NOT NULL DEFAULT 0.00,
    vat              DECIMAL(10,2)  NOT NULL DEFAULT 0.00,
    grand_total      DECIMAL(10,2)  NOT NULL,
    payment_method   VARCHAR(50)    NOT NULL,
    delivery_name    VARCHAR(100)   DEFAULT NULL,
    delivery_phone   VARCHAR(20)    DEFAULT NULL,
    delivery_address VARCHAR(255)   DEFAULT NULL,
    delivery_city    VARCHAR(100)   DEFAULT NULL,
    postal_code      VARCHAR(20)    DEFAULT NULL,
    created_at       TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (order_id),
    UNIQUE KEY uq_order_ref (order_ref),
    CONSTRAINT fk_orders_user
        FOREIGN KEY (user_id)    REFERENCES users(user_id)     ON DELETE CASCADE,
    CONSTRAINT fk_orders_address
        FOREIGN KEY (address_id) REFERENCES addresses(address_id) ON DELETE SET NULL,
    CONSTRAINT fk_orders_coupon
        FOREIGN KEY (coupon_id)  REFERENCES coupons(coupon_id)    ON DELETE SET NULL,
    CONSTRAINT chk_order_status CHECK (
        status IN ('pending', 'confirmed', 'shipped', 'delivered', 'cancelled')
    )
) ENGINE=InnoDB;

-- ============================================================
-- TABLE 8 : order_items
--   One row per product line inside an order.
--   Stores a price snapshot so history is correct even if
--   the product price changes or the product is deleted later.
-- ============================================================
CREATE TABLE IF NOT EXISTS order_items (
    item_id      INT            NOT NULL AUTO_INCREMENT,
    order_id     INT            NOT NULL,
    product_id   INT            DEFAULT NULL,
    product_name VARCHAR(100)   NOT NULL,
    unit_price   DECIMAL(10,2)  NOT NULL,
    quantity     INT            NOT NULL,
    subtotal     DECIMAL(10,2)  NOT NULL,

    PRIMARY KEY (item_id),
    CONSTRAINT fk_order_items_order
        FOREIGN KEY (order_id)   REFERENCES orders(order_id)     ON DELETE CASCADE,
    CONSTRAINT fk_order_items_product
        FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE SET NULL,
    CONSTRAINT chk_item_quantity CHECK (quantity   > 0),
    CONSTRAINT chk_item_price    CHECK (unit_price >= 0)
) ENGINE=InnoDB;

-- ============================================================
-- TABLE 9 : payments
--   Tracks the payment transaction for each order.
--   payment_status moves from pending → completed / failed.
--   transaction_ref stores the external gateway reference
--   (e.g. eSewa TXN ID, Khalti token, card auth code).
-- ============================================================
CREATE TABLE IF NOT EXISTS payments (
    payment_id      INT            NOT NULL AUTO_INCREMENT,
    order_id        INT            NOT NULL,
    payment_method  VARCHAR(50)    NOT NULL,
    payment_status  VARCHAR(20)    NOT NULL DEFAULT 'pending',
    transaction_ref VARCHAR(100)   DEFAULT NULL,
    amount          DECIMAL(10,2)  NOT NULL,
    paid_at         DATETIME       DEFAULT NULL,
    created_at      TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (payment_id),
    UNIQUE KEY uq_payment_order (order_id),
    CONSTRAINT fk_payments_order
        FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    CONSTRAINT chk_payment_status CHECK (
        payment_status IN ('pending', 'completed', 'failed', 'refunded')
    )
) ENGINE=InnoDB;

-- ============================================================
-- TABLE 10 : reviews
--   Customers rate and review a product after purchase.
--   A user can leave only one review per product (UNIQUE key).
-- ============================================================
CREATE TABLE IF NOT EXISTS reviews (
    review_id   INT          NOT NULL AUTO_INCREMENT,
    product_id  INT          NOT NULL,
    user_id     INT          NOT NULL,
    rating      TINYINT      NOT NULL,
    title       VARCHAR(150) DEFAULT NULL,
    body        TEXT         DEFAULT NULL,
    created_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (review_id),
    UNIQUE KEY uq_one_review_per_product (product_id, user_id),
    CONSTRAINT fk_reviews_product
        FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    CONSTRAINT fk_reviews_user
        FOREIGN KEY (user_id)    REFERENCES users(user_id)       ON DELETE CASCADE,
    CONSTRAINT chk_rating CHECK (rating BETWEEN 1 AND 5)
) ENGINE=InnoDB;

-- ============================================================
-- TABLE 11 : wishlists
--   Products that a logged-in user saves for later.
--   Composite unique key prevents duplicates per user.
-- ============================================================
CREATE TABLE IF NOT EXISTS wishlists (
    wishlist_id INT       NOT NULL AUTO_INCREMENT,
    user_id     INT       NOT NULL,
    product_id  INT       NOT NULL,
    added_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (wishlist_id),
    UNIQUE KEY uq_wishlist_item (user_id, product_id),
    CONSTRAINT fk_wishlists_user
        FOREIGN KEY (user_id)    REFERENCES users(user_id)       ON DELETE CASCADE,
    CONSTRAINT fk_wishlists_product
        FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ============================================================
-- TABLE 12 : contact_messages
--   Submissions from the Contact Us page.
--   user_id is nullable so guests can also submit messages.
-- ============================================================
CREATE TABLE IF NOT EXISTS contact_messages (
    message_id  INT          NOT NULL AUTO_INCREMENT,
    user_id     INT          DEFAULT NULL,
    name        VARCHAR(100) NOT NULL,
    email       VARCHAR(100) NOT NULL,
    subject     VARCHAR(200) DEFAULT NULL,
    message     TEXT         NOT NULL,
    is_read     TINYINT(1)   NOT NULL DEFAULT 0,
    sent_at     TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (message_id),
    CONSTRAINT fk_contact_messages_user
        FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- ============================================================
-- SEED DATA
-- ============================================================

-- Hot Wheels series categories
INSERT INTO categories (name, description) VALUES
('Mainline',            'Standard Hot Wheels die-cast cars, released year-round'),
('Car Culture',         'Premium themed assortments designed for adult collectors'),
('Hot Wheels Premium',  'Higher-end models with real rider tyres and metal bases'),
('Treasure Hunt',       'Hard-to-find models with special finishes and the $ logo'),
('Super Treasure Hunt', 'Ultra-rare chase cars with Spectraflame paint and Real Riders'),
('Team Transport',      'Car and matching transporter truck two-pack sets');

-- Sample coupon codes
INSERT INTO coupons (code, discount_type, discount_value, min_order_amt, max_uses, expires_at) VALUES
('WELCOME10', 'percentage', 10.00, 500.00,  100, '2026-12-31 23:59:59'),
('FLAT50',    'fixed',      50.00, 1000.00, 50,  '2026-06-30 23:59:59');

-- Default admin account   (password: Admin@1234)
INSERT INTO users (first_name, last_name, username, dob, gender, email, phone_number, password, role, status)
VALUES ('Admin', 'HotWheelsNepal', 'admin', '1990-01-01', 'Other',
        'admin@hotwheelsnepal.com', '9800000000',
        '$2a$12$7QH6q1V1g0VEVThVV0cN8.H3jz0zLy7PJnbHXb2KHjVfG4EXL3lNG',
        'admin', 'active');

-- Sample Hot Wheels products
INSERT INTO products (name, description, price, stock, image_name, category_id) VALUES
('Bone Shaker',
 'Classic collectible car with iconic skull design, a must-have for every collector.',
 6.99, 25, 'img1.jpg',
 (SELECT category_id FROM categories WHERE name = 'Mainline')),

('Twin Mill',
 'Iconic twin-engine car, speed-ready for your Hot Wheels tracks.',
 7.99, 20, 'img2.jpeg',
 (SELECT category_id FROM categories WHERE name = 'Car Culture')),

('Hot Truck',
 'Cool truck design with oversized wheels, great for stunts and track fun.',
 8.49, 15, 'img3.jpeg',
 (SELECT category_id FROM categories WHERE name = 'Mainline')),

('Speed Racer',
 'High-speed race car built for dominating any Hot Wheels track.',
 9.99, 30, 'img4.jpeg',
 (SELECT category_id FROM categories WHERE name = 'Hot Wheels Premium')),

('Dragon Blaster',
 'Fire-themed dragster with aggressive styling and chrome details.',
 11.99, 10, 'img5.jpeg',
 (SELECT category_id FROM categories WHERE name = 'Treasure Hunt')),

('Street Shaker',
 'Low-profile street car with slick matte finish, perfect for collectors.',
 7.49, 18, 'img1.jpg',
 (SELECT category_id FROM categories WHERE name = 'Mainline')),

('Nitro Doorslammer',
 'Quarter-mile dominator with oversized rear tyres and drag race livery.',
 12.99, 8, 'img2.jpeg',
 (SELECT category_id FROM categories WHERE name = 'Super Treasure Hunt')),

('Canyon Carver',
 'Off-road beast with lifted suspension and mud terrain tyres.',
 8.99, 22, 'img3.jpeg',
 (SELECT category_id FROM categories WHERE name = 'Team Transport'));

-- Primary product images (one per product, matching the image_name already on each row)
INSERT INTO product_images (product_id, image_name, is_primary, sort_order)
SELECT product_id, image_name, 1, 0
FROM   products
WHERE  image_name IS NOT NULL;
