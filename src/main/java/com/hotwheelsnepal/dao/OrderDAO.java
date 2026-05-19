package com.hotwheelsnepal.dao;

import com.hotwheelsnepal.model.CartItem;
import com.hotwheelsnepal.util.DbConfig;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class OrderDAO {

    private static final Logger LOGGER = Logger.getLogger(OrderDAO.class.getName());

    private Connection dbConn;
    private boolean isConnectionError = false;

    public OrderDAO() {
        try {
            dbConn = DbConfig.getDbConnection();
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
            isConnectionError = true;
        }
    }

    /**
     * Inserts a completed order row and returns the generated order_id.
     *
     * @return the new order_id, or -1 on failure
     */
    public int saveOrder(int userId, String orderRef, double subtotal, double shipping,
                         double vat, double grandTotal, String paymentMethod,
                         String deliveryName, String deliveryPhone,
                         String deliveryAddress, String deliveryCity, String postalCode) {
        if (isConnectionError) return -1;
        String sql = "INSERT INTO orders "
                   + "(user_id, order_ref, subtotal, shipping, vat, grand_total, payment_method, "
                   + " delivery_name, delivery_phone, delivery_address, delivery_city, postal_code) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = dbConn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1,    userId);
            stmt.setString(2, orderRef);
            stmt.setDouble(3, subtotal);
            stmt.setDouble(4, shipping);
            stmt.setDouble(5, vat);
            stmt.setDouble(6, grandTotal);
            stmt.setString(7, paymentMethod);
            stmt.setString(8, deliveryName);
            stmt.setString(9, deliveryPhone);
            stmt.setString(10, deliveryAddress);
            stmt.setString(11, deliveryCity);
            stmt.setString(12, postalCode);
            stmt.executeUpdate();
            try (ResultSet keys = stmt.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
        }
        return -1;
    }

    /**
     * Inserts one order_items row for each CartItem in the list.
     *
     * @return true if all rows were inserted successfully
     */
    public boolean saveOrderItems(int orderId, List<CartItem> items) {
        if (isConnectionError || items == null || items.isEmpty()) return false;
        String sql = "INSERT INTO order_items "
                   + "(order_id, product_id, product_name, unit_price, quantity, subtotal) "
                   + "VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = dbConn.prepareStatement(sql)) {
            for (CartItem item : items) {
                Integer productId = null;
                try { productId = Integer.parseInt(item.getId()); } catch (NumberFormatException ignored) {}
                stmt.setInt(1, orderId);
                if (productId != null) stmt.setInt(2, productId);
                else                   stmt.setNull(2, java.sql.Types.INTEGER);
                stmt.setString(3, item.getName());
                stmt.setDouble(4, item.getPrice());
                stmt.setInt(5,    item.getQuantity());
                stmt.setDouble(6, item.getSubtotal());
                stmt.addBatch();
            }
            int[] results = stmt.executeBatch();
            for (int r : results) {
                if (r == Statement.EXECUTE_FAILED) return false;
            }
            return true;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
            return false;
        }
    }

    /**
     * Creates a pending payment record for the given order.
     * For Cash on Delivery the status stays 'pending'; for
     * digital methods it would be updated once the gateway confirms.
     *
     * @return true if the row was inserted
     */
    public boolean savePayment(int orderId, String paymentMethod, double amount) {
        if (isConnectionError) return false;
        String status = "Cash on Delivery".equals(paymentMethod) ? "pending" : "pending";
        String sql = "INSERT INTO payments (order_id, payment_method, payment_status, amount) "
                   + "VALUES (?, ?, ?, ?)";
        try (PreparedStatement stmt = dbConn.prepareStatement(sql)) {
            stmt.setInt(1,    orderId);
            stmt.setString(2, paymentMethod);
            stmt.setString(3, status);
            stmt.setDouble(4, amount);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
            return false;
        }
    }

    /**
     * Returns the number of orders placed by a given user.
     */
    public int getOrderCountByUser(int userId) {
        if (isConnectionError) return 0;
        String sql = "SELECT COUNT(*) FROM orders WHERE user_id = ?";
        try (PreparedStatement stmt = dbConn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
        }
        return 0;
    }
}
